{
  config,
  pkgs,
  ...
}:
let
  fcitx5Addons = with pkgs.qt6Packages; [
    fcitx5-configtool
    fcitx5-chinese-addons
  ];
  fcitx5Package = pkgs.qt6Packages.fcitx5-with-addons.override { addons = fcitx5Addons; };
  cfg.package = fcitx5Package;

  gtk2Cache =
    pkgs.runCommandLocal "gtk2-immodule.cache"
      {
        buildInputs = [
          pkgs.gtk2
          cfg.package
        ];
      }
      ''
        mkdir -p $out/etc/gtk-2.0/
        GTK_PATH=${cfg.package}/lib/gtk-2.0/ \
          gtk-query-immodules-2.0 > $out/etc/gtk-2.0/immodules.cache
      '';

  gtk3Cache =
    pkgs.runCommandLocal "gtk3-immodule.cache"
      {
        buildInputs = [
          pkgs.gtk3
          cfg.package
        ];
      }
      ''
        mkdir -p $out/etc/gtk-3.0/
        GTK_PATH=${cfg.package}/lib/gtk-3.0/ \
          gtk-query-immodules-3.0 > $out/etc/gtk-3.0/immodules.cache
      '';
in
{
  home.packages = [
    cfg.package
    gtk2Cache
    gtk3Cache
  ];
  home.file.".local/share/fcitx5/table/flypy.dict".source = ./flypy.dict;
  home.file.".local/share/fcitx5/inputmethod/flypy.conf".source = ./flypy.conf;

  home.sessionVariables = {
    GLFW_IM_MODULE = "ibus"; # IME support in kitty
    # GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    QT_PLUGIN_PATH = "$QT_PLUGIN_PATH\${QT_PLUGIN_PATH:+:}${fcitx5Package}/${pkgs.qt6.qtbase.qtPluginPrefix}";
  };

  systemd.user.services.fcitx5-daemon = {
    Unit = {
      Description = "Fcitx5 input method editor";
      PartOf = [ "graphical-session.target" ];
    };
    Service.ExecStart = "${fcitx5Package}/bin/fcitx5";
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
