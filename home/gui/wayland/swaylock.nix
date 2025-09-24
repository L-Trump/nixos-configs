{ pkgs, ... }:
let
  lock_wallpaper = builtins.path { path = ../../../wallpapers/LockWallpapers/75778903_p0.jpg; };
in
{
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      daemonize = true;
      clock = true;
      color = "6272A4";
      font = "Inter";
      indicator-radius = "200";
      indicator-thickness = "20";
      line-color = "282A36";
      ring-color = "BD93F9";
      inside-color = "282A36";
      key-hl-color = "50FA7B";
      separator-color = "00000000";
      text-color = "F8F8F2";
      text-caps-lock-color = "";
      line-ver-color = "BD93F9";
      ring-ver-color = "BD93F9";
      inside-ver-color = "282A36";
      text-ver-color = "8BE9FD";
      ring-wrong-color = "FF5555";
      text-wrong-color = "FF5555";
      inside-wrong-color = "282A36";
      inside-clear-color = "282A36";
      text-clear-color = "8BE9FD";
      ring-clear-color = "8BE9FD";
      line-clear-color = "8BE9FD";
      line-wrong-color = "282A36";
      bs-hl-color = "8BE9FD";
      datestr = "%a, %B %e";
      timestr = "%I:%M %p";
      # ignore-empty-password = true;
      image = "${lock_wallpaper}";

      # grace=2
      # grace-no-mouse
      # grace-no-touch
      # show-failed-attempts
      # fade-in=0.4
      # indicator
      # screenshot
      # effect-blur=13x13
      # effect-vignette=0.5:0.5
    };
  };
}
