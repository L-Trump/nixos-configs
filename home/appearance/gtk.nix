{ config, pkgs, lib, ... }:

{
  # Themes
  home.packages = with pkgs; [
    adw-gtk3 # Adwaita
    libadwaita
    orchis-theme
    whitesur-gtk-theme
    whitesur-cursors
    whitesur-icon-theme
    adwaita-icon-theme
    tela-icon-theme
  ];

  gtk = {
    enable = true;
    theme = {
      name = "Orchis-Light";
      package = pkgs.orchis-theme;
    };
    iconTheme = {
      name = "Tela";
      package = pkgs.tela-icon-theme;
    };
    font = {
      name = "Microsoft YaHei UI";
      package = pkgs.vistafonts-chs;
      size = 12;
    };
  };

  home.pointerCursor.gtk.enable = true;

}
