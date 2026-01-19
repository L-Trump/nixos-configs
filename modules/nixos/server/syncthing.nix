{
  config,
  lib,
  ...
}:
let
  cfg = config.mymodules.server.syncthing;
in
{
  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      openDefaultPorts = true;
      user = "root";
      settings = {
        gui = {
          insecureSkipHostcheck = true;
          insecureAdminAccess = true;
        };
      };
    };
  };
}
