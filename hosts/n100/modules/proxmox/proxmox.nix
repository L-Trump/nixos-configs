{
  inputs,
  pkgs-stable,
  ...
}: let
  system = pkgs-stable.stdenv.hostPlatform.system;
in {
  imports = [
    inputs.proxmox-nixos.nixosModules.proxmox-ve
  ];
  services.proxmox-ve.enable = true;
  nixpkgs.overlays = [
    inputs.proxmox-nixos.overlays.${system}
  ];
}
