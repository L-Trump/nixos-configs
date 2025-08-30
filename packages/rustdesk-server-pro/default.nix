{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:
let
  arch = if stdenv.hostPlatform.isAarch64 then "arm64v8" else "amd64";
in
stdenv.mkDerivation rec {
  pname = "rustdesk-server-pro";
  version = "0.0.9-f3";

  src = fetchurl {
    url = "https://github.com/lejianwen/rustdesk-server/releases/download/v${version}/rustdesk-server-linux-${arch}.zip";
    sha256 = {
      x86_64-linux = "sha256-EnMzM0iL41C/yLRfAOGPrAWivR0EJmv7RA+A7HG7CR4=";
      aarch64-linux = "sha256-9MiUOgptRjo4tXyoz4sqFlE5J3IjKA/EW41xt0SRcYA=";
    }.${stdenv.hostPlatform.system} or (throw "unsupported system ${stdenv.hostPlatform.system}");
  };

  nativeBuildInputs = [ unzip ];
  unpackCmd = "unzip $src";
  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp ./${arch}/hbbr $out/bin/hbbr
    cp ./${arch}/hbbs $out/bin/hbbs
    cp ./${arch}/rustdesk-utils $out/bin/rustdesk-utils

    runHook postInstall
  '';

  # nativeInstallCheckPhaseInputs = [ versionCheckHook ];
  # versionCheckProgramArg = [ "--version" ];
  doInstallCheck = false;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "RustDeskPro Server Program";
    homepage = "https://github.com/lejianwen/rustdesk-server";
    changelog = "https://github.com/lejianwen/rustdesk-server/releases/tag/${version}";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.unix;
    mainProgram = "hbbs";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [
      ltrump
    ];
  };
}
