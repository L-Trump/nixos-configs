{
  pkgs,
  config,
  lib,
  ...
}: {
  age.secrets.ipsec-conf = {
    file = ./ipsec.conf.age;
    path = "/etc/ipsec.conf";
  };
  age.secrets.ipsec-secrets = {
    file = ./ipsec.secrets.age;
    path = "/etc/ipsec.secrets";
  };
  age.secrets.swanctl-conf.file = ./strongswan.conf.age;
}
