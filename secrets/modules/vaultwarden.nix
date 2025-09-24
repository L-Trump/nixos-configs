{
  inputs,
  config,
  lib,
  ...
}:
let
  inherit (inputs) mysecrets;
  cfg = config.mymodules.server.vaultwarden;
in
{
  age.secrets.vaultwarden-env = lib.mkIf cfg.enable {
    file = "${mysecrets}/vaultwarden/vaultwarden.env.age";
    owner = "vaultwarden";
    group = "vaultwarden";
  };
}
