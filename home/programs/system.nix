{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "LTrump";
    userEmail = "ltrump@163.com";
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
