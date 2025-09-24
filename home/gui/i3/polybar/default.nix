{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    polybarFull
    gtk3
  ];
  xdg.configFile."polybar/blocks".source = ./blocks;
  xdg.configFile."polybar/launch.sh".source = ./launch.sh;
}
