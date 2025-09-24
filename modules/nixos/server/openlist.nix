{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.mymodules.server.openlist;
  pkg = pkgs.openlist;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkg ];

    systemd.services.openlist = {
      description = "OpenList Driver";
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
        ExecStart = "${pkg}/bin/OpenList server";
        Restart = "on-failure";
        StateDirectory = "openlist";
        RuntimeDirectory = "openlist";
        WorkingDirectory = "/var/lib/openlist";
      };
      wantedBy = [ "multi-user.target" ];
    };

    # networking.firewall.allowedTCPPorts = [5244];
  };
}
