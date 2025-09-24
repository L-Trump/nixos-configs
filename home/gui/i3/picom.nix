{
  config,
  pkgs,
  ...
}:
{
  services.picom = {
    enable = true;
    shadow = true;
    shadowOffsets = [
      (-7)
      (-7)
    ];
    shadowExclude = [
      "name = 'Notification'"
      "class_g = 'Conky'"
      "class_i = 'EdrawMax'"
      "class_g = 'MindMaster'"
      "class_g = 'flameshot'"
      "class_i = 'utools'"
      "class_i = 'Dunst'"
      "class_i = 'Snipaste.AppImage'"
      "class_g = 'Snipaste'"
      "name = 'wps'"
      "name = 'pdf'"
      "class_g = 'fcitx'"
      "class_g = 'tim.exe'"
      "class_g = 'lx-music-desktop'"
      "class_g = 'qq.exe'"
      "class_g = 'QQ.exe'"
      "class_g = 'launcher.exe'"
      "class_g = 'Wine'"
      "class_g = 'wemeetapp'"
      "class_g = 'wechat.exe'"
      "class_g ?= 'Notify-osd'"
      "class_g = 'Cairo-clock'"
      "class_g = 'steam-clock'"
      "class_g = 'firefox' && argb"
      "_GTK_FRAME_EXTENTS@:c"
    ];
    fade = true;
    fadeSteps = [
      0.05
      0.05
    ];
    fadeExclude = [
      "class_g = 'Snipaste.AppImage'"
      "class_i = 'Snipaste'"
      "name = 'Paster - Snipaste'"
      "name = 'Snipper - Snipaste'"
      "class_g = 'wechat.exe'"
    ];
    inactiveOpacity = 0.8;

    wintypes = {
      tooltip = {
        fade = true;
        shadow = true;
        opacity = 0.75;
        focus = true;
        full-shadow = false;
      };
      dock = {
        shadow = false;
      };
      dnd = {
        shadow = false;
      };
      popup_menu = {
        opacity = 0.8;
        shadow = false;
        focus = true;
      };
      dropdown_menu = {
        opacity = 0.8;
        shadow = false;
        focus = true;
      };
    };

    settings = {
      shadow-radius = 7;
      frame-opacity = 0.7;
      inactive-opacity-override = false;
      detect-client-opacity = true;
      mark-wmwin-focused = true;
      mark-ovredir-focused = true;
      detect-rounded-corners = true;
      detect-transient = true;
      detect-client-leader = true;
    };
  };
}
