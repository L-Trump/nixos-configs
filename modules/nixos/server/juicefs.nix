{
  myvars,
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (config.networking) hostName;
  et-ip = myvars.networking.hostsAddr.easytier."${hostName}".ipv4;
  cfg = config.mymodules.server.juicefs;
  dcfg = config.mymodules.server.redis.juicefs-meta;
  pkg = pkgs.juicefs;
  master = {
    host = "aliyun-vm-sh.ltnet";
    port = dcfg.port;
  };
in
{
  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      mymodules.server.juicefs.meta-url = lib.mkDefault "redis://${master.host}:${toString master.port}/1";
      environment.systemPackages = [ pkg ];
      # fileSystems."/data/juicefs" = {
      #   device = cfg.meta-url;
      #   fsType = "juicefs";
      #   options = ["_netdev" "nofail" "writeback"];
      # };
      systemd.mounts = [
        {
          description = "JuiceFS";
          type = "juicefs";
          requires = [ "easytier-ltnet.service" ];
          wants = [ "network-online.target" ];
          after = [ "network-online.target" ];
          what = cfg.meta-url;
          where = "/data/juicefs";
          options = "_netdev,nofail,allow_other,writeback_cache,writeback,free-space-ratio=0.5";
          wantedBy = [
            "multi-user.target"
            "remote-fs.target"
          ];
          mountConfig = {
            Environment = [ "ALICLOUD_REGION_ID=cn-shanghai" ];
            TimeoutSec = "20s";
          };
        }
      ];
      systemd.services.juicefs-s3-gateway = lib.mkIf cfg.enableS3Gateway {
        description = "JuiceFS S3 Gateway";
        requires = [
          "network-online.target"
          "easytier-ltnet.service"
        ];
        after = [ "multi-user.target" ];
        serviceConfig = {
          Type = "simple";
          User = "root";
          ExecStart = "${pkg}/bin/juicefs gateway ${cfg.meta-url} 0.0.0.0:8260";
          Restart = "on-failure";
          EnvironmentFile = config.age.secrets.jfs-s3-env.path;
        };
        wantedBy = [ "multi-user.target" ];
      };
      systemd.services.juicefs-webdav-gateway = lib.mkIf cfg.enableWebdav {
        description = "JuiceFS Webdav Gateway";
        requires = [
          "network-online.target"
          "easytier-ltnet.service"
        ];
        after = [ "multi-user.target" ];
        serviceConfig = {
          Type = "simple";
          User = "root";
          ExecStart = "${pkg}/bin/juicefs webdav ${cfg.meta-url} 0.0.0.0:8261";
          Restart = "on-failure";
          EnvironmentFile = config.age.secrets.jfs-s3-env.path;
        };
        wantedBy = [ "multi-user.target" ];
      };
    })

    (lib.mkIf dcfg.enable {
      services.redis.servers.juicefs-meta = {
        enable = true;
        bind = et-ip;
        port = dcfg.port;
        appendOnly = true;
        slaveOf = lib.mkIf dcfg.isSlave {
          ip = master.host;
          port = master.port;
        };
        settings = {
          protected-mode = "no";
        };
      };

      systemd.services.redis-juicefs-meta = {
        after = [ "easytier-ltnet.service" ];
        serviceConfig.Restart = "on-failure";
      };
    })
  ];
}
