{ config, pkgs, lib, ... }:

{
  imports = [ ./fcitx5 ];

  home = {
    username = "ltrump";
    homeDirectory = "/home/ltrump";

    stateVersion = "24.05";
  };

  home.packages = with pkgs; [
    firefox
    fastfetch
    (nnn.override { withNerdIcons = true; })
    alacritty

    zip
    xz
    unzip
    p7zip

    ripgrep
    jq
    yq-go
    eza
    fzf
    zoxide

    iperf3
    dnsutils
    ldns
    aria2
    socat
    nmap
    ipcalc

    cowsay
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg

    nix-output-monitor

    btop
    htop
    iotop
    iftop

    strace
    ltrace
    lsof

    pciutils
    usbutils

    stalonetray
    xdotool
    polybarFull
    xorg.xwininfo

    pavucontrol
    tree-sitter
    networkmanagerapplet

    onedriver
    openfortivpn
    remmina
  ];

# xresources.properties = {
#   "Xcursor.size" = 24;
#   "Xft.dpi" = 192;
# };

  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "LTrump";
    userEmail = "ltrump@163.com";
  };

  systemd.user.services."onedriver@" = {
    Unit.Description = "onedriver";
    Service = {
      ExecStart = "${pkgs.onedriver}/bin/onedriver %f";
      ExecStopPost = "/run/wrappers/bin/fusermount -uz /%I";
      Restart = "on-abnormal";
      RestartSec = 3;
      RestartForceExitStatus = 2;
      Environment = "PATH=$PATH:${lib.makeBinPath [ pkgs.fuse3 pkgs.onedriver ]}";
    };
    Install.WantedBy = [ "default.target" ];
  };

# programs.alacritty = {
#   enable = true;
#   settings = {
#     font.size = 12;
#     scrolling.multiplier = 5;
#     selection.save_to_clipboard = true;
#   };
# };
}
