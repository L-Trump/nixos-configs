{pkgs, ...}: {
  home.packages = with pkgs; [
    qq
    wechat-uos-without-sandbox
    telegram-desktop
  ];

  xdg.desktopEntries.qq = {
    name = "QQ";
    exec = "${pkgs.qq}/bin/qq --enable-wayland-ime --ozone-platform-hint=auto --enable-features=WaylandWindowDecorations";
    icon = "qq";
    settings.StartupWMClass = "QQ";
    categories = ["Chat" "Network"];
    comment = "QQ";
  };
}
