{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:
let
  arch = if stdenv.hostPlatform.isAarch64 then "arm64" else "amd64";
in
stdenv.mkDerivation rec {
  pname = "hubproxy";
  version = "1.2.5";

  # Since v1.2.5 the upstream assets dropped the version from the file name.
  src = fetchurl {
    url = "https://github.com/sky22333/hubproxy/releases/download/v${version}/hubproxy-linux-${arch}.tar.gz";
    sha256 =
      {
        x86_64-linux = "sha256-KQmna5zT9caYv1Q7rimJozidWc9hLYBlYR8G2TfsO20=";
        aarch64-linux = "sha256-q4l6fGSVYObsx3sKyp+NFub8Ap8PuPNOGBWmpPsJTOk=";
      }
      .${stdenv.hostPlatform.system} or (throw "unsupported system ${stdenv.hostPlatform.system}");
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];
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
