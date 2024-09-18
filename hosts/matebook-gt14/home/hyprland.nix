# Device specific home settings
{
  inputs,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland.settings = {
    monitor = [
      "eDP-1,preferred,0x0,auto"
      "desc:Lenovo Group Limited LEN Y27q-20 0x01010101,preferred,auto-right,1.6"
      "desc:Dell Inc. DELL SE2722H CVW0WP3,1920x1080@60,auto-right,auto"
      ",preferred,auto-right,auto"
    ];
    device = [
      {
        name = "ftsc1000:00-2808:5662";
        output = "eDP-1";
      }
      {
        name = "sp1520t:00-0911:5288-touchpad";
        # sensitivity = "+0.2"; # -1.0 - 1.0, 0 means no modification.
        accel_profile = "custom 0.1544477505658554 0.000 0.051 0.102 0.179 0.257 0.334 0.418 0.535 0.652 0.769 0.886 1.003 1.120 1.237 1.354 1.471 1.588 1.705 1.823 2.064";
      }
    ];
    exec-once = ["brightnessctl -d platform::micmute s 0"];
  };
}
