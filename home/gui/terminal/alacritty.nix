{
  config,
  pkgs,
  ...
}:
{
  programs.alacritty.enable = true;
  programs.alacritty.settings = {
    colors.bright = {
      blue = "0x007FFF";
      cyan = "0x00CCCC";
      green = "0x03C03C";
      magenta = "0xFF1493";
      red = "0xFF2400";
      white = "0xFFFAFA";
      yellow = "0xFDFF00";
    };
    colors.normal = {
      black = "0x282a36";
      blue = "0x57c7ff";
      cyan = "0x9aedfe";
      green = "0x5af78e";
      magenta = "0xff6ac1";
      red = "0xff5c57";
      white = "0xf1f1f0";
      yellow = "0xf3f99d";
    };
    colors.primary = {
      background = "0x282a36";
      foreground = "0xeff0eb";
    };

    font = {
      size = 12.0;
      bold = {
        family = "Source Code Pro";
        style = "Bold";
      };
      bold_italic = {
        family = "Source Code Pro";
        style = "Bold Italic";
      };
      italic = {
        family = "Source Code Pro";
        style = "Italic";
      };
      normal = {
        family = "Source Code Pro";
        style = "Regular";
      };
    };

    window.opacity = 0.9;
  };
}
