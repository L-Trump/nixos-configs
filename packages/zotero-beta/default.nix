# Zotero 的官方预编译 beta 包（绕过 nixpkgs 的 zotero 打包）。
#
# 为什么不用 nixpkgs 的 zotero：
#   nixpkgs 26.11 的 zotero 10.0.4 在构建时会用 nixpkgs 注入的
#   firefox-esr-153 去跑 zotero 自己的 app/scripts/fetch_xulrunner，而该脚本
#   是按 GECKO 140.15.0esr 写的，会 remove_between 地删ActorManagerParent.sys.mjs
#   里的若干 actor。ESR 153 里 AboutTranslations / PictureInPictureLauncher /
#   PictureInPictureToggle 已经被上游删掉，脚本找不到就 exit 1，整个包构建失败。
#
#   上游两个修复 PR（#569006 源码构建 ESR 140、#572466 预构建 ESR 140）都被
#   Firefox 维护者以「EOL 版本有已知漏洞」否决；而 beta（Zotero 11）本身就用
#   ESR 153 构建（platform.ini: Milestone=153.3.0 / mozilla-esr153），跟 nixpkgs
#   的 pin 完全一致，不存在版本错配。
#   追踪：https://github.com/NixOS/nixpkgs/issues/568692
#
# 本包直接用官方 beta tarball：自带 Firefox 153 runtime，不需要任何
# firefox-esr-* 输入，纯解包 + 修 wrapper，几乎零维护成本。
# 代价：beta 通道每次发版要手动改一次 version + hash（URL 里的 + 号要转义成 %2B）。
#
# nixpkgs 收录 zotero 11 后，删掉本目录并把 packages/default.nix 里指向它的
# 那一行删掉即可，zotero 会自动回到 nixpkgs 的 pkgs.zotero。
{
  lib,
  stdenvNoCC,
  stdenv,
  fetchurl,
  makeWrapper,
  patchelf,

  # GTK / gsettings / 图标
  gsettings-desktop-schemas,
  adwaita-icon-theme,
  hicolor-icon-theme,

  # libxul.so 的外部 NEEDED：alsa / atk / cairo / dbus / fontconfig / freetype /
  # glib / gtk3 / pango / X11 / xcb 等。nspr、nss 由 tarball 自带的
  # libnspr4.so、libnss3.so 提供，不需要引 nss/nspr。
  alsa-lib,
  at-spi2-atk,
  cairo,
  dbus,
  fontconfig,
  freetype,
  glib,
  gtk3,
  libGL,
  libx11,
  libxcb,
  libxcomposite,
  libxcursor,
  libxdamage,
  libxext,
  libxfixes,
  libxi,
  libxkbcommon,
  libxrandr,
  libxrender,
  pango,
  udev,
  wayland,
}:

let
  # GTK 需要图标与 gsettings schema 的搜索路径（原来由 wrapGAppsHook3 提供，
  # 但它会连 libexec 里的 .so 一起 wrap，见 installPhase 注释）
  gtkDataDirs = lib.makeSearchPathOutput "out" "share" [
    adwaita-icon-theme
    gsettings-desktop-schemas
    hicolor-icon-theme
  ];

  runtimeLibs =
    lib.makeLibraryPath [
      alsa-lib
      at-spi2-atk
      cairo
      dbus
      fontconfig
      freetype
      glib
      gtk3
      libGL
      libxcb
      libxkbcommon
      libxrandr
      libxrender
      pango
      udev
      wayland
      libx11
      libxcomposite
      libxcursor
      libxdamage
      libxext
      libxfixes
      libxi
    ]
    # zotero-bin 需要 libstdc++.so.6 / libgcc_s.so.1，官方包不带，得从 nix 侧补
    + ":${stdenv.cc.cc.lib}/lib";
in

