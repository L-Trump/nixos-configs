{
  config,
  lib,
  pkgs,
  mylib,
  ...
}:
with lib; let
  cfg = config.myhome.desktop.niri;
in {
  config = mkIf cfg.enable {
    myhome.desktop.niri.settings = import ./niri-conf.nix;

    xdg.configFile."niri/config.kdl".source = pkgs.writeText "config.kdl" (
      mylib.toKDL cfg.settings
    );

    programs.fish = {
      interactiveShellInit = ''
        # auto login
        # if uwsm check may-start
        #   uwsm start hyprland-uwsm.desktop
        # end
        if test -z $DISPLAY; and test -n "$XDG_VTNR"; and test $XDG_VTNR -eq 1; and test "$(tty)" = "/dev/tty1"; and test "$(fgconsole 2>/dev/null || echo 1)" -eq 1
            niri-session
        end
      '';
    };

    services.hypridle = lib.mkForce {
      enable = true;
      settings = {
        general = {
          before_sleep_cmd = "swaylock";
          after_sleep_cmd = "niri msg action power-off-monitors";
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
            on-timeout = "niri msg action power-off-monitors";
            on-resume = "niri msg action power-on-monitors";
          }
        ];
      };
    };
  };
}
