{
  pkgs,
  myvars,
  ...
}:
let
  hostName = "n100";
  inherit (myvars) networking;
  inherit (networking.hostsAddr.physical.${hostName}) iface ipv4 gateway;
in
{
  # supported file systems, so we can mount any removable disks with these filesystems
  boot.supportedFilesystems = [
    "ext4"
    "btrfs"
    "xfs"
    #"zfs"
    "ntfs"
    "fat"
    "vfat"
    "exfat"
    "nfs" # required by longhorn
  ];

  boot.kernelModules = [
    "kvm-intel"
    "vfio-pci"
  ];
  boot.extraModprobeConfig = "options kvm_intel nested=1"; # for amd cpu

  boot.kernel.sysctl = {
    # --- filesystem --- #
    # increase the limits to avoid running out of inotify watches
    "fs.inotify.max_user_watches" = 524288;
    "fs.inotify.max_user_instances" = 1024;

    # --- network --- #
    "net.bridge.bridge-nf-call-iptables" = 1;
    "net.core.somaxconn" = 32768;
    "net.ipv4.ip_forward" = 1;
    "net.ipv4.conf.all.forwarding" = 1;
    "net.ipv4.neigh.default.gc_thresh1" = 4096;
    "net.ipv4.neigh.default.gc_thresh2" = 6144;
    "net.ipv4.neigh.default.gc_thresh3" = 8192;
    "net.ipv4.neigh.default.gc_interval" = 60;
    "net.ipv4.neigh.default.gc_stale_time" = 120;

    # "net.ipv6.conf.all.disable_ipv6" = 1; # disable ipv6
    "net.ipv6.conf.all.forwarding" = 1;
    "net.ipv6.conf.default.forwarding" = 1;

    # --- memory --- #
    "vm.swappiness" = 0; # don't swap unless absolutely necessary
  };

  # Workaround for longhorn running on NixOS
  # https://github.com/longhorn/longhorn/issues/2166
  systemd.tmpfiles.rules = [
    "L+ /usr/local/bin - - - - /run/current-system/sw/bin/"
  ];

  networking = {
    # inherit hostName;
    # inherit (networking) defaultGateway nameservers;

    # Manage the interface with OVS instead of networkmanager
    networkmanager.unmanaged = [ iface ];
    # Set the host's address on the OVS bridge interface instead of the physical interface!
    # interfaces.vmbr0 = networking.hostsInterface.${hostName}.interfaces.${iface};
    # bridges.vmbr0.interfaces = [iface];
    # enableIPv6 = true;
  };

  systemd.network = {
    enable = true;
    wait-online = {
      anyInterface = true;
      timeout = 30;
    };
    netdevs."vmbr0".netdevConfig = {
      Name = "vmbr0";
      Kind = "bridge";
    };
    networks."10-lan" = {
      matchConfig.Name = [
        iface
        "microvm-*"
      ];
      networkConfig.Bridge = "vmbr0";
      linkConfig.RequiredForOnline = "enslaved";
    };
    networks."10-lan-bridge" = {
      matchConfig.Name = "vmbr0";
      networkConfig = {
        Address = [ ipv4 ];
        Gateway = gateway;
        DNS = networking.nameservers;
        IPv6AcceptRA = true;
      };
      linkConfig.RequiredForOnline = "routable";
    };
  };
}
