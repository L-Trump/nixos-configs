{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    polybarFull
  ];
  xdg.configFile."polybar/blocks".source = ./blocks;
  xdg.configFile."polybar/launch.sh".source = ./launch.sh;
}
