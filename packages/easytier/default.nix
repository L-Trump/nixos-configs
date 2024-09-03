{ lib
, fetchzip
, stdenv
}:

stdenv.mkDerivation {
  pname = "easytier";
  version = "1.2.3";
  src = fetchzip {
    url = "https://github.com/EasyTier/EasyTier/releases/download/v1.2.3/easytier-linux-x86_64-v1.2.3.zip";
    sha256 = "sha256-EallzDgrya54odwKaRL/MTnfLf6EZdI/rLNwGb1flBI=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm 755 easytier-cli $out/bin/easytier-cli
    install -Dm 755 easytier-core $out/bin/easytier-core

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/EasyTier/EasyTier";
    description = "A simple, decentralized mesh VPN with WireGuard support.";
    mainProgram = "easytier-cli";
    longDescription = ''
      EasyTier is a simple, safe and decentralized VPN networking solution implemented 
      with the Rust language and Tokio framework. 
    '';
    license = with lib.licenses; [ asl20 ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
}
