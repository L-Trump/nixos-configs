{
  appimageTools,
  lib,
  fetchurl,
  makeWrapper,
}:
let
  pname = "hokit";
  version = "1.8.9";
  src = fetchurl {
    url = "https://github.com/yabi-zzh/HoKit/releases/download/v${version}/HoKit-linux-x86_64-${version}.AppImage";
    hash = "sha256-8PWJfVNCadNuiSp6jGwRcUin5ht7TRyax9GK/pd96fo=";
  };
  # AppImage 内部 squashfs 未给 resources/assets/tools/ 下的二进制可执行位
  # （hdc、jre 全都没 +x），导致 hdc 无法启动、java 相关的 HAP 签名/重签也会失败；
  # 这里把所有 ELF 文件补回 +x。
  extracted = appimageTools.extract {
    inherit pname version src;
    postExtract = ''
      find "$out"/resources/assets/tools -type f -exec sh -c '
        head -c 4 "$1" | grep -q ELF && chmod +x "$1"
      ' _ {} \;
    '';
  };
in
appimageTools.wrapAppImage {
  inherit pname version;
  src = extracted;

  extraInstallCommands = ''
    . ${makeWrapper}/nix-support/setup-hook
    wrapProgram $out/bin/${pname} \
      --add-flags "\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}"
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "HoKit - HarmonyOS device management and screen casting tool";
    homepage = "https://github.com/yabi-zzh/HoKit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ltrump ];
    mainProgram = "hokit";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
