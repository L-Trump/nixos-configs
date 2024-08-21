{ config, lib, pkgs, ... }:
let
  mkFontPackage = name: src: pkgs.stdenvNoCC.mkDerivation {
    inherit name src;
    dontUnpack = true;
    setSourceRoot = "sourceRoot=`pwd`";
    installPhase = ''
      mkdir -p $out/share/fonts
      mkdir -p $out/share/fonts/opentype
      mkdir -p $out/share/fonts/truetype
      find -name \*.otf -exec mv {} $out/share/fonts/OTF/ \;
      find -name \*.{ttf,ttc} -exec mv {} $out/share/fonts/TTF/ \;
    '';
  };
in

{

  fonts = {
    packages = with pkgs; [
      # icon fonts
      material-design-icons

      # normal fonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      source-code-pro

      vistafonts-chs
      vistafonts

      # nerdfonts
      (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
    ];

    # enableDefaultPackages = false;

    # fontconfig.defaultFonts = {
    #   serif = [ "Noto Serif" "Noto Color Emoji" ];
    #   sansSerif = [ "Noto Sans" "Noto Color Emoji" ];
    #   monospace = [ "JetBrainMono Nerd Font" "Noto Color Emoji" ];
    #   emoji = [ "Noto Color Emoji" ];
    # };
  };
}
