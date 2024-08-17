{ config, pkgs, lib, ... }:
let
  my-scripts = pkgs.buildEnv {
    name = "my-scripts";
    paths = [ ./bin ];
    extraPrefix = "/bin";
    ignoreCollisions = true;
  };
in
{
  home.packages = [ my-scripts ];
  # home.file.".local/bin/custom_scripts".source = "${my-scripts}/bin";
}
