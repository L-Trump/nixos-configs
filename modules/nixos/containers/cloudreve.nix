{
  myvars,
  config,
  lib,
  ...
}:
let
  inherit (config.networking) hostName;
  name = "cloudreve-master";
  cfg = config.mymodules.server.cloudreve.master;
  et-ip = myvars.networking.hostsAddr.easytier."${hostName}".ipv4;

  container = myvars.containers.cloudreve;
  image = "${container.image}@${container.digest}";

  container-redis = myvars.containers.cloudreve-redis;
  image-redis = "${container-redis.image}@${container-redis.digest}";

  container-postgresql = myvars.containers.cloudreve-postgresql;
  image-postgresql = "${container-postgresql.image}@${container-postgresql.digest}";

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
    virtualisation.oci-containers.containers."${name}-backend" = {
      inherit image;
      environment = {
        TZ = "Asia/Shanghai";
        "CR_CONF_Database.Host" = "${name}-postgresql";
        "CR_CONF_Database.Name" = "cloudreve";
        "CR_CONF_Database.Port" = "5432";
        "CR_CONF_Database.Type" = "postgres";
        "CR_CONF_Database.User" = "cloudreve";
        "CR_CONF_Redis.Server" = "${name}-redis:6379";
      };
      volumes = [
        "/data/docker/${name}/backend-data:/cloudreve/data:rw"
      ];
      ports = [
        "127.0.0.1:5212:5212/tcp"
        "${et-ip}:5212:5212/tcp"
      ];
      dependsOn = [
        "${name}-postgresql"
        "${name}-redis"
      ];
      log-driver = "journald";
      extraOptions = [
        "--network-alias=${name}-backend"
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

    virtualisation.oci-containers.containers."${name}-postgresql" = {
      image = image-postgresql;
      environment = {
        TZ = "Asia/Shanghai";
        "POSTGRES_DB" = "cloudreve";
        "POSTGRES_HOST_AUTH_METHOD" = "trust";
        "POSTGRES_USER" = "cloudreve";
      };
      volumes = [
        "/data/docker/${name}/postgres-data:/var/lib/postgresql/data:rw"
      ];
      log-driver = "journald";
      extraOptions = [
        "--network-alias=${name}-postgresql"
        "--network=oci_net"
      ];
    };

    systemd.services."docker-${name}-backend" = serviceConfig;
    systemd.services."docker-${name}-redis" = serviceConfig;
    systemd.services."docker-${name}-postgresql" = serviceConfig;
  };
}
