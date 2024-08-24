{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    firefox
    google-chrome
    microsoft-edge
  ];

}
