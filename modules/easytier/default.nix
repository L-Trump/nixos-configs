{ config, lib, pkgs, ... }:
let
  package = pkgs.easytier;
in

{
  environment.systemPackages = [ package ];
  systemd.services.easytier-ltnet = {
    path = with pkgs; [ package iproute2 bash ];
    description = "EasyTier Service for LTNet";
    wants = [ "network.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${package}/bin/easytier-core -c ${config.age.secrets.easytier-conf.path} --multi-thread";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
