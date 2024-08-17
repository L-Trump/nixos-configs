{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "L-Trump";
    userEmail = "ltrump@163.com";
  };

  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };

  home.packages = with pkgs; [
    fastfetch

    zip
    xz
    unzip
    p7zip

    ripgrep
    jq
    yq-go
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
    xdg-user-dirs

    networkmanagerapplet

    xfce.thunar
    libnotify
    lxqt.lxqt-policykit
  ];
}
