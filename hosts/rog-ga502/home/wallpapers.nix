# rog-ga502 per-monitor wallpapers. The shared default in
# home/gui/wayland/default.nix is hazel_qu for every monitor (`monitor = ""`);
# mkBefore puts these entries ahead of it.
{ inputs, lib, ... }:
let
  wallpaper = file: builtins.path { path = "${inputs.mywallpapers}/Hazel/${file}"; };
in
{
  services.hyprpaper.settings.wallpaper = lib.mkBefore [
    {
      monitor = "HDMI-A-1";
      path = wallpaper "hazel_sea.jpg";
    }
    {
      monitor = "DP-1";
      path = wallpaper "hazel_park.png";
    }
    {
      monitor = "eDP-1";
      path = wallpaper "hazel_qu.png";
    }
  ];
}
