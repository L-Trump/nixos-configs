{ config, pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      mkScriptsPackage = name: src: prev.stdenvNoCC.mkDerivation {
        inherit name src;
        dontUnpack = true;
        # setSourceRoot = "sourceRoot=`pwd`";
        installPhase = ''
          install -dm 755 $out/bin
          if [ -f $src ]; then
            install -m 755 -t $out/bin $src
          else
            install -m 755 -t $out/bin $src/*
          fi
        '';
      };
    })
  ];
}