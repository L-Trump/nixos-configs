# See https://wiki.nixos.org/wiki/Fingerprint_scanner
{ pkgs, inputs, ... }:
{
  imports = [
    inputs.nix-openclaw.nixosModules.openclaw-gateway
  ];
  nixpkgs.overlays = [
    inputs.nix-openclaw.overlays.default
  ];
  nix.settings = {
    substituters = [ "https://cache.garnix.io" ];
    trusted-public-keys = [ "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=" ];
  };
  environment.systemPackages = [
    pkgs.openclawPackages.openclaw
  ];
  # systemd.services.fprintd = {
  #   wantedBy = [ "multi-user.target" ];
  #   serviceConfig.Type = "simple";
  # };

  # security.pam.services.swaylock = {
  #   fprintAuth = true;
  #   allowNullPassword = true;
  #   rules.auth.unix.order = 11390;
  # };
}
