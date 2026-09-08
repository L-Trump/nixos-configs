{
  config,
  inputs,
  lib,
  myvars,
  ...
}:
let
  cfg = config.mymodules.server.openviking-server;
  inherit (inputs) mysecrets;
  inherit (myvars) username;
in
{
  age.secrets.openviking-server-config = lib.mkIf cfg.enable {
    file = "${mysecrets}/openviking/ov.conf.age";
    owner = username;
    group = "users";
    mode = "0400";
  };
}
