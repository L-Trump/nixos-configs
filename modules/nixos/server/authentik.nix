{
  inputs,
  config,
  pkgs,
  lib,
  myvars,
  ...
}:
let
  inherit (config.networking) hostName;
  cfg = config.mymodules.server.authentik;
  pkg = pkgs.authentik;
  et-ip = myvars.networking.hostsAddr.easytier."${hostName}".ipv4;
  # address = "127.0.0.1:9898";
in
{
  imports = [ inputs.authentik-nix.nixosModules.default ];
  config = lib.mkIf cfg.enable {
    services.authentik = {
      enable = true;
      createDatabase = true;
      environmentFile = config.age.secrets.authentik-env.path;
      settings = {
        listen = {
          http = "0.0.0.0:6900";
          https = "127.0.0.1:6910";
          metrics = "127.0.0.1:6920";
          # debug = "127.0.0.1:6903";
          # debug_py = "127.0.0.1:6904";
        };
        log_level = "info";
        disable_update_check = true;
        error_reporting.enable = false;
        session_storage = "db";
        disable_startup_analytics = true;
      };

      worker = {
        listenHTTP = "127.0.0.1:6901";
        listenMetrics = "127.0.0.1:6921";
      };
    };

    services.authentik-ldap = {
      enable = false;
      listenMetrics = "127.0.0.1:6922";
    };

    services.authentik-proxy = {
      enable = true;
      environmentFile = config.age.secrets.authentik-proxy-env.path;
      listenHTTP = "0.0.0.0:6903";
      listenHTTPS = "127.0.0.1:6913";
      listenMetrics = "127.0.0.1:6923";
    };

    services.authentik-rac = {
      enable = false;
    };
  };
}
