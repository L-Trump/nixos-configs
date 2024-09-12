{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    remmina
    zotero
    nur.repos.linyinfeng.wemeet
  ];
}
