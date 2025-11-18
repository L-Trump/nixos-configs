{
  pkgs-unstable,
  pkgs,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    # onedriver
    bitwarden-desktop
    clouddrive2
    rbw
    rofi-rbw-wayland
    rustdesk-flutter
  ];

  services.syncthing.enable = true;

  # systemd.user.services."onedriver@" = {
  #   Unit.Description = "onedriver";
  #   Service = {
  #     Environment = "PATH=/run/wrappers/bin:/run/current-system/sw/bin:/etc/profiles/per-user/%u/bin";
  #     ExecStart = "${pkgs.onedriver}/bin/onedriver %f";
  #     ExecStopPost = "/run/wrappers/bin/fusermount -uz /%I";
  #     Restart = "on-abnormal";
  #     RestartSec = 3;
  #     RestartForceExitStatus = 2;
  #   };
  #   # Install.WantedBy = ["default.target"];
  # };

  systemd.user.services."clouddrive2" = {
    Unit = {
      Description = "CloudDrive";
      Wants = [ "network-online.target" ];
      After = [
        "network-online.target"
        "network.target"
      ];
    };
    Service = {
      Type = "exec";
      Environment = [
        "PATH=/run/wrappers/bin:/run/current-system/sw/bin:/etc/profiles/per-user/%u/bin"
      ];
      ExecStart = "${pkgs.clouddrive2}/bin/clouddrive";
    };
    Install.WantedBy = [ "default.target" ];
  };
}
