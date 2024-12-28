{pkgs, ...}: {
  home.packages = with pkgs; [
    qq
    wechat-uos
    telegram-desktop
  ];

  xdg.desktopEntries.qq = {
    name = "QQ";
    exec = "${pkgs.qq}/bin/qq --ozone-platform-hint=auto --enable-features=WaylandWindowDecorations";
    icon = "qq";
    settings.StartupWMClass = "QQ";
    categories = ["Chat" "Network"];
    comment = "QQ";
  };
}
