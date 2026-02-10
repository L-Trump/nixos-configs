{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg.package = pkgs.goimapnotify;
in
{
  home.packages = [ cfg.package ];
  systemd.user.services.nix-goimapnotify = {
    Unit = {
      Description = "goimapnotify";
    };
    Service = {
      # Use the nix store path for config to ensure service restarts when it changes
      Environment = "PATH=/run/current-system/sw/bin:/etc/profiles/per-user/%u/bin";
      ExecStart = "${getExe cfg.package} -conf '${config.xdg.configHome}/goimapnotify/goimapnotify.yaml'";
      Restart = "always";
      RestartSec = 30;
      Type = "simple";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
