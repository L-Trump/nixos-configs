{
  config,
  pkgs,
  lib,
  mylib,
  ...
}:
let
  my-scripts = pkgs.mkScriptsPackage "my-scripts" ./bin;
in
{
  home.packages = [ my-scripts ];
  # home.file.".local/bin/custom_scripts".source = "${my-scripts}/bin";
}
