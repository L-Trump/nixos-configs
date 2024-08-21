# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./touch-screen.nix
      ../../modules/i3.nix
      ../../modules/system
      ../../modules/vpn
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
  };
  # boot.loader.systemd-boot.enable = true;
  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot";
  };
  boot.kernelPackages = pkgs.linuxPackages_zen;
  # boot.kernelPackages = pkgs.linuxPackages_testing;
  boot.kernelParams = [
    #   "i915.force_probe=7d55"
    #   "xe.force_probe=!7d55"
    "i915.enable_psr=0"
    "i915.enable_guc=3"
    "snd-intel-dspcfg.dsp_driver=1"
  ];

  # boot.extraModprobeConfig = ''
  #   softdep i2c_hid pre: pinctrl_meteorlake
  #   softdep i2c_hid_acpi pre: xe pinctrl_meteorlake
  #   softdep hid_generic pre: pinctrl_meteorlake
  #   softdep hid_multitouch pre: pinctrl_meteorlake
  # '';

  hardware.firmware = with pkgs; [ sof-firmware ];

  networking.hostName = "ltrumpNixOS"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
  services.libinput.touchpad.naturalScrolling = true;
  services.xserver.videoDrivers = [ "modesetting" ];
  services.tlp.enable = true;
  # services.xserver.deviceSection = ''
  #   Option "TearFree" "true"
  # '';

  hardware.graphics.enable32Bit = true;
  hardware.graphics.extraPackages = with pkgs; [
    intel-compute-runtime
    intel-media-driver
    # intel-ocl
  ];

  hardware.intelgpu.driver = "xe";

  # hardware.ipu6.enable = true;
  # hardware.ipu6.platform = "ipu6epmtl";

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
  '';
  services.udev.extraHwdb = ''
    # Huawei MACH-WX9
    evdev:atkbd:dmi:bvn*:bvr*:svnhuawei*:pnmach-wx9:pvr*
      keyboard_key_f7=unknown
      keyboard_key_f8=fn
      keyboard_key_281=unknown
      keyboard_key_282=unknown

    # huawei magicbook pro 16.1 2020
    evdev:atkbd:dmi:bvn*:bvr*:svnhuawei*:pnhlyl-wxx9*:pvr*
      keyboard_key_f8=fn

    # huawei & honor microphone mute
    evdev:name:huawei wmi hotkeys:dmi:bvn*:bvr*:bd*:svnhuawei*
    evdev:name:huawei wmi hotkeys:dmi:bvn*:bvr*:bd*:svnhonor*
      keyboard_key_287=f20         # microphone mute button, should be micmute
  '';

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?

}
