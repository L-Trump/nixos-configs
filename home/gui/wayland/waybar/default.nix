{
  pkgs,
  lib,
  ...
}:
{
  programs.waybar.enable = true;
  xdg.configFile."waybar/config.jsonc" = {
    source = ./config.jsonc;
    onChange = ''
      ${pkgs.procps}/bin/pkill -u $USER -USR2 waybar || true
    '';
  };
  xdg.configFile."waybar/style.css" = {
    source = ./style.css;
    onChange = ''
      ${pkgs.procps}/bin/pkill -u $USER -USR2 waybar || true
    '';
  };
  xdg.configFile."waybar/rofi-menus".source = ../rofi-menus;
}
