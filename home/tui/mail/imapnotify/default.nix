{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  version = "76e55f39222e2d251600d7c4d52846ef838702ba";
  src = pkgs.fetchFromGitLab {
    owner = "shackra";
    repo = "goimapnotify";
    rev = version;
    hash = "sha256-oNcEftR4wystgMuSN9mmzqkUXAPDe02JH2elhzdymDY=";
  };
  cfg.package = pkgs.goimapnotify.override {
    buildGoModule =
      args:
      pkgs.buildGoModule (
        args
        // {
          inherit src version;
          vendorHash = "sha256-rWPXQj0XFS/Mv9ylGv09vol0kkRDNaOAEgnJvSWMvoI=";
        }
      );
  };
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
