{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  versionCheckHook,
}:

# 与 llm-agents.nix 里 sidecar/td 的写法一致（tag 而非 rev、versionCheckHook、
# passthru.category、changelog 都要有），区别只有一处：用 buildGo127Module。
# td 的 go.mod 从 v0.63.0 起要求 go 1.27，而 nixpkgs 默认 go 仍是 1.26。
buildGo127Module rec {
  pname = "td";
  version = "0.65.0";

  src = fetchFromGitHub {
    owner = "marcus";
    repo = "td";
    tag = "v${version}";
    hash = "sha256-Qausm1RXJAqS1+KHAzP8o+vBxdttUwfEjMAdunmCKvo=";
  };

  vendorHash = "sha256-/IWBYL+WfLz7vDdUs//0KY8rb9mOv4S1jBXCZbYxJRo=";

  # 上游 Makefile 的 `make install` 就是这一条。
  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  # 上游测试要 git/sqlite harness 和 TD_FEATURE_* 环境，不适合构建沙箱。
  doCheck = false;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.category = "Workflow & Project Management";

  # 本仓库自用：仓库级 update-source-version 无法求值 packages/default.nix。
  passthru.updateScript = ./update.sh;

  meta = {
    description = "Minimalist CLI for tracking tasks across AI coding sessions";
    homepage = "https://github.com/marcus/td";
    changelog = "https://github.com/marcus/td/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ltrump ];
    mainProgram = "td";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    # 注意：这个 `td` 会覆盖 nixpkgs 里同名但无关的 Treasure Data CLI。
  };
}
