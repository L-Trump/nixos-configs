{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.myhome.tuiExtra.pi.pi-web;
  homeDir = config.home.homeDirectory;

  # ==================== 要改配置就改这一段 ====================

  # 端口
  port = 30141;

  # 监听地址，三选一：
  #   "easytier.ltnet" 只在 SDWAN 内网可达（默认，最安全）
  #   "127.0.0.1"       只有本机能连，免密码就够
  #   "0.0.0.0"         所有网卡，必须同时配 passwordEnvFile（密码）
  listenHost = "0.0.0.0";

  # 密码与 Host 白名单都放在**加密的** env 文件里（nixos-secrets 的
  # pi-web/pi-web.env.age，由 secrets/home/pi-web.nix 声明），所以域名不会进
  # 公开仓库。要改就在那个密文里改：
  #   PI_WEB_PASSWORD=...
  #   PI_WEB_ALLOWED_HOSTS=域名1,域名2
  # null = 免密且不做 Host 限制（只适合 127.0.0.1 / 纯内网）。
  #
  # 上游对 Host 头是**精确匹配**（lib/request-security.ts：isIP() 与 *.localhost
  # 无条件放行，其余要比对 PI_WEB_HOSTNAME + PI_WEB_ALLOWED_HOSTS），没有通配符，
  # 写 "*" 不会当成通配。所以名单得在密文里列全。
  passwordEnvFile = config.age.secrets.pi-web-env.path;

  # 空闲多少毫秒后自动退出，0 = 不退出。上游默认 600000（10 分钟），而
  # Restart=on-failure 不会拉起正常退出的进程，服务会"跑十分钟就没了"。
  idleTimeoutMs = 0;

  # ===========================================================

  # pkg 来自 packages/pi-web（overlay 注入），内含 npm 发布版自带的预构建
  # .next，所以既不用在沙箱里跑 next build，也不用联网下 SWC。
  piWeb = "${pkgs.pi-web}/bin/pi-web";

  piWebArgs = [
    piWeb
    "--port"
    (toString port)
    "--hostname"
    listenHost
    "--no-open"
  ];
in
{
  config = lib.mkIf cfg.enable {
    # 以普通用户身份跑：pi-web 要读 ~/.pi/agent 下的 session 与凭据。
    # 用的是 HM 的 systemd user unit，rog-ga502 的 impermanence 不用额外
    # 登记白名单——home-manager-ltrump.service 每次开机（multi-user.target）
    # 都会重新生成 ~/.config/systemd/user/pi-web.service 和它的 wants 软链。
    # 注意：首次 switch 后 HM 只会"建议"你 systemctl --user start pi-web，
    # 真正自动拉起要等下次登录（default.target）。
    systemd.user.services.pi-web = {
      Unit = {
        Description = "pi-web (web UI for the pi coding agent)";
        # user manager 里没有 network-online.target，只有 network.target
        After = [ "network.target" ];
      };
      Service = {
        Type = "exec";
        Environment = [
          "HOME=${homeDir}"
          # 浏览器里的终端 spawn 的是 $SHELL（回退 /bin/sh，NixOS 上不存在），
          # 不显式给就会开不了终端；取 modules/nixos/base/user-group.nix 的设置
          "SHELL=${pkgs.fish}/bin/fish"
          "PATH=/run/wrappers/bin:/run/current-system/sw/bin:/etc/profiles/per-user/${config.home.username}/bin:${homeDir}/.local/bin"
          # 默认就是 ~/.pi/agent，写出来是为了不依赖继承到的 HOME
          "PI_CODING_AGENT_DIR=${homeDir}/.pi/agent"
          # systemd 场景下不能让它弹浏览器
          "PI_WEB_NO_OPEN=1"
          # 版本由 Nix 钉死，不必再联网查更新
          "PI_WEB_SKIP_VERSION_CHECK=1"
          "NEXT_TELEMETRY_DISABLED=1"
          "PI_WEB_IDLE_TIMEOUT_MS=${toString idleTimeoutMs}"
        ];
        ExecStart = lib.escapeShellArgs piWebArgs;
        WorkingDirectory = homeDir;
        Restart = "on-failure";
        RestartSec = "3s";
        # null = 免密（只适合 127.0.0.1 / 纯内网）；非 null 时用 agenix 的密文。
        EnvironmentFile = lib.mkIf (passwordEnvFile != null) passwordEnvFile;
      };
    };
  };
}
