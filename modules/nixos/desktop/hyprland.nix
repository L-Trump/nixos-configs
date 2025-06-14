# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.mymodules.desktop.wayland;
in {
  config = lib.mkIf cfg.enable {
    programs.hyprland.enable = true;
    programs.niri.enable = true;
    # programs.hyprland.withUWSM = true;
    environment.systemPackages = with pkgs; [
      wl-clipboard-rs
      xwayland-satellite
    ];
    nix.settings = {
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
  };
}
