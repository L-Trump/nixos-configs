{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mymodules.server.alist;
  pkg = pkgs.alist;
in {
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [pkg];

    systemd.services.alist = {
      description = "Alist Driver";
      wants = ["network-online.target" "nss-lookup.target"];
      after = ["network-online.target" "nss-lookup.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkg}/bin/alist server";
        Restart = "on-failure";
        StateDirectory = "alist";
        RuntimeDirectory = "alist";
        WorkingDirectory = "/var/lib/alist";
      };
      wantedBy = ["multi-user.target"];
    };

    # networking.firewall.allowedTCPPorts = [5244];
  };
}
