{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mymodules.server.rhcg-site;
  inherit (lib) mkIf;
  siteRoot = "/data/www/rhcg";
  user = "rhcg";
  # Token:自生成、放在 state/token；若私密仓库声明了 age.secrets.rhcg-publish-token
  # 则改用它（想要"不由服务自己生 secre"的时候用）。
  tokenPath =
    if builtins.hasAttr "rhcg-publish-token" config.age.secrets then
      config.age.secrets.rhcg-publish-token.path
    else
      "${siteRoot}/state/token";
  docsFile = ./AI-GUIDE.md;
in
{
  config = mkIf cfg.enable {
    users.groups.${user} = { };
    users.users.${user} = {
      isSystemUser = true;
      group = user;
      home = siteRoot;
      createHome = false;
      description = "static site publisher";
    };

    systemd.tmpfiles.rules = [
      "d ${siteRoot} 0755 ${user} ${user} -"
      "d ${siteRoot}/releases 0755 ${user} ${user} -"
      "d ${siteRoot}/state 0750 ${user} ${user} -"
    ];

    systemd.services.rhcg-site-publish = {
      description = "HTTP publisher for the static site";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        Type = "simple";
        User = user;
        Group = user;
        # ProtectSystem=strict + ReadWritePaths 会把不存在的目录以 root 身份建出来，
        # 子进程（rhcg）就写不进去，所以先用 `+` 以 root 身份把属主摆正（tmpfiles 的
        # 执行时机靠不住）。
        ExecStartPre = [
          "+${pkgs.coreutils}/bin/install -d -o ${user} -g ${user} -m 0755 ${siteRoot}"
          "+${pkgs.coreutils}/bin/install -d -o ${user} -g ${user} -m 0755 ${siteRoot}/releases"
          "+${pkgs.coreutils}/bin/install -d -o ${user} -g ${user} -m 0750 ${siteRoot}/state"
        ];
        ExecStart = "${pkgs.python3}/bin/python3 ${./publish.py}";
        Environment = [
          "RH_SITE_ROOT=${siteRoot}"
          "RH_TOKEN_FILE=${tokenPath}"
          "RH_BIND=127.0.0.1"
          "RH_PORT=${toString cfg.port}"
          "RH_DOCS_FILE=${docsFile}"
        ];
        Restart = "always";
        RestartSec = 2;

        # The whole service is one HTTP endpoint writing into one directory.
        NoNewPrivileges = true;
        CapabilityBoundingSet = "";
        AmbientCapabilities = "";
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        ProtectProc = "invisible";
        ReadWritePaths = [ siteRoot ];
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictSUIDSGID = true;
        RestrictRealtime = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "@system-service" ];
        UMask = "0022";
        LimitNOFILE = 512;
        MemoryMax = "512M";
      };
    };

    # 域名不在这个仓库里：服务自己不知道也不关心对外地址，/docs 与响应里的 URL
    # 都按请求的 Host 头现算。反向代理（私密仓库的 caddyfile）只需要这么一段：
    #
    #   <public-host> {
    #       encode gzip
    #       handle_path /__publish/* {
    #           request_body { max_size 200MB }
    #           reverse_proxy 127.0.0.1:<port>
    #       }
    #       handle {
    #           root * /data/www/rhcg/current
    #           file_server
    #       }
    #   }
    #
    # Serve-check helper for the operator, not for the uploader.
    environment.systemPackages = [
      (pkgs.writeShellScriptBin "rhcg-site" ''
        set -eu
        root=${siteRoot}
        echo "== listening"
        ${pkgs.curl}/bin/curl -fsS "http://127.0.0.1:${toString cfg.port}/healthz" || echo "(publisher not responding)"
        echo
        echo "== token"
        cat "$root/state/token" 2>/dev/null || echo "(no token yet; restart rhcg-site-publish)"
        echo "== releases"
        ls -1t "$root/releases" 2>/dev/null | head -10
        echo "== current"
        readlink "$root/current" || echo "(nothing published)"
        echo "== size"
        du -sh "$root/releases" 2>/dev/null || true
      '')
    ];
  };
}
