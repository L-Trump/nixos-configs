{
  config,
  pkgs,
  ...
}: {
  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = ["graphical-session-pre.target"];
    };
  };

  home.packages = with pkgs; [
    networkmanagerapplet
    libnotify
  ];

  xdg.desktopEntries.clash = {
    name = "Clash Verge";
    comment = "A Clash Meta GUI based on tauri.";
    exec = "clash-verge %u";
    icon = "clash-verge";
    mimeType = ["x-scheme-handler/clash"];
    categories = ["Network" "Development"];
  };
}
