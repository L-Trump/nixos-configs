{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  versionCheckHook,
}:

# 写法对齐 llm-agents.nix 的 packages/sidecar/package.nix（tag 而非 rev、
# versionCheckHook、passthru.category、changelog），两处刻意保留的差异：
#   1. buildGo127Module：sidecar 的 go.mod 从 v1.4.0 起要求 go 1.27，
#      而 nixpkgs 默认 go 仍是 1.26（GOTOOLCHAIN=local 下直接构建失败）。
#   2. ldflags 多打 Dirty/BuildProfile，照上游 .goreleaser.yml 的发行版注入，
#      否则 `sidecar --version` 显示空 profile、内置更新提示行为也不一致。
buildGo127Module rec {
  pname = "sidecar";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "marcus";
    repo = "sidecar";
    tag = "v${version}";
    hash = "sha256-CRU8goMGWUbELCSVsDYDFk24VkTuDTt0waVlm92PNsM=";
  };

  subPackages = [ "cmd/sidecar" ];

  vendorHash = "sha256-VOnnjbhOdQBhxIPRkBUKoKX0OpW3PXcOJudsZPJuDMY=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
    "-X main.Dirty=false"
    "-X main.BuildProfile=release"
  ];

  # 保留 cgo（nixpkgs 的 go 默认 CGO_ENABLED=1）：cmd/sidecar 经
  # mattn/go-sqlite3 读 codex/kiro/opencode 等会话库，上游 goreleaser 的
  # 官方归档用 CGO_ENABLED=0，编出来的只是 sqlite stub。
  #
  # 测试套件需要真实 tmux server / pty，不适合在 Nix 构建沙箱里跑。
  doCheck = false;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.category = "Workflow & Project Management";

  # 本仓库自用：仓库级 update-source-version 无法求值 packages/default.nix。
  passthru.updateScript = ./update.sh;

  meta = {
    description = "Terminal-based development companion for AI coding agents";
    homepage = "https://github.com/marcus/sidecar";
    changelog = "https://github.com/marcus/sidecar/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ltrump ];
    mainProgram = "sidecar";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
