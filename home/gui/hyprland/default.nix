{
  config,
  inputs,
  lib,
  pkgs,
  myhome,
  ...
}:
with lib; let
  wallpaper_umy = builtins.path {path = ../../../wallpapers/Meumy/91689568_p1.jpg;};
  wallpaper_merry = builtins.path {path = ../../../wallpapers/Meumy/91689568_p6.jpg;};
  rawcfg = myhome.desktop.wayland;
  cfg = config.myhome.desktop.wayland;
in {
  imports = optionals rawcfg.enable [
    ./waybar
    ./swaylock.nix
  ];

  config = mkIf cfg.enable {
    home.pointerCursor.x11.enable = true;

    wayland.windowManager.hyprland = import ./hyprland-conf.nix {inherit pkgs inputs;};

    programs.fish = {
      interactiveShellInit = ''
        # auto login
        # if uwsm check may-start
        #   uwsm start hyprland-uwsm.desktop
        # end
        if test -z $DISPLAY; and test -n "$XDG_VTNR"; and test $XDG_VTNR -eq 1; and test "$(tty)" = "/dev/tty1"; and test "$(fgconsole 2>/dev/null || echo 1)" -eq 1
            Hyprland
        end
      '';
    };

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

    # services.clipman.enable = true;

    # programs.hyprlock = import ./hyprlock-conf.nix { };

    services.hypridle = {
      enable = true;
      settings = {
        general = {
          before_sleep_cmd = "swaylock";
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
          lock_cmd = "swaylock";
          unlock_cmd = "pkill -USR1 swaylock";
        };

        listener = [
          {
            timeout = 600;
            on-timeout = "swaylock";
          }
          {
            timeout = 1200;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
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

    programs.rofi = {
      enable = true;
      extraConfig.dpi = lib.mkForce 96;
      package = pkgs.rofi-wayland;
    };
  };
}
