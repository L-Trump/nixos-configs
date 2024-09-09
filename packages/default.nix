{ pkgs ? import <nixpkgs> { }
, ...
}:

let
  inherit (pkgs) lib;
in

{
  easytier = pkgs.callPackage ./easytier { };
  xdg-desktop-portal-termfilechooser = pkgs.callPackage ./xdg-desktop-portal-termfilechooser { };
  ipu6-camera-hal = pkgs.callPackage ./ipu6-camera-hal { };
  ipu6epmtl-camera-hal = pkgs.callPackage ./ipu6-camera-hal { ipuVersion = "ipu6epmtl"; };
}
