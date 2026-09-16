{
  lib,
  stdenv,
  fetchurl,
  unzip,
  autoPatchelfHook,
  gcc,
}:

stdenv.mkDerivation rec {
  pname = "hdc";
  version = "7.0.0";

  src = fetchurl {
    url = "https://repo.huaweicloud.com/openharmony/os/7.0-Release/ohos-sdk-windows_linux-public_20260829.tar.gz";
    sha256 = "sha256-a/auHv6N4Oi9Fd29f6xYvLVNliAmKlQbmyGUOTF6TEI=";
  };

  nativeBuildInputs = [
    unzip
    autoPatchelfHook
  ];
  buildInputs = [ gcc.cc.lib ];

  unpackPhase = ''
    tar -xzf "$src" --wildcards 'ohos-sdk/linux/toolchains-linux-x64-*.zip'
  '';

  installPhase = ''
    runHook preInstall

    unzip ohos-sdk/linux/toolchains-linux-x64-*.zip

    mkdir -p "$out/lib"
    mkdir -p "$out/bin"

    cp toolchains/hdc "$out/bin/hdc"
    cp toolchains/libusb_shared.so "$out/lib/libusb_shared.so"
    chmod +x "$out/bin/hdc"

    runHook postInstall
  '';

  # autoPatchelfHook 自动找出 gcc 的缺失库并追加到 RPATH
  # 手动再追加 $ORIGIN/../lib 让 hdc 能找到同目录下的 libusb_shared.so
  postFixup = "patchelf --set-rpath \"\\$ORIGIN/../lib:${lib.makeLibraryPath buildInputs}\" \"$out/bin/hdc\"";

  meta = with lib; {
    description = "HDC (HarmonyOS Device Connector) - CLI tool for interacting with HarmonyOS/OpenHarmony devices";
    homepage = "https://gitee.com/openharmony/developtools_hdc";
    license = licenses.mulan-psl2;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
