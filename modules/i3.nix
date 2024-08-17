# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ pkgs, ... }:

{
  imports = [ ./autologin.nix ];
  environment.pathsToLink = [ "/libexec" ];

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    autorun = false;

    desktopManager.xterm.enable = false;
    displayManager = {
      startx.enable = true;
      # defaultSession = "none+i3";
    };

    # Configure keymap in X11
    xkb.layout = "us";
    # xkb.options = "eurosign:e,caps:escape";

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dunst
        feh
        acpi
        dex
      ];
    };
  };

  systemd.user.targets.i3-session = {
    description = "i3 session";
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
  };
}

