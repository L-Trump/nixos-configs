{
  config,
  pkgs,
  ...
}:
{
  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };

  home.packages = with pkgs; [
    networkmanagerapplet
    libnotify
  ];
}
