{
  lib,
  stdenv,
  fetchurl,
  unzip,
  versionCheckHook,
}:
let
  arch = if stdenv.hostPlatform.isAarch64 then "arm64" else "amd64";
in
stdenv.mkDerivation rec {
  pname = "sctgdesk-server";
  version = "1.1.99.47";

  src = fetchurl {
    url = "https://github.com/sctg-development/sctgdesk-server/releases/download/${version}/linux_static_${version}_${arch}.zip";
    sha256 =
      {
        x86_64-linux = "sha256-P9Xd+whQLjNHGJVeAPpJaPeL7S0GvqTxzNBXVZhI6HI=";
        aarch64-linux = "sha256-Hb25wI7iySQuLbs4pvv3zaCuEtpDsxjiZYHk2cQhaXc=";
      }
      .${stdenv.hostPlatform.system} or (throw "unsupported system ${stdenv.hostPlatform.system}");
  };

  nativeBuildInputs = [ unzip ];
  unpackCmd = "unzip $src";
  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp ./hbbr $out/bin/hbbr
    cp ./hbbs $out/bin/hbbs
    cp ./rustdesk-utils $out/bin/rustdesk-utils

    runHook postInstall
  '';

  nativeInstallCheckPhaseInputs = [ versionCheckHook ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "RustDeskPro Server Program";
    homepage = "https://github.com/sctg-development/sctgdesk-server";
    changelog = "https://github.com/sctg-development/sctgdesk-server/releases/tag/${version}";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.unix;
    mainProgram = "hbbs";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [
      ltrump
    ];
  };
}
