{
  myvars,
  config,
  lib,
  myhome,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.myhome.tuiExtra.openclaw;
  rawcfg = myhome.tuiExtra.openclaw;
in
{
  imports = lib.optionals rawcfg.enable [
    inputs.nix-openclaw.homeManagerModules.openclaw
  ];

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ uv ];

    home.file.".openclaw/node_modules/openclaw".source =
      "${pkgs.openclawPackages.openclaw-gateway}/lib/openclaw";
    # OpenClaw Gateway systemd user service managed by Home Manager
    systemd.user.services.openclaw-gateway = {
      Unit = {
        Description = "OpenClaw Gateway";
        After = [ "network-online.target" ];
        Wants = [ "network-online.target" ];
      };

      Service = {
        ExecStart = "${pkgs.openclawPackages.openclaw}/bin/openclaw gateway --port 18789";
        Restart = "always";
        RestartSec = 5;
        TimeoutStopSec = 30;
        TimeoutStartSec = 30;
        SuccessExitStatus = [
          0
          143
        ];
        KillMode = "control-group";
        Environment = [
          "HOME=/home/${myvars.username}"
          "TMPDIR=/tmp/openclaw-${myvars.username}"
          "OPENCLAW_GATEWAY_PORT=18789"
          "OPENCLAW_SYSTEMD_UNIT=openclaw-gateway.service"
          "OPENCLAW_WINDOWS_TASK_NAME=OpenClaw Gateway"
          "OPENCLAW_SERVICE_MARKER=openclaw"
          "OPENCLAW_SERVICE_KIND=gateway"
        ];
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}
