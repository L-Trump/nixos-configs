{inputs, ...}: {
  imports = [
    inputs.agenix.nixosModules.default
    ./vpn.nix
    ./easytier.nix
  ];

  nixpkgs.overlays = [
    inputs.agenix.overlays.default
  ];
}
