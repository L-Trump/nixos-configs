# 嘉立创EDA专业版（LCEDA Pro）桌面客户端 —— 本地打包
#
# 为什么本地打：nixpkgs 里没有（只有 easyeda2kicad 这种转换工具、以及 kicad/horizon-eda
# 等别的 EDA）；NUR 里的 4 个都不好用：
#   repos.Emin017.lceda-pro   2.2.27.1（很旧）
#   repos.j4ger.lceda-pro     2.2.40.8（旧，且用 nixpkgs electron 去 wrap 厂商 app 目录）
#   repos.srcres258.lceda-pro 3.2.166（上游同名 zip 被厂商重传过，实测构建直接
#                             hash mismatch：specified sha256-J4UBri3yZQ8…/got sha256-gMsRMNz9op…）
# 本仓库又已带 inputs.nur，本可以直接写 pkgs.nur.repos.<user>.lceda-pro，但版本落后
# 一个大版本，故在此按上游最新版自己打。
#
# 上游 zip（https://image.lceda.cn/files/lceda-pro-linux-x64-<ver>.zip）自带完整
# Electron 运行时（Electron 36.3.1，见 zip 内 version 文件）+ resources/app；厂商的
# install.sh / lceda-pro.dkt 就是拷到 /opt/apps 后跑
#   lceda-pro %f --no-sandbox --gtk-version=3
# NixOS 下动态链接器和库路径都不对，故照 nixpkgs
# pkgs/development/tools/electron/binary/generic.nix 的官方做法处理：
#   - patchelf 设 interpreter + rpath（库列表与 electron_*-bin 的 electronLibPath 一致）；
#   - 用 nix 的 vulkan-loader 替换 zip 自带的 libvulkan.so.1；
#   - Electron < 44 还要给 ANGLE（libEGL/libGLESv2）单独设 rpath。
#
# 升级版本（厂商会不断发新版 zip，旧版文件保留、可继续下载）：
#   1. 试探下一个版本还在不在（403 = 不存在；实测 4.1.80 是当前最新，4.1.81 起 403）：
#      curl -sL -r0-3 -o /dev/null -w '%{http_code}\n' \
#        https://image.lceda.cn/files/lceda-pro-linux-x64-<ver>.zip
#   2. 取 hash：
#      nix store prefetch-file --json --hash-type sha256 \
#        --name lceda-pro-linux-x64-<ver>.zip <该 URL>
#   3. 改下面 version / hash 两行。
# 注意：厂商有重传同名 zip 的先例（NUR 的 srcres258 包就是这么坏的；本仓库 workbuddy
# 也是同类问题），届时按新 hash 更新这一行即可。
#
# 已知行为（上游 app.js 静态分析 + 本地实测）：
#   - 数据目录：工程/库/激活文件在 ~/Documents/LCEDA-Pro/；userData、缓存、updater 在
#     ~/.config/LCEDA-Pro/（impermanence 机器需要把后者登记进落盘白名单）。
#   - Linux 版"自动更新"只是把新 zip 下载到 ~/.config/LCEDA-Pro/updater/ 然后在文件
#     管理器里打开让用户手动装，不会改写安装目录，所以放进 /nix/store 是安全的；
#     升级 = 改版本号重新 build。
#   - zip 里有一个中文名 EULA PDF，其 local/central 文件名编码不一致，std 自带的
#     unpackPhase 会直接放弃，故 dontUnpack + 在 installPhase 里自己 unzip。
{
  lib,
  stdenv,
  fetchurl,
  unzip,
  makeWrapper,
  wrapGAppsHook3,
  copyDesktopItems,
  makeDesktopItem,
  alsa-lib,
  at-spi2-atk,
  cairo,
  cups,
  dbus,
  expat,
  gdk-pixbuf,
  glib,
  gtk3,
  gtk4,
  nss,
  nspr,
  libx11,
  libxcb,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxrandr,
  libxkbfile,
  pango,
  pciutils,
  systemd,
  libnotify,
  pipewire,
  libsecret,
  libpulseaudio,
  speechd-minimal,
  libdrm,
  libgbm,
  libxkbcommon,
  libxshmfence,
  libGL,
  vulkan-loader,
  xdg-utils,
}:

