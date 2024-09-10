{ inputs, ... }:

{
  imports = [
    inputs.agenix.nixosModules.default
    ./vpn
  ];
}
