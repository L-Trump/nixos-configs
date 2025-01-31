{
  config,
  myvars,
  pkgs,
  lib,
  ...
}: let
  inherit (myvars.networking) hostsRecord;
  easytier-pkg = pkgs.easytier;
  cfg.et-ltnet.enable = builtins.hasAttr "easytier-conf" config.age.secrets;
  cfg.et = config.mymodules.server.easytier;
in {
  services.tailscale = {
    enable = true;
    openFirewall = true;
  };

  environment.systemPackages = [easytier-pkg];

  networking.hosts = lib.mkIf cfg.et-ltnet.enable hostsRecord;
  systemd.services.easytier-ltnet = lib.mkIf cfg.et-ltnet.enable {
    path = with pkgs; [easytier-pkg iproute2 bash];
    description = "EasyTier Service";
    # wants = ["network-online.target" "nss-lookup.target"];
    after = ["network-online.target" "nss-lookup.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${easytier-pkg}/bin/easytier-core -c ${config.age.secrets.easytier-conf.path} --multi-thread";
      Restart = "on-failure";
    };
    wantedBy = ["multi-user.target"];
  };

  systemd.services.easytier-online = lib.mkIf cfg.et.enable {
    path = with pkgs; [easytier-pkg iproute2 bash];
    description = "EasyTier Service with Web Controller";
    wants = ["network-online.target" "nss-lookup.target"];
    after = ["network-online.target" "nss-lookup.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${easytier-pkg}/bin/easytier-core -w ${cfg.et.config-server} --multi-thread";
      Restart = "on-failure";
    };
    wantedBy = ["multi-user.target"];
  };

  networking.firewall = {
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
}
