# Device specific home settings
{
  inputs,
  pkgs,
  ...
}:
{
  xresources.properties = {
    "Xft.dpi" = 192;
    "rofi.dpi" = 192;
    "*.dpi" = 192;
  };
  myhome.desktop.niri.settings = {
    output = [
      {
        _args = [ "eDP-1" ];
        scale = 2.0;
        position = {
          _props = {
            x = 0;
            y = 0;
          };
        };
      }
      {
        _args = [ "Lenovo Group Limited LEN Y27q-20 0x01010101" ];
        scale = 1.6;
        position = {
          _props = {
            x = 1440;
            y = 0;
          };
        };
      }
      {
        _args = [ "Dell Inc. DELL SE2722H CVW0WP3" ];
        position = {
          _props = {
            x = 1440;
            y = 0;
          };
        };
      }
      {
        _args = [ "Dell Inc. DELL D2721H C1SSW53" ];
        mode = "1920x1080@60";
        position = {
          _props = {
            x = 3360;
            y = 0;
          };
        };
      }
      {
        _args = [ "Dell Inc. DELL SE2722H H6RZVP3" ];
        mode = "1920x1080@60";
        position = {
          _props = {
            x = 3360;
            y = 0;
          };
        };
      }
      {
        _args = [ "ViewSonic Corporation VX3480-2K-PRO WYX241400015" ];
        mode = "3440x1440@60";
        scale = 1.3;
        position = {
          _props = {
            x = 1440;
            y = 0;
          };
        };
      }
    ];
    input = {
      touch = {
        map-to-output = "eDP-1";
      };
    };
    spawn-at-startup = [
      [
        "brightnessctl"
        "-d"
        "platform::micmute"
        "s"
        "0"
      ]
    ];
  };

}
