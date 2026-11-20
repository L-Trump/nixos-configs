{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  wrapGAppsHook3,
  alsa-lib,
  at-spi2-atk,
  cairo,
  curl,
  dbus,
  fontconfig,
  gdk-pixbuf,
  glib,
  gst_all_1,
  gtk3,
  libayatana-appindicator,
  libdrm,
  libepoxy,
  libglvnd,
  libpulseaudio,
  libva,
  libx11,
  libxcb,
  libxfixes,
  libxkbcommon,
  libxtst,
  pango,
  pipewire,
  systemdLibs,
  wayland,
  xdotool,
  zlib,
}:

# RustDesk 官方 "unattended Wayland" 构建（release asset 里的 deb），直接重打包，
# 不编译 Rust/Flutter。
#
# 它和 stock 版的差别在 cargo features：drm + drm-wake。抓屏走 kernel DRM/KMS
# （deb 自带 libdrmtap.so.0.5.12），不经过 xdg-desktop-portal，所以没有授权弹窗，
# 也能抓登录界面 —— niri 上 stock 版走 portal 还会踩 rustdesk#15916。
#
# 布局按上游原样保留：真正的二进制在 share/rustdesk/rustdesk，bin/rustdesk 只是
# wrapper。不能把二进制挪到 bin/ 或改名 —— `rustdesk --service` 靠
# `ps aux | grep "rustdesk --server"` 认自己的 per-session server，改名就认不出。
#
# librustdesk.so 里 dlopen 的路径是写死的 /usr/lib/rustdesk/libdrmtap.so.0，
# store 里没有 /usr/lib，所以需要宿主把该目录链到 $out/lib/rustdesk
# （见 README；systemd 服务那步再做）。
stdenv.mkDerivation (finalAttrs: {
  pname = "rustdesk-unattended-wayland";
  version = "1.5.3";

  src = fetchurl {
    url = "https://github.com/rustdesk/rustdesk/releases/download/${finalAttrs.version}/rustdesk-unattended-wayland-${finalAttrs.version}-x86_64.deb";
    hash = "sha256-cI85DEbDV7ciVe1qFWDaZEyDgcUd2bEIy/KjzspzPg0=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
    wrapGAppsHook3
  ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    cairo
    curl
    dbus
    fontconfig
    gdk-pixbuf
    glib
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gtk3
    libayatana-appindicator
    libdrm
    libepoxy
    libglvnd
    libpulseaudio
    libva
    libx11
    libxcb
    libxfixes
    libxkbcommon
    libxtst
    pango
    systemdLibs
    wayland
    xdotool
    zlib
  ];

  # autoPatchelf 放在 postFixup 里手动调，否则后面加的 RUNPATH 会被它重写掉
  dontAutoPatchelf = true;

  # wrapGAppsHook3 只负责收集环境变量，由 bin/rustdesk 自己套
  # （makeWrapper 直接包会动到 share/rustdesk/rustdesk）
  dontWrapGApps = true;

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb -x $src .
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r usr/share $out/share
    cp -r usr/lib $out/lib
    # 上游的 systemd unit / polkit 规则在 NixOS 上没用（也没有 /usr/bin/rustdesk）
    rm -rf $out/share/rustdesk/files $out/share/polkit-1
    substituteInPlace $out/share/applications/rustdesk.desktop $out/share/applications/rustdesk-link.desktop \
      --replace-quiet "/usr/bin/rustdesk" "rustdesk"
    runHook postInstall
  '';

  # GStreamer（portal/PipeWire 回退路径）靠它找插件；服务里也要设同一个值，
  # 因为那个 server 是直接跑 share/rustdesk/rustdesk，不经过 wrapper
  passthru.gstPluginPath = lib.makeSearchPath "lib/gstreamer-1.0" [
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    pipewire
  ];

  postFixup = ''
    autoPatchelf $out

    # librustdesk dlopen 的东西都不在 DT_NEEDED 里：自带的 libdrmtap，
    # 以及 appindicator / glvnd / va / xdotool
    patchelf --add-rpath $out/lib/rustdesk:${
      lib.makeLibraryPath [
        libayatana-appindicator
        libglvnd
        libva
        xdotool
      ]
    } $out/share/rustdesk/lib/librustdesk.so

    # libdrmtap 自己 dlopen libEGL.so.1 / libGLESv2.so.2 去 detile CPU 映不了的
    # scanout buffer（AMD），走的是它自己的 RUNPATH
    patchelf --add-rpath ${lib.makeLibraryPath [ libglvnd ]} $out/lib/rustdesk/libdrmtap.so.0.*

    mkdir -p $out/bin
    makeWrapper $out/share/rustdesk/rustdesk $out/bin/rustdesk \
      --argv0 rustdesk \
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : ${finalAttrs.passthru.gstPluginPath} \
      "''${gappsWrapperArgs[@]}"
  '';

  meta = {
    description = "RustDesk remote desktop, unattended Wayland build (DRM capture via libdrmtap)";
    homepage = "https://github.com/rustdesk/rustdesk";
    license = lib.licenses.agpl3Only;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "rustdesk";
  };
})
