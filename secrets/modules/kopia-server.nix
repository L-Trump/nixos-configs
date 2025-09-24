{
  inputs,
  config,
  lib,
  ...
}:
let
  inherit (inputs) mysecrets;
  cfg = config.mymodules.server.kopia-server;
in
{
  age.secrets.kopia-env = lib.mkIf cfg.enable {
    file = "${mysecrets}/kopia/kopia.env.age";
  };
}
