{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.mymodules.server.kopia-server;
  pkg = pkgs.kopia;
  address = "127.0.0.1:51515";
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkg ];
    systemd.services.kopia-server = {
      path = with pkgs; [
        pkg
        rclone
        config.programs.ssh.package
        "/run/wrappers"
      ];
      description = "Kopia backup server";
      wants = [ "network-online.target" ];
      after = [
        "network-online.target"
        "multi-user.target"
      ];
      environment = {
        KOPIA_CONFIG_PATH = "/var/lib/kopia-server/config/repository.config";
        KOPIA_LOG_DIR = "/var/lib/kopia-server/logs";
        KOPIA_CACHE_DIRECTORY = "/var/lib/kopia-server/cache";
        # RCLONE_CONFIG = "/app/rclone/rclone.conf"; # rclone config file
        KOPIA_PERSIST_CREDENTIALS_ON_CONNECT = "false";
        KOPIA_CHECK_FOR_UPDATES = "false";
        # KOPIA_SERVER_USERNAME = "xxxx"; # provide in secret file
        # KOPIA_SERVER_PASSWORD = "xxxx";
        # KOPIA_PASSWORD = "xxxx"; # Repository password, needed by restart
      };
      serviceConfig = {
        EnvironmentFile = config.age.secrets.kopia-env.path;
        Type = "simple";
        User = "root";
        ExecStart = "${pkg}/bin/kopia server start --disable-csrf-token-checks --insecure --address=${address}";
        Restart = "on-failure";
        RestartSec = 30;
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
