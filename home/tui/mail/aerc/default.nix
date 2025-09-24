{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.aerc = {
    enable = true;
    extraConfig = {
      general.enable-osc8 = true;
      ui = {
        mouse-enabled = true;
        dirlist-tree = true;
        sort = "-r arrival";
        styleset-name = "nord";
        threading-enabled = true;
        icon-unencrypted = "";
        icon-encrypted = "✔";
        icon-signed = "✔";
        icon-signed-encrypted = "✔";
        icon-unknown = "✘";
        icon-invalid = "⚠";
      };
      compose = {
        editor = "nvim";
        file-picker-cmd = "kdialog";
      };
      filters = {
        "text/plain" = "colorize";
        "text/calendar" = "calendar";
        "message/delivery-status" = "colorize";
        "message/rfc822" = "colorize";
        "text/html" = "html | colorize";
        ".headers" = "colorize";
      };
    };
  };

  xdg.configFile."aerc/stylesets/nord".source = ./style-nord;
  xdg.configFile."aerc/binds.conf".source = ./binds.conf;

  xdg.desktopEntries.aerc = lib.mkIf config.programs.kitty.enable {
    type = "Application";
    name = "aerc";
    genericName = "Mail Client";
    comment = "Launches the aerc email client";
    settings.Keywords = "Email,Mail,IMAP,SMTP";
    categories = [
      "Office"
      "Network"
      "Email"
      "ConsoleOnly"
    ];
    icon = "utilities-terminal";
    exec = ''kitty --class aerc -T "AERC" -e fish -ilc "aerc" %u'';
    mimeType = [ "x-scheme-handler/mailto" ];
  };
}
