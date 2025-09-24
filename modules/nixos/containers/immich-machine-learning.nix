{
  myvars,
  config,
  lib,
  ...
}:
let
  inherit (config.networking) hostName;
  name = "immich-machine-learning";
  cfg = config.mymodules.server.immich.machine-learning;
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
        "HTTPS_PROXY" = "http://nas.ltnet:19234";
        "HTTP_PROXY" = "http://nas.ltnet:19234";
        "IMMICH_HOST" = "0.0.0.0";
        "IMMICH_PORT" = "3003";
        "TZ" = "Asia/Shanghai";
      };
      volumes = [
        "/data/docker/immich/model-cache:/cache:rw"
      ];
      ports = [
        "127.0.0.1:3003:3003/tcp"
        "${et-ip}:3003:3003/tcp"
      ];
      log-driver = "journald";
      extraOptions = [
        "--device=/dev/dri:/dev/dri:rwm"
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
