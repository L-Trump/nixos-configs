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
    nur.repos.linyinfeng.wemeet
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
