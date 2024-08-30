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
}
