{
  config,
  pkgs,
  lib,
  ...
}:
{
  dconf.settings = {
    "org/gnome/interface" = {
      color-scheme = "'prefer-light'";
      gtk-theme = config.gtk.theme.name;
      font-name = config.gtk.font.name;
      icon-theme = config.gtk.iconTheme.name;
      cursor-theme = config.home.pointerCursor.name;
      cursor-size = config.home.pointerCursor.size;
    };
  };

  services.darkman.lightModeScripts.dconf = ''
    cur_theme=$(${pkgs.dconf}/bin/dconf read /org/gnome/desktop/interface/gtk-theme)
    cur_theme=''${cur_theme#"'"}
    cur_theme=''${cur_theme%"'"}
    if [ -n "$(${pkgs.coreutils}/bin/echo $cur_theme  | ${pkgs.gnugrep}/bin/grep -E '^.*-Dark')" ]; then
      ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/gtk-theme ${"\"'\${cur_theme%'-Dark'}-Light'\""}
      ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-light'"
    fi
  '';

  services.darkman.darkModeScripts.dconf = ''
    cur_theme=$(${pkgs.dconf}/bin/dconf read /org/gnome/desktop/interface/gtk-theme)
    cur_theme=''${cur_theme#"'"}
    cur_theme=''${cur_theme%"'"}
    if [ -n "$(${pkgs.coreutils}/bin/echo $cur_theme  | ${pkgs.gnugrep}/bin/grep -E '^.*-Light')" ]; then
      ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/gtk-theme ${"\"'\${cur_theme%'-Light'}-Dark'\""}
      ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
    fi
  '';
}
