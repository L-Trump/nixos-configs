{
  config,
  pkgs,
  lib,
  ...
}:
let
  mkIconPackage =
    name: src:
    pkgs.stdenvNoCC.mkDerivation {
      inherit name src;
      dontUnpack = true;
      # setSourceRoot = "sourceRoot=`pwd`";
      installPhase = ''
        install -dm 755 $out/share/icons/${name}
        cp -r $src/* $out/share/icons/${name}
      '';
    };
  meumy-merry-cursors = mkIconPackage "meumy-merry-cursors" ./merry_cursors;
in
{
  home.pointerCursor = {
    name = "meumy-merry-cursors";
    size = 16;
    package = meumy-merry-cursors;
  };
}
