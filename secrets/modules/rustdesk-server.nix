{
  inputs,
  config,
  lib,
  ...
}:
let
  inherit (inputs) mysecrets;
  cfg = config.mymodules.server.rustdesk-server;
in
{
  age.secrets.hbbs-conf = lib.mkIf cfg.enable {
    file = "${mysecrets}/rustdesk-server/hbbs-conf.ini.age";
    owner = "rustdesk";
    group = "rustdesk";
  };
}
