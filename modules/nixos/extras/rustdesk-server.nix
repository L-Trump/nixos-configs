{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.mymodules.server.rustdesk-server;
  pro-package = pkgs.sctgdesk-server;
in {
  services.rustdesk-server = lib.mkIf cfg.enable {
    enable = true;
    package = pro-package;
    signal = {
      enable = true;
      extraArgs = ["-c" "${config.age.secrets.hbbs-conf.path}"];
    };
    relay.enable = true;
  };
  # Use config file for hbbs
  systemd.services.rustdesk-signal = lib.mkIf cfg.enable {
    serviceConfig.ExecStart =
      lib.mkForce "${pro-package}/bin/hbbs -c ${config.age.secrets.hbbs-conf.path}";
  };
}
