# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "thunderbolt" "nvme" "usbhid" "usb_storage" "sd_mod" "sdhci_pci"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  # supported file systems, so we can mount any removable disks with these filesystems
  boot.supportedFilesystems = [
    "ext4"
    "btrfs"
    "xfs"
    "ntfs"
    "fat"
    "vfat"
    "exfat"
  ];

  boot.loader.systemd-boot.enable = true;
  # boot.loader.grub = {
  #   enable = true;
  #   device = "nodev";
  #   efiSupport = true;
  #   useOSProber = true;
  # };
  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot/efi";
  };
  boot.kernelPackages = pkgs.linuxPackages_zen;

  fileSystems."/btr_pool" = {
    device = "/dev/disk/by-uuid/bc5fbdc7-9582-4c3f-8afd-9c340e3e9ec5";
    fsType = "btrfs";
    # btrfs's top-level subvolume, internally has an id 5
    # we can access all other subvolumes from this subvolume.
    options = ["subvolid=5"];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/bc5fbdc7-9582-4c3f-8afd-9c340e3e9ec5";
    fsType = "btrfs";
    options = ["subvol=root" "compress=zstd"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/bc5fbdc7-9582-4c3f-8afd-9c340e3e9ec5";
    fsType = "btrfs";
    options = ["subvol=home" "compress=zstd"];
  };

  fileSystems."/snapshots" = {
    device = "/dev/disk/by-uuid/bc5fbdc7-9582-4c3f-8afd-9c340e3e9ec5";
    fsType = "btrfs";
    options = ["subvol=snapshots" "compress=zstd"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/bc5fbdc7-9582-4c3f-8afd-9c340e3e9ec5";
    fsType = "btrfs";
    options = ["subvol=nix" "noatime" "compress=zstd"];
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/9A77-5167";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  swapDevices = [{device = "/dev/disk/by-uuid/b60ee5c2-c058-44c5-b3a2-7d3872da5505";}];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}