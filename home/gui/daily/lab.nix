{
  config,
  pkgs,
  pkgs-stable,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    pkgs-stable.remmina
    zotero
    nur.repos.linyinfeng.wemeet
    matlab
    winetricks
    wineWowPackages.waylandFull
    lutris
  ];

  home.sessionVariables = {
    WINEPREFIX = config.xdg.dataHome + "/wine";
  };
}
