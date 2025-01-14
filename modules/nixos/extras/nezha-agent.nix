{
  config,
  lib,
  ...
}: let
  # TODO wait new version merge https://nixpk.gs/pr-tracker.html?pr=361515
  # cfg = config.mymodules.server.nezha-agent;
  cfg.enable = false;
in {
  services.nezha-agent = lib.mkIf cfg.enable {
    enable = true;
    server = "10.144.144.251:8008";
    passwordFile = "${config.age.secrets.nezha-agent-secret.path}";
    disableCommandExecute = false;
  };
}
