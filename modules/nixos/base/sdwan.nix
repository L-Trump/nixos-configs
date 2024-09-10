{ config, pkgs, ... }:
let
  easytier-pkg = pkgs.easytier;
in
{
  services.tailscale.enable = true;

  environment.systemPackages = [ easytier-pkg ];
  systemd.services.easytier-ltnet = {
    path = with pkgs; [ easytier-pkg iproute2 bash ];
    description = "EasyTier Service";
    wants = [ "network.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${easytier-pkg}/bin/easytier-core -c ${config.age.secrets.easytier-conf.path} --multi-thread";
      Restart = "on-failure";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
