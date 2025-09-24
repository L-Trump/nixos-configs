{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.mymodules.server.backrest;
  pkg = pkgs.backrest;
  pkg-restic = pkgs.restic;
  address = "127.0.0.1:9898";
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkg
      pkg-restic
    ];
    systemd.services.backrest = {
      path = with pkgs; [
        pkg
        pkg-restic
        rclone
        config.programs.ssh.package
        "/run/wrappers"
      ];
      description = "Backrest (restic) backup server";
      wants = [ "network-online.target" ];
      after = [
        "network-online.target"
        "multi-user.target"
      ];
      environment = {
        BACKREST_PORT = address;
        BACKREST_CONFIG = "/var/lib/backrest/config/config.json";
        BACKREST_DATA = "/var/lib/backrest/data";
        BACKREST_RESTIC_COMMAND = "${pkg-restic}/bin/restic";
        XDG_CACHE_HOME = "/var/cache/backrest";
        RCLONE_CONFIG = "/etc/rclone/rclone.conf";
      };
      serviceConfig = {
        Type = "simple";
        User = "root";
        ExecStart = "${pkg}/bin/backrest";
        StateDirectory = "backrest";
        CacheDirectory = "backrest";
        Restart = "on-failure";
        RestartSec = 30;
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
