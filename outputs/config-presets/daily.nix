{ lib, ... }:
let
  bare = import ./bare.nix { inherit lib; };
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
      niri.enable = true;
      game.enable = false;
      keyremap.enable = true;
      remote-desktop.sunshine.enable = true;
      remote-desktop.rustdesk.enable = true;
    };
    server = {
      easytier.enable = true;
    };
  };

  myhome = {
    tuiExtra = {
      enable = true;
      mail.enable = true;
      pi.enable = true;
      lsp.enable = true;
      lsp.lang = [ "all" ];
    };
    desktop = {
      enable = true;
      niri.enable = true;
      daily.enable = true;
      daily.game.enable = false;
    };
  };
}
