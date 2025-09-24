# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
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
  config = lib.mkMerge [
    (lib.mkIf cfg.hyprland.enable {
      programs.hyprland.enable = true;
      # programs.hyprland.withUWSM = true;
      environment.systemPackages = with pkgs; [
        wl-clipboard-rs
        xwayland-satellite
      ];
      nix.settings = {
        substituters = [ "https://hyprland.cachix.org" ];
        trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
      };
    })
    (lib.mkIf cfg.niri.enable {
      programs.niri.enable = true;
      programs.uwsm.enable = true;
      programs.uwsm.waylandCompositors = {
        niri = {
          prettyName = "Niri";
          comment = "Niri compositor managed by UWSM";
          binPath = "/run/current-system/sw/bin/niri";
        };
      };
      environment.systemPackages = with pkgs; [
        wl-clipboard-rs
        xwayland-satellite
      ];
    })
  ];
}
