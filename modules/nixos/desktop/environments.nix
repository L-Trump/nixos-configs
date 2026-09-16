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
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  programs.npm.enable = true;

  # dconf is a low-level configuration system.
  programs.dconf.enable = true;

  # TODO gcr 已拆成带 ABI 版本号的名字：gcr_3 = 旧的 pkgs.gcr（3.x），gcr_4 = 4.x
  services.dbus.packages = [ pkgs.gcr_3 ];
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  # Ugly but useful systemd
  systemd.user.settings.Manager = {
    DefaultEnvironment = "PATH=/run/wrappers/bin:/etc/profiles/per-user/%u/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:$PATH";
  };
}
