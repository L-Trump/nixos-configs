{
  inputs,
  pkgs,
  ...
}:
let
  inherit (inputs) myfonts;
  win-fonts = pkgs.mkFontPackage "win-fonts" "${myfonts}/winfonts";
in
{
  home.packages = [
    win-fonts
  ];
}
