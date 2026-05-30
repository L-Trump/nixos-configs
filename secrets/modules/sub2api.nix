{
  inputs,
  config,
  lib,
  ...
}:
let
  inherit (inputs) mysecrets;
  cfg = config.mymodules.server.sub2api;
in
{
  age.secrets.sub2api-env = lib.mkIf cfg.enable {
    file = "${mysecrets}/sub2api/sub2api.env.age";
  };
}
