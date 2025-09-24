{
  config,
  pkgs,
  lib,
  myhome,
  ...
}:
with lib;
let
  i3-scripts = pkgs.mkScriptsPackage "my-i3-scripts" ./scripts;
  rawcfg = myhome.desktop.xorg;
  cfg = config.myhome.desktop.xorg;
in
{
  imports = optionals rawcfg.enable [
    ./picom.nix
    ./polybar
  ];

  config = mkIf cfg.enable {
    # xresources.properties = {
    #   "Xft.dpi" = 192;
    #   "rofi.dpi" = 192;
    #   "*.dpi" = 192;
    # };
    home.pointerCursor.x11.enable = true;

    # programs.fish = {
    #   interactiveShellInit = ''
    #     # auto login
    #     if test -z $DISPLAY; and test $XDG_VTNR -eq 1; and test "$(tty)" = "/dev/tty1"; and test "$(fgconsole 2>/dev/null || echo 1)" -eq 1
    #         exec startx
    #     end
    #   '';
    # };

    home.file.".config/i3/config".source = ./config;
    home.file.".xinitrc".source = ./.xinitrc;
    home.file.".stalonetrayrc".source = ./.stalonetrayrc;
    xdg.configFile."betterlockscreenrc".source = ./betterlockscreenrc;

    home.packages = with pkgs; [
      i3-scripts
      stalonetray
      xdotool
      xorg.xwininfo
      xwinwrap
      i3blocks
      i3lock-color
      i3status
      arandr
      xbindkeys
      xorg.xbacklight
      xorg.xdpyinfo
      xsel
      xclip
      xss-lock
      feh
      snipaste
      dex
      acpi
    ];

    programs.rofi = {
      enable = true;
      extraConfig.dpi = 192;
    };
  };
}
