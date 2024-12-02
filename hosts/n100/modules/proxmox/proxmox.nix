{
  inputs,
  pkgs,
  pkgs-stable,
  ...
}: let
  system = pkgs-stable.stdenv.hostPlatform.system;
in {
  imports = [
    inputs.proxmox-nixos.nixosModules.proxmox-ve
  ];
  environment.systemPackages = with pkgs; [swtpm];
  environment.etc."swtpm_setup.conf".source = "${pkgs.swtpm}/etc/swtpm_setup.conf";
  services.proxmox-ve.enable = true;
  nixpkgs.overlays = [
    inputs.proxmox-nixos.overlays.${system}
  ];
}
