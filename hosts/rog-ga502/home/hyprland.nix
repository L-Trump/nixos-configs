# Device specific home settings
{
  inputs,
  pkgs,
  lib,
  ...
}: {
  wayland.windowManager.hyprland.settings = {
    monitor = lib.mkBefore [
      "eDP-1,preferred,0x0,1.333333"
      "desc:Lenovo Group Limited LEN Y27q-20 0x01010101,preferred,auto,1.6"
      "desc:Dell Inc. DELL SE2722H CVW0WP3,1920x1080@60,1440x0,auto,vrr,0"
      "desc:Dell Inc. DELL D2721H C1SSW53,1920x1080@60,3360x0,auto"
      ",preferred,auto,auto"
    ];
    bindl = [
      # trigger when the switch is turning on
      '', switch:on:Lid Switch, exec, hyprctl keyword monitor "eDP-1, disable"''
      # trigger when the switch is turning off
      '', switch:off:Lid Switch, exec, hyprctl keyword monitor "eDP-1, preferred, 0x0, auto"''
    ];
    env = [
      "LIBVA_DRIVER_NAME,nvidia"
      "__GLX_VENDOR_LIBRARY_NAME,nvidia"
      "MOZ_DISABLE_RDD_SANDBOX,1"
    ];
  };
}
