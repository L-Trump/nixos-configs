{inputs, ...}: {
  imports = [
    ./mail.nix
    inputs.agenix.homeManagerModules.default
  ];
}
