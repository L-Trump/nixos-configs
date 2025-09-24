{
  config,
  lib,
  ...
}:
let
  cfg = config.mymodules.server.duplicati;
in
{
  services.duplicati = lib.mkIf cfg.enable {
    enable = true;
    user = "root";
    interface = "127.0.0.1";
    port = 8200;
  };
}
