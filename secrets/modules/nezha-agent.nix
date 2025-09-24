{
  inputs,
  config,
  lib,
  ...
}:
let
  inherit (inputs) mysecrets;
  cfg = config.mymodules.server.nezha-agent;
in
{
  age.secrets.nezha-agent-secret = lib.mkIf cfg.enable {
    file = "${mysecrets}/nezha/agent-secret.age";
  };
}
