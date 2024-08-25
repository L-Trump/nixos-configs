{ config, pkgs, lib, ... }:

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
  ];

  home = {
    username = "ltrump";
    homeDirectory = "/home/ltrump";

    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;

}
