{
  config,
  inputs,
  lib,
  myvars,
  ...
}:
let
  cfg = config.mymodules.server.openviking-server;
  inherit (myvars) username;
  configPath = config.age.secrets.openviking-server-config.path;
  listenAddress = "127.0.0.1";
  port = 1933;
  dataDir = "/home/${username}/.openviking";
in
{
  imports = [
    inputs.openviking.nixosModules.default
  ];

  config = lib.mkIf cfg.enable {
    services.openviking = {
      enable = true;
      user = username;
      group = "users";
      host = listenAddress;
      port = port;
      dataDir = dataDir;
      configFile = configPath;
      readOnlyPaths = [ "/home/${username}" ];
      openFirewall = false;
    };

    environment.systemPackages = [ config.services.openviking.package ];

    # ReadWritePaths is applied before ExecStartPre. Ensure the writable home
    # subtree exists before systemd creates the service mount namespace.
    systemd.tmpfiles.rules = [
      "d ${config.services.openviking.dataDir} 0700 ${username} users -"
    ];

    # openviking-nix currently exports OPENVIKING_HOST/PORT, while OpenViking
    # 0.4.17 consumes CLI flags (or server.host/server.port in ov.conf).
    # Keep the module options authoritative and avoid a listener/firewall drift.
    systemd.services.openviking = {
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      preStart = lib.mkForce ''
        mkdir -p ${lib.escapeShellArg config.services.openviking.dataDir}
        chmod 0700 ${lib.escapeShellArg config.services.openviking.dataDir}
      '';
      serviceConfig.ExecStart = lib.mkForce (
        "${config.services.openviking.package}/bin/openviking-server"
        + " --config ${configPath}"
        + " --host ${lib.escapeShellArg config.services.openviking.host}"
        + " --port ${toString config.services.openviking.port}"
      );
    };
  };
}
