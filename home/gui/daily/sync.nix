{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    onedriver
    bitwarden-desktop
    rbw
    pinentry
    rofi-rbw-wayland
  ];

  services.syncthing.enable = true;

  systemd.user.services."onedriver@" = {
    Unit.Description = "onedriver";
    Service = {
      Environment = "PATH=/run/wrappers/bin:/run/current-system/sw/bin:/etc/profiles/per-user/%u/bin";
      ExecStart = "${pkgs.onedriver}/bin/onedriver %f";
      ExecStopPost = "/run/wrappers/bin/fusermount -uz /%I";
      Restart = "on-abnormal";
      RestartSec = 3;
      RestartForceExitStatus = 2;
    };
    Install.WantedBy = ["default.target"];
  };
}
