{
  config,
  pkgs,
  lib,
  myvars,
  ...
}:
{
  home.sessionVariables = {
    "GTK_USE_PORTAL" = 1;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
      xdg-desktop-portal-termfilechooser
      xdg-desktop-portal-gnome
    ];
    config = {
      common.default = "*";
      i3 = {
        default = [ "gtk" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
      };
      niri = {
        default = [
          "gnome"
          "gtk"
        ];
        "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
        "org.freedesktop.impl.portal.Access" = "gtk";
        "org.freedesktop.impl.portal.Notification" = "gtk";
        "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
        # TODO niri 26.04 的 org.gnome.Shell.Screenshot 多输出直接
        # anyhow::ensure!(outputs.len() == 1) 失败（本机三屏），gnome impl
        # 连带 portal 截图一起挂；wlr impl 本质就是 spawn grim，多屏正常。
        "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
      };
    };
  };

  xdg.configFile."xdg-desktop-portal-termfilechooser/config".text = ''
    [filechooser]
    cmd=${./ffnnn}
    create_help_file=0
    default_dir=$HOME/Downloads
    open_mode=suggested
    save_mode=suggested
  '';

  systemd.user.services.xdg-desktop-portal-termfilechooser = {
    Unit = {
      Description = "Portal service (terminal file chooser implementation)";
      PartOf = "graphical-session.target";
      After = "graphical-session.target";
    };
    Service = {
      Environment = "PATH=/run/wrappers/bin:/etc/profiles/per-user/${myvars.username}/bin:/run/current-system/sw/bin";
      Type = "dbus";
      BusName = "org.freedesktop.impl.portal.desktop.termfilechooser";
      ExecStart = "${pkgs.xdg-desktop-portal-termfilechooser}/libexec/xdg-desktop-portal-termfilechooser";
      Restart = "on-failure";
    };
  };
}
