{
  config,
  myvars,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.networking) hostName;
  cfg = config.mymodules.server.code-server;
  et-ip = myvars.networking.hostsAddr.easytier."${hostName}".ipv4;
in
{
  config = lib.mkIf cfg.enable {
    services.code-server = {
      enable = true;
      # package = pkg;
      port = 6829;
      host = et-ip;
      extraPackages = [
        pkgs.python3
      ];
      auth = "none";
    };
    programs = {
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    };
  };
}
