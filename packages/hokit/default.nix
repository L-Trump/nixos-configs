{
  appimageTools,
  lib,
  fetchurl,
}:
let
  pname = "hokit";
  version = "1.2.9";
  src = fetchurl {
    url = "https://github.com/yabi-zzh/HoKit/releases/download/v${version}/HoKit-linux-x86_64-${version}.AppImage";
    hash = "sha256-Tw50kwxnBNMd5NPQZgR2cMCWeKk251Uh44I+F+Gwi8Q=";
  };
  # AppImage 解压后内部二进制可能丢失执行权限，需手动修复
  extracted = appimageTools.extract {
    inherit pname version src;
    postExtract = ''
      chmod +x "$out"/resources/assets/tools/hdc/hdc
    '';
  };
in
appimageTools.wrapAppImage {
  inherit pname version;
  src = extracted;

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
