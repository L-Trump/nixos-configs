{
  config,
  lib,
  ...
}:
let
  cfg = config.mymodules.server.rustical;
in
{
  services.rustical = lib.mkIf cfg.enable {
    enable = true;
    settings = {
      http.port = 6826;
    };
    environmentFile = "${config.age.secrets.rustical-env.path}";
  };
}
