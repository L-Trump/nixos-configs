{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (inputs) mysecrets;
  inherit (config.networking) hostName;
  inherit (builtins) pathExists;
  hostConf = "${mysecrets}/easytier/ltnet-${hostName}.conf.age";
in {
  age.secrets.easytier-conf = lib.mkIf (pathExists hostConf) {
    file = hostConf;
    path = "/etc/easytier/ltnet.conf";
  };
}
