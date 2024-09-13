{
  inputs,
  config,
  lib,
  ...
}: let
  inherit (inputs) mysecrets;
in {
  age.secrets.ipsec-conf = {
    file = "${mysecrets}/vpn/ipsec.conf.age";
    path = "/etc/ipsec.conf";
  };
  age.secrets.ipsec-secrets = {
    file = "${mysecrets}/vpn/ipsec.secrets.age";
    path = "/etc/ipsec.secrets";
  };
  age.secrets.swanctl-conf.file = "${mysecrets}/vpn/strongswan.conf.age";
}
