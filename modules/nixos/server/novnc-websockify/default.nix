{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.mymodules.server.novnc-websockify;
  inherit (lib) optionalString mkIf;
  listenAddress = "127.0.0.1";
  listenPort = "6884";
  websockify = pkgs.python3Packages.websockify;
  tokenFile = "${inputs.mysecrets}/websockify/tokens";
  webDir = pkgs.symlinkJoin {
    name = "novnc-web";
    paths = [
      inputs.novnc
      (pkgs.runCommand "novnc-index" { } ''
        mkdir -p $out
        cp ${./novnc-index.html} $out/index.html
      '')
    ];
  };
in
{
  config = mkIf cfg.enable {
    systemd.services.novnc-websockify = {
      description = "websockify token-based WebSocket relay for noVNC";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = ''
          ${lib.getExe websockify} \
            --token-plugin TokenFile \
            --token-source ${tokenFile} \
            ${optionalString cfg.enableWeb "--web ${webDir} "}\
            ${listenAddress}:${listenPort}
        '';
        Restart = "always";
        RestartSec = 3;
      };
    };
  };
}
