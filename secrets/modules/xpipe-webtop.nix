{
  inputs,
  config,
  lib,
  ...
}:
let
  inherit (inputs) mysecrets;
  cfg = config.mymodules.server.xpipe-webtop;
in
{
  age.secrets.xpipe-webtop-env = lib.mkIf cfg.enable {
    file = "${mysecrets}/xpipe-webtop/secrets.env.age";
  };
}
