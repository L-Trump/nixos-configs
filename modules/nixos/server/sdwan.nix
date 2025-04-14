{
  config,
  myvars,
  lib,
  ...
}: let
  inherit (myvars.networking) hostsRecord;
  cfg.et-ltnet.enable = builtins.hasAttr "easytier-conf" config.age.secrets;
  cfg.et = config.mymodules.server.easytier;
in {
  services.tailscale = {
    enable = true;
    openFirewall = true;
  };

  services.easytier = {
    enable = cfg.et.enable;
    allowSystemForward = true;
    instances.web.configServer = cfg.et.config-server;
    instances.ltnet.configFile = lib.mkIf cfg.et-ltnet.enable config.age.secrets.easytier-conf.path;
  };

  networking = lib.mkIf (cfg.et.enable && cfg.et-ltnet.enable) {
    hosts = lib.mkIf cfg.et-ltnet.enable hostsRecord;
    firewall = {
      trustedInterfaces = ["easytier.ltnet"];
      allowedTCPPortRanges = [
        {
          from = 11010;
          to = 11020;
        }
      ];
      allowedUDPPortRanges = [
        {
          from = 11010;
          to = 11020;
        }
      ];
    };
  };
}
