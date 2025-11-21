{
  myvars,
  config,
  lib,
  ...
}:
let
  inherit (config.networking) hostName;
  name = "xpipe-webtop";
  cfg = config.mymodules.server.xpipe-webtop;
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
        TZ = "Asia/Shanghai";
      };
      environmentFiles = [
        config.age.secrets.xpipe-webtop-env.path
      ];
      volumes = [
        "/data/docker/${name}/config:/config:rw"
        "/var/run/docker.sock:/var/run/docker.sock:ro"
      ];
      ports = [
        "127.0.0.1:6790:3000/tcp"
        "${et-ip}:6790:3000/tcp"
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