let
  version = "4.1.80";

  # 与 nixpkgs electron_*-bin 的 electronLibPath 保持一致
  electronLibPath = lib.makeLibraryPath [
    alsa-lib
    at-spi2-atk
    cairo
    cups
    dbus
    expat
    gdk-pixbuf
    glib
    gtk3
    gtk4
    nss
    nspr
    libx11
    libxcb
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
    libxkbfile
    pango
    pciutils
    stdenv.cc.cc
    systemd
    libnotify
    pipewire
    libsecret
    libpulseaudio
    speechd-minimal
    libdrm
    libgbm
    libxkbcommon
    libxshmfence
    libGL
    vulkan-loader
  ];

  iconSizes = [
    "16"
    "24"
    "32"
    "48"
    "64"
    "96"
    "128"
    "256"
    "512"
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "lceda-pro";
  inherit version;

  src = fetchurl {
    url = "https://image.lceda.cn/files/lceda-pro-linux-x64-${finalAttrs.version}.zip";
    hash = "sha256-m8X8MRTQZKnsGvVcdu5x1s8Zn8m2R7kto5nmPfMUJP4=";
  };

  nativeBuildInputs = [
    unzip
    makeWrapper
    wrapGAppsHook3
    copyDesktopItems
  ];

  buildInputs = [
    glib
    gtk3
    gtk4
  ];

  dontConfigure = true;
  dontBuild = true;
  # zip 里有中文文件名（EULA PDF）且 local/central 文件名编码不一致，std 的
  # unpackPhase 会报 "do not know how to unpack source archive" 直接失败
  dontUnpack = true;
  # 只手动 wrap bin/lceda-pro，不让 hook 去扫 libexec
  dontWrapGApps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/libexec
    # unzip 对那个中文名 PDF 会报 mismatching local filename 并返回 1，其余文件正常，
    # 故容忍返回值，后面断言主二进制确实解出来了。
    unzip -q -d $out/libexec $src || true
    test -x $out/libexec/lceda-pro/lceda-pro
    chmod u-x $out/libexec/lceda-pro/*.so*

    for size in ${lib.concatStringsSep " " iconSizes}; do
      install -Dm444 \
        $out/libexec/lceda-pro/icon/icon_''${size}x''${size}.png \
        $out/share/icons/hicolor/''${size}x''${size}/apps/lceda-pro.png
    done

    runHook postInstall
  '';

  preFixup = ''
    makeWrapper "$out/libexec/lceda-pro/lceda-pro" $out/bin/lceda-pro \
      "''${gappsWrapperArgs[@]}" \
      --add-flags "--no-sandbox --gtk-version=3 --ozone-platform-hint=auto --enable-wayland-ime" \
      --prefix PATH : "${lib.makeBinPath [ xdg-utils ]}"
  '';

  postFixup = ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${electronLibPath}:$out/libexec/lceda-pro" \
      $out/libexec/lceda-pro/lceda-pro \
      $out/libexec/lceda-pro/chrome_crashpad_handler

    # 用 nix 的 vulkan-loader 替换 zip 自带的
    rm -f "$out/libexec/lceda-pro/libvulkan.so.1"
    ln -s -t "$out/libexec/lceda-pro" "${lib.getLib vulkan-loader}/lib/libvulkan.so.1"

    # Electron < 44：ANGLE 库单独设 rpath
    patchelf \
      --set-rpath "${
        lib.makeLibraryPath [
          libGL
          pciutils
          vulkan-loader
        ]
      }" \
      $out/libexec/lceda-pro/lib*GL*
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "lceda-pro";
      desktopName = "嘉立创EDA(专业版)";
      exec = "lceda-pro %f";
      icon = "lceda-pro";
      categories = [
        "Development"
        "Electronics"
      ];
      mimeTypes = [
        "application/eprj"
        "application/eprj2"
        "application/eprj3"
        "application/epro"
        "application/epro2"
      ];
      extraConfig = {
        "Name[en_US]" = "LCEDA Pro";
        "Comment" = "免费、专业、强大的国产 PCB 设计工具";
        "Keywords" = "PCB;EDA;LCEDA;嘉立创EDA;";
        "StartupWMClass" = "JLCEDA Pro";
      };
    })
  ];

  meta = {
    description = "A browser-based, user-friendly, powerful Electronics Design Automation tool";
    homepage = "https://pro.lceda.cn/";
    sourceProvenance = with lib.sourceTypes; [
      binaryNativeCode
      binaryBytecode
      binaryData
    ];
    license = {
      fullName = "嘉立创EDA软件安装最终用户许可协议（EULA）";
      url = "https://lceda.cn/page/legal";
      free = false;
    };
    platforms = [ "x86_64-linux" ];
    mainProgram = "lceda-pro";
  };
})
