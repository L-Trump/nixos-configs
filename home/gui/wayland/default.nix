{
  pkgs,
  config,
  lib,
  mylib,
  myhome,
  ...
}: let
  wallpaper_umy = builtins.path {path = ../../../wallpapers/Meumy/91689568_p1.jpg;};
  wallpaper_merry = builtins.path {path = ../../../wallpapers/Meumy/91689568_p6.jpg;};
  cfg.niri = myhome.desktop.niri;
  cfg.hyprland = myhome.desktop.hyprland;
  cfg.enable = cfg.niri.enable || cfg.hyprland.enable;
in {
  imports =
    [
      ./niri
      ./hyprland
    ]
    ++ lib.optionals cfg.enable [
      ./waybar
      ./swaylock.nix
    ];
  config = lib.mkIf cfg.enable {
    home.pointerCursor.x11.enable = true;
    programs.rofi = {
      enable = true;
      extraConfig.dpi = lib.mkForce 96;
      package = pkgs.rofi-wayland;
    };
    home.packages = with pkgs; [
      hyprpicker
      snipaste
      wl-clipboard-rs
      grim
      slurp
      grimblast
      swappy
      copyq
      dex
      acpi
    ];
    services.hyprpaper = {
      enable = true;
      settings = {
        preload = [
          wallpaper_umy
          wallpaper_merry
        ];
        wallpaper = [
          ",${wallpaper_umy}"
          "HDMI-A-1,${wallpaper_merry}"
        ];
      };
    };
  };
}
