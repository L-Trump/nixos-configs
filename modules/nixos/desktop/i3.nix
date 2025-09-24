# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  ...
}:
let
  cfg = config.mymodules.desktop.xorg;
in
{
  config = {
    services.xserver.enable = lib.mkDefault false;
  }
  // lib.mkIf cfg.enable {
    # Enable the X11 windowing system.
    services.xserver.enable = true;
    services.xserver = {
      autorun = false;

      desktopManager.xterm.enable = false;
      displayManager = {
        startx.enable = true;
        # defaultSession = "none+i3";
      };

      # Configure keymap in X11
      xkb.layout = "us";
      # xkb.options = "eurosign:e,caps:escape";

      windowManager.i3.enable = true;
    };

    systemd.user.targets.i3-session = {
      description = "i3 session";
      bindsTo = [ "graphical-session.target" ];
      wants = [ "graphical-session-pre.target" ];
      after = [ "graphical-session-pre.target" ];
    };
  };
}