stdenvNoCC.mkDerivation {
  pname = "zotero-beta";
  version = "11.0-beta.1+b551fb670";

  src = fetchurl {
    url = "https://download.zotero.org/client/beta/11.0-beta.1%2Bb551fb670/Zotero-11.0-beta.1%2Bb551fb670_linux-x86_64.tar.xz";
    hash = "sha256-SzXFeatMAcJPprozQt3LS2oR5loP4Vb8mBmOMavHPOw=";
  };

  nativeBuildInputs = [
    makeWrapper
    patchelf

    gsettings-desktop-schemas
    adwaita-icon-theme
    hicolor-icon-theme

    alsa-lib
    at-spi2-atk
    cairo
    dbus
    fontconfig
    freetype
    glib
    gtk3
    libGL
    libx11
    libxcb
    libxcomposite
    libxcursor
    libxdamage
    libxext
    libxfixes
    libxi
    libxkbcommon
    libxrandr
    libxrender
    pango
    udev
    wayland
  ];

  # 官方预编译二进制，strip 容易出问题（libxul 等）
  dontStrip = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    # unpackPhase 已自动把 sourceRoot 识别为 Zotero_linux-x86_64，当前目录即它
    mkdir -p $out/libexec/zotero
    cp -r ./. $out/libexec/zotero/
    chmod -R u+w $out

    # 官方二进制的 PT_INTERP 是 /lib64/ld-linux-x86-64.so.2，NixOS 上不存在，
    # 必须指向 nix 的动态链接器，否则 exec 直接 ENOENT。
    # 只改真正会被 exec 的几个：共享库没有 .interp 段，patchelf 会报错，无需处理。
    # （这个循环原本放在 postPhase，但那样 bash 会在 hook 里崩掉。）
    for f in zotero-bin updater glxtest vaapitest vulkantest; do
      patchelf --set-interpreter ${stdenv.cc.libc}/lib/ld-linux-x86-64.so.2 \
        "$out/libexec/zotero/$f" \
        || echo "warning: patchelf failed on $f" >&2
    done

    # 官方 desktop 文件的 Exec 用 %k 自解析安装目录，Nix 下不可靠，直接重写
    mkdir -p $out/share/applications
    cat > $out/share/applications/zotero.desktop <<'EOF'
    [Desktop Entry]
    Name=Zotero
    GenericName=Bibliography Manager
    Exec=zotero %U
    Icon=zotero
    Type=Application
    Terminal=false
    Categories=Office;Education;Science;
    MimeType=text/plain;x-scheme-handler/zotero;application/x-research-info-systems;text/x-research-info-systems;text/ris;application/x-endnote-refer;application/x-st-for-Scientific-info;application/mods+xml;application/rdf+xml;application/x-bibtex;text/x-bibtex;text/x-marc;application/vnd.citationstyles.style+xml;
    X-GNOME-SingleWindow=true
    EOF

    for size in 32 64 128; do
      install -Dm444 $out/libexec/zotero/icons/icon$size.png \
        $out/share/icons/hicolor/''${size}x''${size}/apps/zotero.png
    done
    install -Dm444 $out/libexec/zotero/icons/symbolic.svg \
      $out/share/icons/hicolor/scalable/apps/zotero-symbolic.svg

    # libexec 自身必须在最前面：官方二进制无 RPATH，tarball 自带的 nss/sqlite 等
    # 只能靠这个路径找到；后面才是 nix 侧的 X11/GTK/alsa 等。
    #
    # 不用 autoPatchelfHook：它会给每个 ELF 注入 rpath，实测会让 zotero-bin 在
    # 启动时段错误（同一批库，只用 LD_LIBRARY_PATH 就能正常 `zotero --version`）。
    #
    # 这里不用 wrapGAppsHook3：它会把 $out 下所有 ELF（含 libexec/zotero/*.so）
    # 换成 bash wrapper，导致 XPCOM dlopen libnspr4.so 时报 invalid ELF header。
    # 它本来要做的事（图标 / gsettings schema 搜索路径）在这里显式设置。
    makeWrapper $out/libexec/zotero/zotero $out/bin/zotero \
      --prefix LD_LIBRARY_PATH : $out/libexec/zotero:${runtimeLibs} \
      --prefix XDG_DATA_DIRS : $out/share:${gtkDataDirs} \
      --set GSETTINGS_SCHEMA_DIR ${gsettings-desktop-schemas}/share/glib-2.0/schemas

    runHook postInstall
  '';

  meta = {
    description = "Zotero bibliography manager (official beta build)";
    homepage = "https://www.zotero.org/";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "zotero";
  };
}
