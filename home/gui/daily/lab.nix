{
  config,
  pkgs,
  pkgs-stable,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    remmina
    realvnc-vnc-viewer
    zotero
    wemeet
    # winetricks
    # wineWowPackages.waylandFull
    # lutris
    # dbeaver-bin
    dbeaver-ultimate
    hdc
    lceda-pro
  ];

  home.sessionVariables = {
    WINEPREFIX = config.xdg.dataHome + "/wine";
  };
}
