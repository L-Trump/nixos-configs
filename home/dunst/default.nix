{ config, pkgs, lib, ... }:

{
  services.dunst = {
    enable = true;
    configFile = "${config.xdg.configHome}/dunst/dunstrc.mutable";
    settings = {
      global = {
        follow = "keyboard";
        origin = "top-center";
        transparency = 15;
        frame_color = "#d94085";
        font = "Monospace 12";
        dmenu = "${pkgs.rofi}/bin/rofi -dpi 192 -dmenu -p dunst:";
        browser = "${pkgs.xdg-utils}/bin/xdg-open";
        corner_radius = 15;
        mouse_left_click = "do_action, close_current";
        mouse_right_click = "close_current";
      };
      urgency_low = {
        foreground = "#888888";
        background = "#222222";
        timeout = 5;
      };
      urgency_normal = {
        background = "#d0ebff"; # normal
        foreground = "#000000"; # normal
        timeout = 5;
        override_pause_level = 30;
      };
      urgency_critical = {
        background = "#900000";
        foreground = "#ffffff";
        frame_color = "#ff0000";
        timeout = 0;
        override_pause_level = 60;
      };
    };
  };

  home.activation.newDunstrc = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run --quiet ${pkgs.rsync}/bin/rsync --chmod 644 $VERBOSE_ARG \
        ${config.xdg.configFile."dunst/dunstrc".source} ${config.xdg.configHome}/dunst/dunstrc.mutable
  '';
}
