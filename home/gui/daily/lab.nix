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
  ];
}
