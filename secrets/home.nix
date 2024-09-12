{inputs, ...}: {
  imports = [
    ./mail/home.nix
    inputs.agenix.homeManagerModules.default
  ];
}
