{
  inputs,
  config,
  lib,
  ...
}:
let
  inherit (inputs) mysecrets;
  cfg = config.mymodules.server.rustical;
in
{
  age.secrets.rustical-env = lib.mkIf cfg.enable {
    file = "${mysecrets}/rustical/rustical.env.age";
  };
}
