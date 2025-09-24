{
  config,
  lib,
  ...
}:
let
  cfg = config.mymodules.server.vaultwarden;
in
{
  services.vaultwarden = lib.mkIf cfg.enable {
    enable = true;
    dbBackend = "sqlite";
    environmentFile = config.age.secrets.vaultwarden-env.path;
    config = {
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
    };
  };
}
