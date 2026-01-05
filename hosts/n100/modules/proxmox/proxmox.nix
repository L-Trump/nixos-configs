{
  inputs,
  lib,
  pkgs,
  pkgs-stable,
  ...
}:
let
  system = pkgs-stable.stdenv.hostPlatform.system;
in
{
  imports = [
    inputs.proxmox-nixos.nixosModules.proxmox-ve
  ];
  services.openssh = {
    enable = true;
    settings.AcceptEnv = lib.mkForce [
      "LANG"
      "LC_*"
    ];
  };
  environment.systemPackages = with pkgs; [ swtpm ];
  environment.etc."swtpm_setup.conf".source = "${pkgs.swtpm}/etc/swtpm_setup.conf";
  services.proxmox-ve = {
    enable = true;
    ipAddress = "192.168.2.111";
  };
  nixpkgs.overlays = [
    inputs.proxmox-nixos.overlays.${system}
  ];
}
