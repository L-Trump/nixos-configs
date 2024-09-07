{ pkgs ? import <nixpkgs> { }
, ...
}:

let
  inherit (pkgs) lib;
in

{
  easytier = pkgs.callPackage ./easytier { };
  xdg-desktop-portal-termfilechooser = pkgs.callPackage ./xdg-desktop-portal-termfilechooser { };
}
