{
  config,
  pkgs,
  lib,
  ...
}: {
  # Themes
  home.packages = with pkgs; [
    adw-gtk3 # Adwaita
    libadwaita
    orchis-theme
    # whitesur-gtk-theme
    # whitesur-cursors
    # whitesur-icon-theme
    adwaita-icon-theme
    tela-icon-theme
    papirus-icon-theme
  ];

  gtk = {
    enable = true;

    font = {
      name = "Microsoft YaHei UI";
      package = pkgs.vistafonts-chs;
      size = 10;
    };
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    theme = {
      name = "Orchis-Light";
      package = pkgs.orchis-theme;
    };

    iconTheme = {
      name = "Tela";
      package = pkgs.tela-icon-theme;
    };
  };

  home.pointerCursor.gtk.enable = true;
}
