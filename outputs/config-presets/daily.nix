{lib, ...}: let
  bare = import ./bare.nix {inherit lib;};
in
  lib.recursiveUpdate bare {
    mymodules = {
      virtualization = {
        enable = true;
        docker.enable = true;
      };
      desktop = {
        enable = true;
        animeboot.enable = true;
        wayland.enable = true;
        xorg.enable = true;
        game.enable = false;
        keyremap.enable = true;
        remote-desktop.sunshine.enable = true;
      };
      server = {
        easytier.enable = true;
      };
    };

    myhome = {
      tuiExtra = {
        enable = true;
        mail.enable = true;
        lsp.enable = true;
        lsp.lang = ["all"];
      };
      desktop = {
        enable = true;
        wayland.enable = true;
        xorg.enable = true;
        daily.enable = true;
        daily.game.enable = false;
      };
    };
  }
