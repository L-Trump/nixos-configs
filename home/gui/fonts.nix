{
  inputs,
  pkgs,
  ...
}:
let
  inherit (inputs) myfonts;
  bar-fonts = pkgs.mkFontPackage "bar-fonts" "${myfonts}/bar-fonts";
in
{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    source-code-pro
    bar-fonts
  ];
}
