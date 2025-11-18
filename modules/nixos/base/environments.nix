{
  pkgs,
  config,
  ...
}:
{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    fastfetch
    vim
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    helix
    just # justfile
    # nushell
    fish # fish shell
    tmux # Terminal split tool
    nnn

    # system call monitoring
    strace # system call monitoring
    # ltrace # library call monitoring
    tcpdump # network sniffer
    lsof # list open files

    # ebpf related tools
    # https://github.com/bpftrace/bpftrace
    # bpftrace # powerful tracing tool
    # bpftop # monitor BPF programs
    # bpfmon # BPF based visual packet rate monitor

    # system monitoring
    sysstat
    iotop
    iftop
    btop
    htop
    bottom
    nmon
    sysbench

    # system tools
    psmisc # killall/pstree/prtstat/fuser/...
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
    hdparm # for disk performance, command
    dmidecode # a tool that reads information about your system's hardware from the BIOS according to the SMBIOS/DMI standard
    parted
    fuse
    fuse3
    nfs-utils
    nixos-firewall-tool # a tool that temporarily manage nixos firewall
    config.boot.kernelPackages.usbip
  ];

  programs.fish.enable = true;

  # BCC - Tools for BPF-based Linux IO analysis, networking, monitoring, and more
  # https://github.com/iovisor/bcc
  # programs.bcc.enable = true;

  # replace default editor with neovim
  environment.variables.EDITOR = "hx";
}
