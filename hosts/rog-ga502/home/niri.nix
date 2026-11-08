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
      # LG 27" 2K 144Hz, landscape — leftmost (HDMI on the iGPU: 144Hz + VRR,
      # the dGPU DP port only negotiates 120Hz without VRR)
      {
        _args = [ "LG Electronics LG ULTRAGEAR 610BOSF14310" ];
        scale = 1.25;
        # bare flag node — niri rejects `variable-refresh-rate true`
        variable-refresh-rate = { };
        position = {
          _props = {
            x = 0;
            y = 0;
          };
        };
      }
      # Dell 27" 1080p, rotated to portrait — middle
      {
        _args = [ "Dell Inc. DELL SE2722H JT50WP3" ];
        transform = "270";
        layout = {
          default-column-width = {
            proportion = 1.0;
          };
        };
        position = {
          _props = {
            x = 2048;
            y = 0;
          };
        };
      }
      # laptop panel — rightmost
      {
        _args = [ "eDP-1" ];
        scale = 1.333333;
        position = {
          _props = {
            x = 3128;
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
