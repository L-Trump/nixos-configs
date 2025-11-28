{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.mymodules.server.sshwifty;
  pkg = pkgs.sshwifty;
  # address = "127.0.0.1:9898";
in
{
  config = lib.mkIf cfg.enable {
    services.sshwifty = {
      enable = true;
      package = pkg;
      settings = {
        Servers = [
          {
            ListenInterface = "127.0.0.1";
            ListenPort = 8182;
          }
        ];
      };
    };
  };
}
