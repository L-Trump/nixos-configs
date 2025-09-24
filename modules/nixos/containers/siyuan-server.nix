{
  myvars,
  config,
  lib,
  ...
}:
let
  inherit (config.networking) hostName;
  name = "siyuan-server";
  cfg = config.mymodules.server.siyuan-server;
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
        # Auth code is provided in envfile
        # SIYUAN_ACCESS_CODE = "password";
        # SIYUAN_ACCESS_AUTH_CODE_BYPASS = "false";
      };
      environmentFiles = [
        config.age.secrets.siyuan-server-env.path
      ];
      volumes = [
        "/data/docker/${name}/workspace:/siyuan/workspace:rw"
        "${./siyuan-server-entry.sh}:/siyuan/entrypoint.sh:ro"
      ];
      ports = [
        "127.0.0.1:6806:6806/tcp"
        "${et-ip}:6806:6806/tcp"
      ];
      entrypoint = "/siyuan/entrypoint.sh";
      cmd = [
        "--workspace=/siyuan/workspace/"
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
