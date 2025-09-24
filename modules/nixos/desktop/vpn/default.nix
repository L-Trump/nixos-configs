{ pkgs, ... }:
let
  vpn-scripts = pkgs.mkScriptsPackage "vpn-scripts" ./scripts;
in
{
  imports = [ ./swanctl.nix ];

  environment.systemPackages = with pkgs; [
    openfortivpn
    vpn-scripts
  ];
  environment.etc."ipsec.d/cacerts/isrgrootx1.pem".source = ./certs/isrgrootx1.pem;
  environment.etc."ipsec.d/cacerts/addtrust.pem".source = ./certs/addtrust.pem;
  environment.etc."ipsec.d/cacerts/DigiCertGlobalRootG3.crt.pem".source =
    ./certs/DigiCertGlobalRootG3.crt.pem;
}
