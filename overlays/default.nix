{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./tools.nix
    ./packages.nix
    ./nurs.nix
  ];
}
