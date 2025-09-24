{
  config,
  lib,
  ...
}:
let
  cfg = config.mymodules.server.nezha-agent;
in
{
  services.nezha-agent = lib.mkIf cfg.enable {
    enable = true;
    settings = {
      server = "aliyun-vm-sh.ltnet:8008";
      disable_command_execute = false;
    };
    genUuid = true;
    clientSecretFile = "${config.age.secrets.nezha-agent-secret.path}";
  };
}
