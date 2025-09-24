{
  myvars,
  lib,
  ...
}:
let
  hostName = "aliyun-vm-hk";
in
{
  # networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  services.openssh.enable = true;
  services.resolved.enable = true;
  services.qemuGuest.enable = true;

  networking = {
    inherit hostName;
    firewall.enable = true;
    usePredictableInterfaceNames = false;
    domain = "localdomain";
    nameservers = [
      "100.100.2.136"
      "100.100.2.138"
      "8.8.8.8" # googledns
      "8.8.4.4" # googledns
      "2606:4700:4700::1111"
      "2001:4860:4860::8888"
    ];
  };

  nix.settings.substituters = lib.mkForce [
    "https://nix-community.cachix.org"
    "https://nixpkgs-update-cache.nix-community.org"
  ];

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
  system.stateVersion = "25.11"; # Did you read the comment?
}
