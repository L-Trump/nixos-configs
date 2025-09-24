{
  config,
  pkgs,
  ...
}:
let
  browser = [ "firefox.desktop" ];
  editor = [
    "nvim.desktop"
    "Helix.desktop"
    "code.desktop"
    "code-insiders.desktop"
  ];

  # XDG MIME types
  associations = {
    "application/json" = browser;

    "text/plain" = editor;
    "text/xml" = browser;
    "text/html" = browser;
    "application/xml" = browser;
    "application/xhtml+xml" = browser;
    "application/xhtml_xml" = browser;
    "application/rdf+xml" = browser;
    "application/rss+xml" = browser;
    "application/x-extension-htm" = browser;
    "application/x-extension-html" = browser;
    "application/x-extension-shtml" = browser;
    "application/x-extension-xht" = browser;
    "application/x-extension-xhtml" = browser;
    "application/x-wine-extension-ini" = editor;
    "application/pdf" = [ "org.pwmt.zathura.desktop" ];

    "x-scheme-handler/about" = browser;
    "x-scheme-handler/ftp" = browser;
    "x-scheme-handler/http" = browser;
    "x-scheme-handler/https" = browser;

    "x-scheme-handler/chrome" = [ "chromium-browser.desktop" ];
    "x-scheme-handler/discord" = [ "discord.desktop" ];
    "x-scheme-handler/tg" = [ "org.telegram.desktop.desktop " ];
    "x-scheme-handler/spotify" = [ "spotify.desktop" ];

    # "x-scheme-handler/unknown" = browser;

    "audio/*" = [ "mpv.desktop" ];
    "video/*" = [ "mpv.dekstop" ];
    "image/*" = [ "vimiv.desktop" ];
  };
in
{
  imports = [ ./xdg-portals ];

  home.packages = with pkgs; [
    xdg-utils # provides cli tools such as `xdg-mime` `xdg-open`
    xdg-user-dirs
  ];

  xdg.configFile."mimeapps.list".force = true;
  xdg.dataFile."applications/mimeapps.list".force = true;
  xdg = {
    enable = true;

    cacheHome = "${config.home.homeDirectory}/.cache";
    configHome = "${config.home.homeDirectory}/.config";
    dataHome = "${config.home.homeDirectory}/.local/share";
    stateHome = "${config.home.homeDirectory}/.local/state";

    mimeApps = {
      enable = true;
      defaultApplications = associations;
    };

    userDirs = {
      enable = true;
      # createDirectories = true;
      extraConfig = {
        XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/Screenshots";
      };
    };
  };
}
