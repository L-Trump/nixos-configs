{ config, pkgs, lib, ... }:

{
  programs.neovim.nvimdots = {
    enable = true;
    mergeLazyLock = true;
    setBuildEnv = true;
    withBuildTools = true;
  };
  home.sessionVariables = {
    EDITOR = "nvim";
    SYSTEMD_EDITOR = "nvim";
  };
}
