# Device specific home settings
{ config, lib, pkgs, ... }:

{
  wayland.windowManager.hyprland.settings = {
    device = [{
      name = "ftsc1000:00-2808:5662";
      output = "eDP-1";
    }];
    exec-once = [ "brightnessctl -d platform::micmute s 0" ];
  };

  programs.lan-mouse = {
    enable = true;
    systemd = true;
    package = pkgs.lan-mouse;
    settings = {
      right = {
        hostname = "HomeWin";
        activate_on_startup = true;
        ips = [
          "192.168.2.14"
          "10.0.10.8"
          "100.101.101.56"
        ];
      };
    };
  };
}
