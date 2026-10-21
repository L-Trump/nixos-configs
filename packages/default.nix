{
  inputs,
  pkgs ? import <nixpkgs> { },
  pkgs-unstable ? import <nixpkgs> { },
  pkgs-stable ? import <nixpkgs> { },
  ...
}:
let
  inherit (pkgs) lib libsForQt5 fetchFromGitHub;
in
{
  wpsoffice-365 = libsForQt5.callPackage ./wpsoffice-365 { };

  edrawmax = libsForQt5.callPackage ./edrawmax { };
  edrawmax-cn = libsForQt5.callPackage ./edrawmax {
    useChineseVersion = true;
  };

  lceda-pro = pkgs.callPackage ./lceda-pro { };

  rustdesk-server-pro = pkgs.callPackage ./rustdesk-server-pro { };

  hubproxy = pkgs.callPackage ./hubproxy { };

  niri = pkgs.niri.overrideAttrs (
    final: prev: {
      # TODO wait upstream merge  https://github.com/YaLTeR/niri/pull/1791
      patches = [
        (pkgs.fetchpatch {
          name = "niri-support-shm.patch";
          url = "https://github.com/wrvsrx/niri/compare/tag_support-shm-sharing_4~19..tag_support-shm-sharing_4.patch";
          hash = "sha256-mfX0CVJWSFb/Hr1lDvlggphpXc2PI6C5CBa+aGwkVIM=";
        })
      ];
    }
  );

  dbeaver-ultimate = pkgs.callPackage ./dbeaver-ultimate { };

  # TODO wait upstream merge https://github.com/NixOS/nixpkgs/pull/556768
  # 上游 7.15.1 的 rpm 已被 RealVNC 下架（只剩 8.x 的新路径），故本地跟 PR 打到 8.5.0。
  realvnc-vnc-viewer = pkgs.callPackage ./realvnc-vnc-viewer { };

  # rustdesk-flutter = pkgs-unstable.rustdesk-flutter;

  hokit = pkgs.callPackage ./hokit { };

  lossless-claw = pkgs.callPackage ./lossless-claw { };

  pi-web = pkgs.callPackage ./pi-web { };

  hdc = pkgs.callPackage ./hdc { };

  sidecar = pkgs.callPackage ./sidecar { };

  # TODO wait upstream merge https://github.com/NixOS/nixpkgs/pull/560225
  # 本地打包 nixpkgs PR 里的 wechat 4.1.13.26（vendor 自该 PR 的
  # pkgs/by-name/we/wechat/，含 sources.json + update.py），覆盖 nixpkgs 自带的
  # pkgs.wechat（tarball 版 4.1.1.8），取代旧的 wechat-uos（4.1.1.7）。
  #
  # src 的本地覆盖：PR 的 sources.json 指向 web.archive.org 快照（厂商会覆盖同名
  # .deb，上游用 Wayback 固定字节），但实测 archive.org 从国内只有 ~16KB/s，
  # 222MB 要 4 小时。改指厂商直连 URL，哈希与 PR 完全一致（已逐字节校验相同）；
  # 厂商再覆盖时需按 workbuddy 的先例重算这行哈希。
  #
  # 上游合并后删掉 packages/wechat/ 与下面这几行即可，
  # wechat 会自动回到 nixpkgs 的 pkgs.wechat。
  wechat = (pkgs.callPackage ./wechat { }).overrideAttrs (_: {
    src = pkgs.fetchurl {
      url = "https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_x86_64.deb";
      hash = "sha256-oNuMru6NHmz+CqXOWHECcPjXSpD/SSD1Oj/CKqCVb+k=";
    };
  });

  td = pkgs.callPackage ./td { };

  grok-bot-cli = pkgs.callPackage ./grok-bot-cli { };

  # TODO: 临时用官方 beta tarball 顶替 nixpkgs 的 zotero。nixpkgs 26.11 的 zotero
  # 10.0.4 会拿 firefox-esr-153 去跑 zotero 按 GECKO 140.15.0esr 写的
  # app/scripts/fetch_xulrunner，而 ESR 153 已删除 AboutTranslations /
  # PictureInPictureLauncher / PictureInPictureToggle 这几个 actor，脚本的
  # remove_between 找不到就 exit 1，导致构建必失败（Hydra 同样复现）。
  # 上游两个修复 PR（#569006 源码构建 ESR 140、#572466 预构建 ESR 140）都被
  # Firefox 维护者以「EOL 版本有已知漏洞」否决；Zotero 11 beta 原生就是 ESR 153。
  # 等 nixpkgs 收录 zotero 11 后，删掉 packages/zotero-beta/ 与下面这行即可，
  # zotero 会自动回到 nixpkgs 的 pkgs.zotero。
  # 追踪：https://github.com/NixOS/nixpkgs/issues/568692
  zotero = pkgs.callPackage ./zotero-beta { };

  # TODO: 临时修 NUR 的 workbuddy 哈希。NUR 固定的是厂商 .deb 的旧哈希，但厂商在
  # 同一个 URL 上覆盖重传了同名文件（文件名里已含版本 + build id，正常发版应该换名）。
  #   url       : https://download.codebuddy.cn/workbuddy/saas/linux-x64-deb/WorkBuddy-linux-x64-deb-5.5.6.38337834-5f969292.deb
  #   specified : sha256-LvG8ohfSnZwrqYjIIHmqbqAHfp8f+ILGq13XmYvd9yE=
  #   got       : sha256-K4aBSp8fp7YjKNrU2Z7kPWrmIGFV9VPXeyb4Gytzclw=
  # 放在这里而不是 overlays/nurs.nix，是因为 NUR 的包不在 pkgs 顶层，而在
  # pkgs.nur.repos.<user>.<pkg> 命名空间里，普通 overlay 里的 prev.workbuddy 找不到它；
  # 这里重新导出成顶层属性后，home/gui/dev-tools.nix 直接写 workbuddy 即可
  # （原来写 nur.repos.MCSeekeri.workbuddy 会绕过 overlay，导致修复不生效）。
  # 厂商再覆盖、或 NUR 自己更新后，删掉这行并把 dev-tools.nix 改回 nur.repos.… 即可。
  workbuddy = pkgs.nur.repos.MCSeekeri.workbuddy.overrideAttrs (_: {
    src = pkgs.fetchurl {
      url = "https://download.codebuddy.cn/workbuddy/saas/linux-x64-deb/WorkBuddy-linux-x64-deb-5.5.6.38337834-5f969292.deb";
      hash = "sha256-K4aBSp8fp7YjKNrU2Z7kPWrmIGFV9VPXeyb4Gytzclw=";
    };
  });

  # intel-graphics-compiler =  pkgs-unstable.intel-graphics-compiler;
  # linuxPackages_latest = pkgs.linuxPackages_latest.extend (_: prev: {
  #   # ipu6-drivers = pkgs.linuxPackages_latest.callPackage ./ipu6-drivers {};
  #   ipu6-drivers = prev.ipu6-drivers.overrideAttrs (_: _: {
  #     src = fetchFromGitHub {
  #       owner = "intel";
  #       repo = "ipu6-drivers";
  #       rev = "69b2fde9edcbc24128b91541fdf2791fbd4bf7a4";
  #       hash = "sha256-uiRbbSw7tQ3Fn297D1I7i7hyaNtpOWER4lvPMSTpwpk=";
  #     };
  #   });
  # });
}
