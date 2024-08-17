{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    firefox
    google-chrome
    microsoft-edge

    onedriver
    openfortivpn
    remmina

    wpsoffice-cn

    logseq
    qq
    wechat-uos-without-sandbox
    nur.repos.linyinfeng.wemeet
    nur.repos.rewine.ttf-wps-fonts

    vikunja
    zotero
    bitwarden-desktop
  ];

  services.syncthing.enable = true;

  # systemd.user.services."onedriver@" = {
  #   Unit.Description = "onedriver";
  #   Service = {
  #     ExecStart = "${pkgs.onedriver}/bin/onedriver %f";
  #     ExecStopPost = "/run/wrappers/bin/fusermount -uz /%I";
  #     Restart = "on-abnormal";
  #     RestartSec = 3;
  #     RestartForceExitStatus = 2;
  #     Environment = "PATH=/run/current-system/sw/bin";
  #   };
  #   Install.WantedBy = [ "default.target" ];
  # };
}
