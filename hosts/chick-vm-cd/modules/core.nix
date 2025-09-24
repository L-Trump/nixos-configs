{
  myvars,
  lib,
  ...
}:
let
  hostName = "chick-vm-cd";
  inherit (myvars) networking;
  inherit (networking.hostsAddr.physical.${hostName}) iface ipv4 gateway;
  inherit (networking.hostsAddr.physical.${hostName}) iface6 ipv6 gateway6;
in
{
  # networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  services.openssh.enable = true;
  services.resolved.enable = true;

  networking = {
    inherit hostName;
    usePredictableInterfaceNames = false;
    useDHCP = false;
    domain = "localdomain";
  };

  services.qemuGuest.enable = true;

  systemd.network = {
    enable = true;
    wait-online = {
      anyInterface = true;
      timeout = 30;
    };
    networks."10-lan4" = {
      matchConfig.Name = [ iface ];
      networkConfig = {
        Address = [ ipv4 ];
        Gateway = gateway;
        DNS = networking.nameservers;
      };
      linkConfig.RequiredForOnline = "routable";
    };
    networks."10-wan6" = {
      matchConfig.Name = [ iface6 ];
      networkConfig = {
        Address = [ ipv6 ];
        Gateway = gateway6;
        DNS = networking.nameservers6;
      };
      linkConfig.RequiredForOnline = "routable";
    };
  };

  nix.settings.substituters = lib.mkForce [
    "https://mirrors.ustc.edu.cn/nix-channels/store"
    # "https://mirror.sjtu.edu.cn/nix-channels/store"
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
  system.stateVersion = "24.11"; # Did you read the comment?
}
