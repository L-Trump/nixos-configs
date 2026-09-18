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
      http.bind = "127.0.0.1:6826";
    };
    environmentFiles = [ "${config.age.secrets.rustical-env.path}" ];
  };
}
