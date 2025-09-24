{
  inputs,
  pkgs,
  config,
  lib,
  myvars,
  ...
}:
let
  inherit (inputs) mysecrets;
  inherit (config.networking) hostName;
  inherit (builtins) pathExists;
  hostConf = "${mysecrets}/easytier/ltnet-${hostName}.conf.age";
  commonEnv = "${mysecrets}/easytier/ltnet-env.age";
  hostEnv = "${mysecrets}/easytier/ltnet-env-${hostName}.age";
  enableSetting = builtins.hasAttr "${hostName}" myvars.networking.hostsAddr.easytier;
in
{
  age.secrets.easytier-conf = lib.mkIf (pathExists hostConf) {
    file = hostConf;
    path = "/etc/easytier/ltnet.conf";
  };

  age.secrets.et-ltnet-env = lib.mkIf (pathExists commonEnv && enableSetting) {
    file = commonEnv;
    path = "/etc/easytier/ltnet-env";
  };

  age.secrets.et-ltnet-env-host = lib.mkIf (pathExists hostEnv && enableSetting) {
    file = hostEnv;
    path = "/etc/easytier/ltnet-env-host";
  };
}
