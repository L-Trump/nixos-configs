{
  inputs,
  config,
  lib,
  ...
}:
let
  inherit (inputs) mysecrets;
in
{
  age.secrets.ipsec-conf = lib.mkIf config.mymodules.desktop.enable {
    file = "${mysecrets}/vpn/ipsec.conf.age";
    path = "/etc/ipsec.conf";
  };
  age.secrets.ipsec-secrets = lib.mkIf config.mymodules.desktop.enable {
    file = "${mysecrets}/vpn/ipsec.secrets.age";
    path = "/etc/ipsec.secrets";
  };
  age.secrets.swanctl-conf = lib.mkIf config.mymodules.desktop.enable {
    file = "${mysecrets}/vpn/strongswan.conf.age";
  };
  age.secrets.fortivpnconf = lib.mkIf config.mymodules.desktop.enable {
    file = "${mysecrets}/vpn/fortivpnconf.age";
    path = "/etc/.fortivpnconf";
  };
}
