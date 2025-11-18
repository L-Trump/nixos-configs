{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.myhome.desktop.hyprland;
in
{
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = import ./hyprland-conf.nix { inherit pkgs inputs; };
    home.packages = with pkgs; [
      grimblast
    ];
    xdg.portal = {
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
      ];
      config = {
        hyprland = {
          default = [
            "hyprland"
            "gtk"
          ];
          "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
          # "org.freedesktop.impl.portal.Screenshot" = ["wlr"];
        };
      };
    };

    # programs.fish = {
    #   interactiveShellInit = ''
    #     # auto login
    #     # if uwsm check may-start
    #     #   uwsm start hyprland-uwsm.desktop
    #     # end
    #     if test -z $DISPLAY; and test -n "$XDG_VTNR"; and test $XDG_VTNR -eq 1; and test "$(tty)" = "/dev/tty1"; and test "$(fgconsole 2>/dev/null || echo 1)" -eq 1
    #         Hyprland
    #     end
    #   '';
    # };

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
  };
}
