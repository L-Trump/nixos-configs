{ config, lib, pkgs, ... }:

{

  environment.pathsToLink = [
    "/share/icons"
    "/share/xdg-desktop-portal"
    "/share/applications"
  ];
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    neovim
    wget
    curl
    git
    sysstat
    lm_sensors
    killall
    tmux
    nnn
    age

    python3
    python3Packages.pip
    clang-tools
    cmake
    gccgo
    go
    nodejs_22

    fuse
    fuse3

    agenix
    age
    passage

    just
  ];

  services.dbus.packages = [ pkgs.gcr ];
  services.geoclue2.enable = true;

  programs.npm.enable = true;

  programs.dconf.enable = true;

  # Shell
  programs.fish.enable = true;
  environment.shellAliases = {
    l = null;
    ls = null;
    ll = null;
  };

  security.polkit.enable = true;
}
