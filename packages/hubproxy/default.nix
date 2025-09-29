{
  lib,
  stdenv,
  fetchurl,
  unzip,
  autoPatchelfHook,
}:
let
  arch = if stdenv.hostPlatform.isAarch64 then "arm64v8" else "amd64";
in
stdenv.mkDerivation rec {
  pname = "hubproxy";
  version = "1.1.9";

  src = fetchurl {
    url = "https://github.com/sky22333/hubproxy/releases/download/v${version}/hubproxy-v${version}-linux-${arch}.tar.gz";
    sha256 =
      {
        x86_64-linux = "sha256-Ei2z6h+AHW9HFKLffmsFu09BsxxcIkopi2MH8N2ifwg=";
        aarch64-linux = "sha256-fHdL8IFiMKtOqyJaJBFfUKmtm9KzMD+vCw76QiXShAY=";
      }
      .${stdenv.hostPlatform.system} or (throw "unsupported system ${stdenv.hostPlatform.system}");
  };

  nativeBuildInputs = [
    unzip
    autoPatchelfHook
  ];
  unpackCmd = "unzip $src";
  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp ./hubproxy/hubproxy $out/bin/hubproxy

    runHook postInstall
  '';

  doInstallCheck = false;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Hubproxy";
    homepage = "https://github.com/sky22333/hubproxy";
    changelog = "https://github.com/sky22333/hubproxy/releases/tag/${version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "hubproxy";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [
      ltrump
    ];
  };
}
