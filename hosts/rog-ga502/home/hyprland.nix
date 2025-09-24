# Device specific home settings
{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  wayland.windowManager.hyprland.settings = {
    monitor = lib.mkBefore [
      "eDP-1,preferred,0x0,1.333333"
      "desc:Lenovo Group Limited LEN Y27q-20 0x01010101,preferred,auto,1.6"
      "desc:Dell Inc. DELL SE2722H CVW0WP3,1920x1080@60,1440x0,auto,vrr,0"
      "desc:Dell Inc. DELL D2721H C1SSW53,1920x1080@60,3360x0,auto"
      "desc:Dell Inc. DELL SE2722H H6RZVP3,1920x1080@60,3360x0,auto,vrr,0"
      ",preferred,auto,auto"
    ];
    bindl = [
      # trigger when the switch is turning on
      '', switch:on:Lid Switch, exec, hyprctl keyword monitor "eDP-1, disable"''
      # trigger when the switch is turning off
      '', switch:off:Lid Switch, exec, hyprctl keyword monitor "eDP-1, preferred, 0x0, auto"''
    ];
    device = [
      {
        name = "wacom-intuos-pt-s-2-finger";
        accel_profile = "custom 0.1044477505658554 0.000 0.051 0.102 0.179 0.257 0.334 0.418 0.535 0.652 0.769 0.886 1.003 1.120 1.237 1.354 1.471 1.588 1.705 1.823 2.064";
      }
    ];
    env = [
      "GBM_BACKEND,nvidia-drm"
      # "AQ_DRM_DEVICES,/dev/dri/by-name/nvidia-card:/dev/dri/by-name/amd-card"
      # "LIBVA_DRIVER_NAME,nvidia"
      "__GLX_VENDOR_LIBRARY_NAME,nvidia"
      "MOZ_DISABLE_RDD_SANDBOX,1"
    ];
  };
}
