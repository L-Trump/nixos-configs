{
  inputs,
  lib,
  ...
}:
{
  # config version is required for future config migration
  "configVersion" = 8;
  "perMonitorWallpaper" = true;
  "monitorWallpapers" = {
    "HDMI-A-1" = "${inputs.mywallpapers}/Hazel/hazel_sea.jpg";
    "DP-1" = "${inputs.mywallpapers}/Hazel/hazel_park.png";
    "eDP-1" = "${inputs.mywallpapers}/Hazel/hazel_qu.png";
  };
  "isLightMode" = true;
  "hiddenTrayIds" = [
    "nm-applet"
    "blueman"
    "udiskie"
  ];
  "locale" = "zh_CN";
  "appOverrides" = {
    "firefox" = {
      "launchOnDgpu" = true;
    };
    "lx-music-desktop" = {
      "envVars" = "WAYLAND_DISPLAY=";
      "extraFlags" = "--ozone-platform=x11";
    };
  };
  "desktopWidgetInstancePositions" = {
    "lock_clock" = {
      "_synced" = {
        "x" = 0;
        "y" = -0.1474575466579861;
        "anchorX" = "center";
        "anchorY" = "center";
      };
    };
    "lock_auth" = {
      "_synced" = {
        "x" = 0;
        "y" = 0.0789455837673611;
        "anchorX" = "center";
        "anchorY" = "center";
      };
    };
  };
}
