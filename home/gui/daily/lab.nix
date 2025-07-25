{
  config,
  pkgs,
  pkgs-stable,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    remmina
    realvnc-vnc-viewer
    zotero
    wemeet
    matlab
    # winetricks
    # wineWowPackages.waylandFull
    # lutris
    dbeaver-bin
  ];

  home.sessionVariables = {
    WINEPREFIX = config.xdg.dataHome + "/wine";
  };
}
