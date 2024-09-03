{ pkgs ? import <nixpkgs> { }
, ...
}:

let
  inherit (pkgs) lib;
in

{
  easytier = pkgs.callPackage ./easytier { };
}
