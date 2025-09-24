{
  pkgs,
  config,
  lib,
  ...
}:
let
  strongswanConf = builtins.toFile "strongswan.conf" ''
    charon {
      plugins {
        stroke {
          secrets_file = ${config.age.secrets.ipsec-secrets.path}
        }
        revocation {
          load = no
        }
      }
    }
    starter {
      config_file = ${config.age.secrets.ipsec-conf.path}
    }
  '';
  strongswanPackage = pkgs.strongswan;
in
{
  environment.systemPackages = [ strongswanPackage ];

  systemd.services.strongswan = {
    description = "strongSwan IPSec Service";
    wantedBy = [ "multi-user.target" ];
    path = with pkgs; [
      kmod
      iproute2
      iptables
      util-linux
    ]; # XXX Linux
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    environment = {
      STRONGSWAN_CONF = strongswanConf;
    };
    serviceConfig = {
      ExecStart = "${pkgs.strongswan}/sbin/ipsec start --nofork";
    };
    preStart = ''
      # with 'nopeerdns' setting, ppp writes into this folder
      mkdir -m 700 -p /etc/ppp
    '';
  };
}
