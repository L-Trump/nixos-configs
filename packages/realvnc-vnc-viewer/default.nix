# RealVNC Connect Viewer（本地打包）
#
# 为什么本地打：nixpkgs 各分支固定的 7.15.1 已经无法下载 —— RealVNC 从 8.x 起把
# Linux 安装包从
#   https://downloads.realvnc.com/download/file/viewer.files/VNC-Viewer-<v>-Linux-x64.rpm
# 改成
#   https://downloads.realvnc.com/download/file/realvnc-connect-viewer/RealVNC-Connect-Viewer-<v>-Linux-x64.rpm
# 并且把旧版本文件从服务器删掉了（旧 URL 现在一律 404，故 7.15.1 构建必然失败）。
#
# 内容照搬上游待合并 PR https://github.com/NixOS/nixpkgs/pull/556768 的 Linux 部分：
#   - 7.15.1 -> 8.5.0：新下载路径 + 新 hash；
#   - 8.x 二进制内部硬编码 /usr/bin/xdg-mime，改用 buildFHSEnv 包装，
#     否则打开浏览器 / 登录账号时会崩溃；
#   - desktop / icon 文件名变化，安装时做对应的路径替换。
# 上游合并（并把 nixpkgs 升过去）之后，本目录与 packages/default.nix 里的注册项可一并删除。
{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  rpmextract,
  buildFHSEnv,
  libx11,
  libxext,
  libepoxy,
  fontconfig,
  glib,
  gtk3,
  xdg-utils,
  shared-mime-info,
  desktop-file-utils,
}:

let
  pname = "realvnc-vnc-viewer";
  version = "8.5.0";

  meta = {
    description = "VNC remote desktop client software by RealVNC";
    homepage = "https://www.realvnc.com/en/connect/download/viewer/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = {
      fullName = "VNC Connect End User License Agreement";
      url = "https://static.realvnc.com/media/documents/LICENSE-4.0a_en.pdf";
      free = false;
    };
    maintainers = with lib.maintainers; [
      emilytrau
      onedragon
    ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "realvnc-vnc-viewer";
  };

  vncviewer-unwrapped = stdenv.mkDerivation (finalAttrs: {
    inherit pname version;

    src = fetchurl rec {
      name = "RealVNC-Connect-Viewer-${finalAttrs.version}-Linux-x64.rpm";
      url = "https://downloads.realvnc.com/download/file/realvnc-connect-viewer/${name}";
      hash = "sha256-x/NG9ivYUbtrFxksglCLF+lGA2OO2VdEN1qPsvum7tQ=";
    };

    nativeBuildInputs = [
      autoPatchelfHook
      rpmextract
    ];

    buildInputs = [
      libx11
      libxext
      libepoxy
      fontconfig
      glib
      gtk3
      stdenv.cc.cc.libgcc or null
    ];

    unpackPhase = ''
      rpmextract $src
    '';

    installPhase = ''
      runHook preInstall

      mv usr $out
      find $out -xtype l -delete

      runHook postInstall
    '';
  });
in
buildFHSEnv {
  inherit pname version meta;

  runScript = "${vncviewer-unwrapped}/lib/rvncconnect/rvncconnect";

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    mkdir -p $out/share/icons
    cp -r ${vncviewer-unwrapped}/share/applications/. $out/share/applications/
    cp -r ${vncviewer-unwrapped}/share/icons/. $out/share/icons/

    substituteInPlace $out/share/applications/com.realvnc.rvncconnect.desktop \
      --replace-fail /usr/lib/rvncconnect/rvncconnect $out/bin/realvnc-vnc-viewer \
      --replace-fail /usr/share/icons/hicolor/scalable/apps/com.realvnc.rvncconnect.svg $out/share/icons/hicolor/scalable/apps/com.realvnc.rvncconnect.svg
    substituteInPlace $out/share/applications/com.realvnc.rvncconnect.connect.uri.desktop \
      --replace-fail /usr/lib/rvncconnect/rvncconnect $out/bin/realvnc-vnc-viewer
  '';

  targetPkgs = _pkgs: [
    vncviewer-unwrapped
    xdg-utils
    shared-mime-info
    desktop-file-utils
  ];
}
