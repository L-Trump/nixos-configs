{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.mymodules.desktop;
in
{
  config = lib.mkIf cfg.niri.enable {
    programs.niri.enable = true;
    environment.systemPackages = with pkgs; [
      wl-clipboard-rs
      xwayland-satellite
      quickshell
    ];
    nix.settings = {
      substituters = [
        "https://niri-epireyn.cachix.org"
        "https://nix-cache.duxlabs.dev"
      ];
      trusted-public-keys = [
        "niri-epireyn.cachix.org-1:tlVyFN7CtsDT+ZcLPS+ekFWeT1X6X4OqvWqbBMyIzFA="
        "dux-1:lrBykuzHKu9F6WsCbK83C9/uOrfqUY1kflRZtrUcMF0="
      ];
    };
  };
}
