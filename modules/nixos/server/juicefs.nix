{
  myvars,
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (config.networking) hostName;
  et-ip = myvars.networking.hostsAddr.easytier."${hostName}".ipv4;
  cfg = config.mymodules.server.juicefs;
  dcfg = config.mymodules.server.redis.juicefs-meta;
  pkg = pkgs.juicefs;
  master = {
    host = "chick-vm-cd.ltnet";
    port = dcfg.port;
  };
in {
  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      mymodules.server.juicefs.meta-url = lib.mkDefault "redis://${master.host}:${toString master.port}/1";
      environment.systemPackages = [pkg];
      fileSystems."/data/juicefs" = {
        device = cfg.meta-url;
        fsType = "juicefs";
        options = ["_netdev" "writeback"];
      };
      # systemd.mounts = [
      #   {
      #     description = "JuiceFS";
      #     type = "juicefs";
      #     requires = ["network.target" "easytier-ltnet.service"];
      #     after = ["multi-user.target"];
      #     what = cfg.meta-url;
      #     where = "/data/juicefs";
      #     options = "_netdev,allow_other,writeback_cache,background";
      #     wantedBy = ["remote-fs.target" "multi-user.target"];
      #   }
      # ];
      systemd.services.juicefs-s3-gateway = lib.mkIf cfg.enableS3Gateway {
        description = "JuiceFS S3 Gateway";
        requires = ["network.target" "easytier-ltnet.service"];
        after = ["multi-user.target"];
        serviceConfig = {
          Type = "simple";
          User = "root";
          ExecStart = "${pkg}/bin/juicefs gateway ${cfg.meta-url} localhost:8260";
          Restart = "on-failure";
          EnvironmentFile = config.age.secrets.jfs-s3-env.path;
        };
        wantedBy = ["multi-user.target"];
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
        after = ["easytier-ltnet.service"];
        serviceConfig.Restart = "on-failure";
      };
    })
  ];
}
