{
  myvars,
  config,
  lib,
  myhome,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.myhome.tuiExtra.openclaw;
  openclawPlugins = import ./plugins.nix;
in
{
  # 引入 nix-openclaw 的 Home Manager 模块，提供 programs.openclaw 选项。
  imports = [
    inputs.nix-openclaw.homeManagerModules.openclaw
  ];

  # 仅在用户配置启用 OpenClaw 时渲染下方配置。
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      uv
      bubblewrap
      codex
      mcporter
    ];

    # nix-openclaw 的用户级 OpenClaw 配置入口。
    programs.openclaw = {
      enable = true;
      package = pkgs.openclawPackages.openclaw;

      # 需要由 nix-openclaw 额外链接/启用的 runtime plugin。
      runtimePlugins = openclawPlugins.runtimePlugins;

      # Dashboard / WebChat 头像等静态资源，激活时 materialize 到 workspace。
      workspace.files = {
        "avatars/ltclaw.jpg" = ./assets/ltclaw-avatar.jpg;
      };

      # 渲染到 ~/.openclaw/openclaw.json 的主配置。
      config = lib.mkMerge [
        # 核心行为：日志、浏览器 SSRF 策略等。
        (import ./core.nix)
        # SecretRef provider：把 agenix runtime JSON 暴露给 OpenClaw。
        (import ./secrets.nix { inherit config; })
        # 模型 provider、模型列表、费用和上下文窗口。
        (import ./models.nix { inherit myvars; })
        # agent 默认模型、workspace、compaction、并发和心跳。
        (import ./agents.nix { inherit config myvars; })
        # Dashboard / WebChat 专用展示身份。
        (import ./ui.nix)
        # 工具、消息、会话和命令权限。
        (import ./tools.nix { inherit myvars; })
        # Telegram / Feishu 渠道配置。
        (import ./channels.nix { inherit myvars; })
        # Gateway 网络、认证、节点权限和热重载配置。
        (import ./gateway.nix { inherit myvars; })
        # Skill 发现和启用配置。
        (import ./skills.nix { inherit config; })
        # 插件 allow/entries/contextEngine 和插件私有配置。
        openclawPlugins.config
      ];
    };
  };
}
