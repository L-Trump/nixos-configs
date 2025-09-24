{
  myvars,
  config,
  lib,
  ...
}:
let
  inherit (config.networking) hostName;
  name = "nezha-server";
  et-ip = myvars.networking.hostsAddr.easytier."${hostName}".ipv4;
  cfg = config.mymodules.server.${name};
  container = myvars.containers.${name};
  image = "${container.image}@${container.digest}";
in
{
  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 8008 ];
    virtualisation.oci-containers.containers.${name} = {
      inherit image;
      volumes = [
        "/data/docker/${name}/data:/dashboard/data:rw"
      ];
      ports = [
        "127.0.0.1:8008:8008/tcp"
        "${et-ip}:8008:8008/tcp"
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
