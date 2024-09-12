{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./tools.nix
    ./packages.nix
    ./ipu6.nix
  ];
}
