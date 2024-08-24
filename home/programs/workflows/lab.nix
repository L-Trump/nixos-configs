{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    openfortivpn
    remmina
  ];
}
