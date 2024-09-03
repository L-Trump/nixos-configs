{ config, pkgs, lib, ... }:

{
  imports = [
    ./aerc
    ./offlineimap
    ./imapnotify
  ];
}
