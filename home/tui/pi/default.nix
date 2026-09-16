{
  myvars,
  config,
  lib,
  myhome,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.myhome.tuiExtra.pi;

  # TODO
  # pi.nix 的 coding-agent/package.nix 仍在按旧名取 `typescript-go` 参数，
  # 而 nixpkgs 已把该包改名为 `typescript`（typescript_7，Go 版 tsc），
  # 旧名现在是会直接 throw 的 alias，故在此把参数替换掉。
  piPackage = inputs.pi.packages.${pkgs.stdenv.hostPlatform.system}.coding-agent.override {
    typescript-go = pkgs.typescript;
  };
in
{
  # 引入 pi.nix 的 Home Manager 模块，提供 programs.pi.coding-agent 选项。
  imports = [
    inputs.pi.homeModules.coding-agent
  ];

  # 仅在用户配置启用 Pi agent 时渲染下方配置。
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ yt-dlp ];
    programs.pi.coding-agent = {
      enable = true;
      package = piPackage;
    };
  };
}
