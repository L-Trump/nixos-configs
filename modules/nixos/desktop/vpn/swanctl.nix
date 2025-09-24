{
  pkgs,
  config,
  lib,
  ...
}:
let
  strongswanPackage = pkgs.strongswanTNC.overrideAttrs (
    final: prev: {
      configureFlags = prev.configureFlags ++ [
        "--enable-eap-peap"
        # "--disable-resolve"
      ];
    }
  );
in
{
  environment.systemPackages = [ strongswanPackage ];
  services.strongswan-swanctl = {
    enable = true;
    package = strongswanPackage;
    includes = [ config.age.secrets.swanctl-conf.path ];
  };
}
