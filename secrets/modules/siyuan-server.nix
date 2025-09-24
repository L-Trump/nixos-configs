{
  inputs,
  config,
  lib,
  ...
}:
let
  inherit (inputs) mysecrets;
  cfg = config.mymodules.server.siyuan-server;
in
{
  age.secrets.siyuan-server-env = lib.mkIf cfg.enable {
    file = "${mysecrets}/siyuan-server/siyuan.env.age";
  };
}
