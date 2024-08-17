{ config, pkgs, ... }:

{
  imports = [
    ./picom.nix
    ./polybar
  ];

  xresources.properties = {
    "Xcursor.size" = 32;
    "Xft.dpi" = 192;
    "rofi.dpi" = 192;
    "*.dpi" = 192;
    "Xcursor.theme" = "merry_cursors";
  };


  programs.fish = {
    interactiveShellInit = ''
      # auto login
      if test -z $DISPLAY; and test $XDG_VTNR -eq 1; and test "$(tty)" = "/dev/tty1"; and test "$(fgconsole 2>/dev/null || echo 1)" -eq 1
          exec startx
      end
    '';
  };

  home.file.".config/i3/config".source = ./config;
  home.file.".xinitrc".source = ./.xinitrc;

  home.packages = with pkgs; [
    stalonetray
    xdotool
    xorg.xwininfo
    xwinwrap
    i3blocks
    i3lock-color
    i3status
    rofi
    arandr
    xbindkeys
    xorg.xbacklight
    xorg.xdpyinfo
    xsel
    xclip
    xss-lock
    feh
    rofi-rbw
    snipaste
  ];
}
