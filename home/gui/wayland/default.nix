{
  pkgs,
  config,
  lib,
  mylib,
  myhome,
  ...
}:
let
  wallpaper_umy = builtins.path { path = ../../../wallpapers/Meumy/91689568_p1.jpg; };
  wallpaper_merry = builtins.path { path = ../../../wallpapers/Meumy/91689568_p6.jpg; };
  cfg.niri = myhome.desktop.niri;
  cfg.hyprland = myhome.desktop.hyprland;
  cfg.enable = cfg.niri.enable || cfg.hyprland.enable;
in
{
  imports = [
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
      package = pkgs.rofi;
    };

    home.packages = with pkgs; [
      hyprpicker
      snipaste
      wl-clipboard-rs
      grim
      slurp
      swappy
      copyq
      dex
      acpi
      mpvpaper
    ];

    xdg.configFile."uwsm/env".text = ''
      export NIXOS_OZONE_WL="1";
      export XMODIFIERS="@im=fcitx";
      export QT_IM_MODULE="fcitx";
      export QT_IM_MODULES="wayland;fcitx;ibus";
      # GUI Toolkit backend
      export GDK_BACKEND="wayland,x11,*";
      export QT_QPA_PLATFORM="wayland;xcb";
      export QT_AUTO_SCREEN_SCALE_FACTOR="1";
      # Session Type env
      export XDG_SESSION_TYPE="wayland";
      export # Locale
      export LANG="en_GB.UTF-8";
      export LANGUAGE="zh_CN.UTF-8";
    '';

    services.hyprpaper = {
      enable = true;
      settings = {
        wallpaper = [
          {
            monitor = "HDMI-A-1";
            path = wallpaper_merry;
          }
          {
            monitor = "";
            path = wallpaper_umy;
          }
        ];
      };
    };
  };
}
