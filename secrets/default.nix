{ inputs, ... }:

{
  imports = [
    inputs.agenix.nixosModules.default
    ./vpn
  ];

  nixpkgs.overlays = [
    inputs.agenix.overlays.default
  ];
}
