{ config, pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    (final: prev:
      {
        ipu6-camera-bins = prev.ipu6-camera-bins.overrideAttrs (_final: _prev: {
          version = "0-unstable-2024-07-19";
          src = prev.fetchFromGitHub {
            owner = "intel";
            repo = "ipu6-camera-bins";
            rev = "532cb2b946b9fcb3038389a7cf126fe56f4203af";
            hash = "sha256-17AybqhqK+SnawIlgMysGjlAyz9kBILpH9pljoO0ikc=";
          };
        });
      }
    )
  ];
}
