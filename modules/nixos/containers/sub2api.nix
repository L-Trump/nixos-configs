{
  myvars,
  config,
  lib,
  ...
}:
let
  inherit (config.networking) hostName;
  name = "sub2api";
  cfg = config.mymodules.server.sub2api;
  et-ip = myvars.networking.hostsAddr.easytier."${hostName}".ipv4;

  container = myvars.containers.${name};
  image = "${container.image}@${container.digest}";

  container-redis = myvars.containers."${name}-redis";
  image-redis = "${container-redis.image}@${container-redis.digest}";

  container-postgres = myvars.containers."${name}-postgres";
  image-postgres = "${container-postgres.image}@${container-postgres.digest}";

  serviceConfig = {
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
in
{
  config = lib.mkIf cfg.enable {
    # networking.firewall.allowedTCPPorts = [3003];
    virtualisation.oci-containers.containers.${name} = {
      inherit image;
      environmentFiles = [
        config.age.secrets.sub2api-env.path
      ];
      environment = {
        # https://github.com/Wei-Shaw/sub2api/blob/main/deploy/docker-compose.local.yml
        TZ = "Asia/Shanghai";
        AUTO_SETUP = "true";
      };
      ports = [
        "127.0.0.1:6835:8080"
        "${et-ip}:6835:8080"
      ];
      volumes = [
        "/data/docker/${name}/data:/data:rw"
      ];
      dependsOn = [
        "${name}-postgres"
        "${name}-redis"
      ];
      log-driver = "journald";
      extraOptions = [
        "--network-alias=${name}"
        "--network=oci_net"
      ];
    };

    virtualisation.oci-containers.containers."${name}-redis" = {
      image = image-redis;
      environment = {
        TZ = "Asia/Shanghai";
      };
      volumes = [
        "/data/docker/${name}/redis-data:/data:rw"
      ];
      log-driver = "journald";
      extraOptions = [
        "--network-alias=${name}-redis"
        "--network=oci_net"
      ];
    };

    virtualisation.oci-containers.containers."${name}-postgres" = {
      image = image-postgres;
      environment = {
        TZ = "Asia/Shanghai";
        "POSTGRES_DB" = "sub2api";
        "POSTGRES_HOST_AUTH_METHOD" = "trust";
        "POSTGRES_USER" = "sub2api";
      };
      volumes = [
        "/data/docker/${name}/postgres-data:/var/lib/postgres/data:rw"
      ];
      log-driver = "journald";
      extraOptions = [
        "--network-alias=${name}-postgres"
        "--network=oci_net"
      ];
    };

    systemd.services."docker-${name}" = serviceConfig;
    systemd.services."docker-${name}-redis" = serviceConfig;
    systemd.services."docker-${name}-postgresql" = serviceConfig;
  };
}
