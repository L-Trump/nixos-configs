{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.mymodules.server.rustdesk-server;
  pro-package = pkgs.rustdesk-server-pro;
in
{
  config = lib.mkIf cfg.enable {
    services.rustdesk-server = {
      enable = true;
      package = pro-package;
      signal = {
        enable = true;
        extraArgs = [
          "-c"
          "${config.age.secrets.hbbs-conf.path}"
        ];
      };
      relay.enable = true;
      openFirewall = true;
    };
    # Use config file for hbbs
    systemd.services.rustdesk-signal = {
      serviceConfig.ExecStart = lib.mkForce "${pro-package}/bin/hbbs -c ${config.age.secrets.hbbs-conf.path}";
    };
    # Allow port 21114 (Api server)
    networking.firewall.allowedTCPPorts = [ 21114 ];
  };
}
