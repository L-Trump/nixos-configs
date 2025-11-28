{
  inputs,
  config,
  lib,
  ...
}:
let
  inherit (inputs) mysecrets;
  cfg = config.mymodules.server.authentik;
in
{
  age.secrets.authentik-env = lib.mkIf cfg.enable {
    file = "${mysecrets}/authentik/authentik.env.age";
  };
  age.secrets.authentik-proxy-env = lib.mkIf cfg.enable {
    file = "${mysecrets}/authentik/authentik-proxy.env.age";
  };
}
