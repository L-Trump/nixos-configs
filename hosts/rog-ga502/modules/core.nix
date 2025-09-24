# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  mylib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (inputs) nixos-hardware;
in
{
  imports = [
    # Hardware
    nixos-hardware.nixosModules.asus-zephyrus-ga502
  ];

  # Use the systemd-boot EFI boot loader.

  networking.hostName = "rog-ga502"; # Define your hostname.
  networking.domain = "localdomain";
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  services.resolved.enable = true; # use systemd-resolved as dns manager

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
  services.libinput.touchpad = {
    naturalScrolling = true;
    clickMethod = "clickfinger";
  };

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  services.supergfxd.enable = true;
  services.asusd = {
    enable = true;
    enableUserService = true;
  };

  environment.systemPackages = with pkgs; [
    clinfo
  ];

  services.logind.settings.Login.HandleLidSwitch = "lock";

  # hardware.opentabletdriver.enable = true;

  services.udev.extraRules = ''
    # Mount AMD card
    SUBSYSTEM=="drm", ENV{ID_PATH}=="pci-0000:06:00.0", KERNEL=="card[0-9]*", SYMLINK+="dri/by-name/amd-card"
    SUBSYSTEM=="drm", ENV{ID_PATH}=="pci-0000:06:00.0", KERNEL=="renderD[0-9]*", SYMLINK+="dri/by-name/amd-render"
    # Mount NVIDIA card
    SUBSYSTEM=="drm", ENV{ID_PATH}=="pci-0000:01:00.0", KERNEL=="card[0-9]*", SYMLINK+="dri/by-name/nvidia-card"
    SUBSYSTEM=="drm", ENV{ID_PATH}=="pci-0000:01:00.0", KERNEL=="renderD[0-9]*", SYMLINK+="dri/by-name/nvidia-render"
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
  system.stateVersion = "25.05"; # Did you read the comment?
}
