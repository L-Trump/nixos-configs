{
  myvars,
  config,
  lib,
  ...
}:
let
  inherit (config.networking) hostName;
  name = "ncm-api";
  cfg = config.mymodules.server.ncm-api;
  et-ip = myvars.networking.hostsAddr.easytier."${hostName}".ipv4;

  container = myvars.containers.${name};
  image = "${container.image}@${container.digest}";
in
{
  config = lib.mkIf cfg.enable {
    # networking.firewall.allowedTCPPorts = [3003];
    virtualisation.oci-containers.containers.${name} = {
      inherit image;
      environment = {
        # https://github.com/NeteaseCloudMusicApiEnhanced/api-enhanced
        TZ = "Asia/Shanghai";
        PORT = "6816";
        SELECT_MAX_BR = "true";
      };
      ports = [
        "127.0.0.1:6816:6816/tcp"
        "${et-ip}:6816:6816/tcp"
      ];
      log-driver = "journald";
      extraOptions = [
        "--network-alias=${name}"
        "--network=oci_net"
      ];
    };

    systemd.services."docker-${name}" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "always";
        RestartMaxDelaySec = lib.mkOverride 90 "1m";
        RestartSec = lib.mkOverride 90 "100ms";
        RestartSteps = lib.mkOverride 90 9;
      };
      after = [
        "docker-network-oci_net.service"
      ];
      requires = [
        "docker-network-oci_net.service"
      ];
      partOf = [
        "docker-compose-oci-root.target"
      ];
      wantedBy = [
        "docker-compose-oci-root.target"
      ];
    };
  };
}
