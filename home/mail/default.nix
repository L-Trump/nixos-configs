{ config, pkgs, lib, ... }:

let
  mail-scripts = pkgs.mkScriptsPackage "mail-scripts" ./scripts;
in
{
  imports = [
    ./aerc
    ./offlineimap
    ./imapnotify
  ];

  home.packages = [ mail-scripts ];
}
