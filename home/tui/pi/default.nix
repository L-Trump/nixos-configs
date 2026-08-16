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
    };
  };
}
