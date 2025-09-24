{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.mymodules.server.hubproxy;
  pkg = pkgs.hubproxy;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkg ];

    systemd.services.hubproxy = {
      description = "Hubproxy Server";
      wants = [
        "network-online.target"
        "nss-lookup.target"
      ];
      after = [
        "network-online.target"
        "nss-lookup.target"
      ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkg}/bin/hubproxy";
        Restart = "on-failure";
        StateDirectory = "hubproxy";
        RuntimeDirectory = "hubproxy";
        WorkingDirectory = "/var/lib/hubproxy";
      };
      wantedBy = [ "multi-user.target" ];
    };

    # networking.firewall.allowedTCPPorts = [5244];
  };
}
