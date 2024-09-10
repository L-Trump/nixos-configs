{ config, myvars, pkgs, lib, inputs, ... }:

{
  imports = [
    ./fcitx5
    ./i3
    ./programs
    ./mail
    ./neovim
    ./shell
    ./scripts
    ./appearance
    ./hyprland

    inputs.agenix.homeManagerModules.default
    inputs.nvimdots.homeManagerModules.nvimdots
    inputs.lan-mouse.homeManagerModules.default
  ];

  home = {
    username = myvars.username;
    homeDirectory = "/home/${myvars.username}";

    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;
}
