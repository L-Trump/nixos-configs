{
  myvars,
  config,
  lib,
  inputs,
  ...
}:
let
  name = "rustdesk-api";
  cfg = config.mymodules.server.${name};
  container = myvars.containers.${name};
  image = "${container.image}@${container.digest}";
  envfile = "${inputs.mysecrets}/rustdesk-server/api.env";
in
{
  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 8008 ];
    virtualisation.oci-containers.containers.${name} = {
      inherit image;
      environmentFiles = [
        envfile
      ];
      volumes = [
        "/data/docker/${name}/api:/app/data:rw"
        # "/data/docker/${name}/server:/app/conf/data:rw"
      ];
      log-driver = "journald";
      extraOptions = [
        "--network=host"
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
