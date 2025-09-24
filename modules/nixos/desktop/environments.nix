{ pkgs, ... }:
{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # normal dev envs
    gnumake
    python3
    python3Packages.pip
    # clang-tools
    cmake
    # gccgo
    # go
    # nodejs_22
  ];

  environment.pathsToLink = [
    "/share/icons"
    "/share/xdg-desktop-portal"
    "/share/applications"
    "/libexec"
  ];

  # no default shell alias
  environment.shellAliases = {
    l = null;
    ls = null;
    ll = null;
  };

  # thunar file manager(part of xfce) related options
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  programs.npm.enable = true;

  # dconf is a low-level configuration system.
  programs.dconf.enable = true;

  services.dbus.packages = [ pkgs.gcr ];
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  # Ugly but useful systemd
  systemd.user.extraConfig = ''
    DefaultEnvironment="PATH=/run/wrappers/bin:/etc/profiles/per-user/%u/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:$PATH"
  '';
}
