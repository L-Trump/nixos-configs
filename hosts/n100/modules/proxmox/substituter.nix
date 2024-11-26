_: {
  nix.settings = {
    substituters = [
      "https://cache.saumon.network/proxmox-nixos"
    ];
    trusted-public-keys = [
      "proxmox-nixos:nveXDuVVhFDRFx8Dn19f1WDEaNRJjPrF2CPD2D+m1ys="
    ];
  };
}
