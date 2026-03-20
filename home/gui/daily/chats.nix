{ pkgs, ... }:
{
  home.packages = with pkgs; [
    qq
    wechat-uos
    telegram-desktop
    # discord
    feishu
  ];

  # xdg.desktopEntries.qq = {
  #   name = "QQ";
  #   exec = "${pkgs.qq}/bin/qq --wayland-text-input-version=3";
  #   icon = "qq";
  #   settings.StartupWMClass = "QQ";
  #   categories = [
  #     "Chat"
  #     "Network"
  #   ];
  #   comment = "QQ";
  # };
}
