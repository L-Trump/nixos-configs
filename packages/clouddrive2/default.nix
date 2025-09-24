{
  lib,
  stdenv,
  fetchzip,
  makeWrapper,
}:
let
  os = if stdenv.hostPlatform.isDarwin then "macos" else "linux";
  arch = if stdenv.hostPlatform.isAarch64 then "aarch64" else "x86_64";
in
stdenv.mkDerivation rec {
  pname = "clouddrive2";
  version = "0.7.21";

  src = fetchzip {
    url = "https://github.com/cloud-fs/cloud-fs.github.io/releases/download/v${version}/clouddrive-2-${os}-${arch}-${version}.tgz";
    sha256 =
      {
        x86_64-linux = "sha256-t6Jbbm/G1GjHCRQPbBVymr5q2nLLEOROpn0T6SvzMS4=";
        aarch64-linux = "sha256-VxG5jGX5KXuIpxfBmlhukuZzfAM8O9a9e5BaIjIRJ8I=";
        x86_64-darwin = "sha256-W5mTrgVWXKdjc0wZRdVNuw5+Pp0PUrGLXjmu3UQQbGw=";
        aarch64-darwin = "sha256-aNxKTM/2TDVqMnZCFojWLgpKkzyZSP42SFIODpZuGsY=";
      }
      .${stdenv.hostPlatform.system} or (throw "unsupported system ${stdenv.hostPlatform.system}");
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/opt/clouddrive2
    cp -r wwwroot "$out/opt/clouddrive2/wwwroot"
    cp -r clouddrive "$out/opt/clouddrive2/clouddrive"
    makeWrapper $out/opt/clouddrive2/clouddrive $out/bin/clouddrive

    runHook postInstall
  '';

  passthru.updateScript = ./update-bin.sh;

  meta = {
    homepage = "https://www.clouddrive2.com";
    changelog = "https://github.com/cloud-fs/cloud-fs.github.io/releases/tag/v${version}";
    description = "Powerful multi-cloud drives management tool supporting mounting cloud drives locally.";
    longDescription = ''
      CloudDrive is a powerful multi-cloud drive management tool that provides users with a one-stop
      multi-cloud drive solution that includes local mounting of cloud drives. It supports lots of
      cloud drives in China.
    '';
    mainProgram = "clouddrive";
    license = lib.licenses.unfree;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ ltrump ];
  };
}
