# Device specific home settings
{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  myhome.desktop.niri.settings = {
    output = [
      {
        _args = [ "eDP-1" ];
        scale = 1.333333;
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
    ];
    environment = {
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      MOZ_DISABLE_RDD_SANDBOX = "1";
    };
    input = {
      tablet = {
        map-to-output = "HDMI-A-1";
      };
    };
  };
}
