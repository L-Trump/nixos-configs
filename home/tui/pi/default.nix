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
  cfg = config.myhome.tuiExtra.pi;
in
{
  imports = [
    ./pi-web.nix
    ./computer-use.nix
  ];

  # 仅在用户配置启用 Pi agent 时渲染下方配置。
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      pi-coding-agent
      grok-bot-cli
      yt-dlp
      pandoc
      mermaid-cli
      (pkgs.texliveSmall.withPackages (
        ps: with ps; [
          multirow
          soul
          lua-ul # pandoc 硬依赖
          framed
          fvextra
          titlesec
          enumitem
          varwidth # pmp 可选样式
          xurl
          csquotes
          xecjk
          fandol # CJK（fandol 纯属兜底）
        ]
      ))
    ];

    # pi-markdown-preview 的 Chromium 探测在 Linux 上只查
    # /usr/bin/{google-chrome,google-chrome-stable,chromium,chromium-browser}
    # 和 /snap/bin/chromium，且不做 PATH 查找；NixOS 上这些路径一律不存在。
    # 更糟的是它还把 $BROWSER 当作候选可执行文件（本机为 firefox），
    # 一旦 cwd 下恰好有同名文件就会误判。故显式指定，优先级最高。
    home.sessionVariables.PUPPETEER_EXECUTABLE_PATH = "/etc/profiles/per-user/ltrump/bin/google-chrome";
  };
}
