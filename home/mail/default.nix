{ config, pkgs, lib, ... }:

{
  imports = [
    ./aerc
    ./offlineimap
    ./pass.nix
    ./imapnotify
  ];
}
