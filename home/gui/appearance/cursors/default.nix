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
  meumy-merry-cursors = mkIconPackage "meumy-merry-cursors" ./merry_pixel_cursors;
  # The upstream theme only ships 32x32 art.  niri requests cursors at
  # `size * ceil(output_scale)`, so fractional-scale outputs ask for 64px and
  # would fall back to the 32px image (drawing a visually smaller cursor).
  # Append exact 2x nearest-neighbour copies so the compositor can pick them.
  meumy-umy-pixel-cursors = pkgs.stdenvNoCC.mkDerivation {
    name = "meumy-umy-pixel-cursors";
    src = ./umy_pixel_cursors;
    nativeBuildInputs = [ pkgs.python3 ];
    dontUnpack = true;
    installPhase = ''
      install -dm 755 $out/share/icons/meumy-umy-pixel-cursors
      cp -r $src/* $out/share/icons/meumy-umy-pixel-cursors/
      chmod -R u+w $out/share/icons/meumy-umy-pixel-cursors
      python3 ${./xcursor-upscale.py} $out/share/icons/meumy-umy-pixel-cursors/cursors
    '';
  };
in
{
  home.pointerCursor = {
    enable = true;
    name = "meumy-umy-pixel-cursors";
    size = 32;
    package = meumy-umy-pixel-cursors;
  };
}
