{
  config,
  pkgs,
  ...
}: {
  home.sessionVariables = {
    "GTK_USE_PORTAL" = 1;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      # xdg-desktop-portal-wlr
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-termfilechooser
    ];
    config = {
      common.default = "*";
      i3 = {
        default = ["gtk"];
        "org.freedesktop.impl.portal.FileChooser" = ["termfilechooser"];
      };
      hyprland = {
        default = ["hyprland" "gtk"];
        "org.freedesktop.impl.portal.FileChooser" = ["termfilechooser"];
        # "org.freedesktop.impl.portal.Screenshot" = ["wlr"];
      };
    };
  };

  xdg.configFile."xdg-desktop-portal-termfilechooser/config".text = ''
    [filechooser]
    cmd=${./ffnnn}
  '';

  systemd.user.services.xdg-desktop-portal-termfilechooser = {
    Unit = {
      Description = "Portal service (terminal file chooser implementation)";
      PartOf = "graphical-session.target";
      After = "graphical-session.target";
    };
    Service = {
      Environment = "PATH=/run/wrappers/bin:/run/current-system/sw/bin:/etc/profiles/per-user/%u/bin";
      Type = "dbus";
      BusName = "org.freedesktop.impl.portal.desktop.termfilechooser";
      ExecStart = "${pkgs.xdg-desktop-portal-termfilechooser}/libexec/xdg-desktop-portal-termfilechooser";
      Restart = "on-failure";
    };
  };
}
