{
  config,
  lib,
  ...
}: let
  # TODO wait new version merge https://nixpk.gs/pr-tracker.html?pr=361515
  cfg = config.mymodules.server.nezha-agent;
in {
  services.nezha-agent-dev = lib.mkIf cfg.enable {
    enable = true;
    settings = {
      server = "aliyun-vm-sh.ltnet:8008";
      disableCommandExecute = false;
    };
    genUuid = true;
    clientSecretFile = "${config.age.secrets.nezha-agent-secret.path}";
  };
}
