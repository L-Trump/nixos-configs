{
  inputs,
  config,
  lib,
  ...
}:
let
  inherit (inputs) mysecrets;
  cfg = config.mymodules.server.homepage-dashboard;
in
{
  age.secrets.homepage-dashboard-env = lib.mkIf cfg.enable {
    file = "${mysecrets}/homepage-dashboard/secrets.env.age";
  };
}
