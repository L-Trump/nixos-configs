{ pkgs, config, lib, ... }:

let
  strongswanPackage = pkgs.strongswanTNC.overrideAttrs (final: prev: {
    configureFlags = prev.configureFlags ++ [
      "--enable-eap-peap"
      # "--disable-resolve"
    ];
  });
in
{
  environment.systemPackages = [ strongswanPackage ];
  environment.etc."ipsec.d/cacerts/isrgrootx1.pem".source = ./isrgrootx1.pem;
  environment.etc."ipsec.d/cacerts/addtrust.pem".source = ./addtrust.pem;
  services.strongswan-swanctl = {
    enable = true;
    package = strongswanPackage;
    includes = [ config.age.secrets.swanctl-conf.path ];
  };
}
