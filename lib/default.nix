{ lib, ... }:
{
  nixosSystem = import ./nixosSystem.nix;
  colmenaSystem = import ./colmenaSystem.nix;
  microvmInfra = import ./microvmInfra.nix;

  relativeToRoot = lib.path.append ../.;
  scanPaths =
    path:
    builtins.map (f: (path + "/${f}")) (
      builtins.attrNames (
        lib.attrsets.filterAttrs (
          path: _type:
          (_type == "directory") # include directories
          || (
            (path != "default.nix") # ignore default.nix
            && (lib.strings.hasSuffix ".nix" path) # include .nix files
          )
        ) (builtins.readDir path)
      )
    );
  toKDL = import ./toKDL.nix { inherit lib; };
}
