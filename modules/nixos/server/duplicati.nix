{
  config,
  lib,
  ...
}: let
  cfg = config.mymodules.server.duplicati;
in {
  services.duplicati = lib.mkIf cfg.enable {
    enable = true;
    user = "root";
  };
}
