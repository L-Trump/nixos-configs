{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (inputs) mysecrets;
  inherit (config.networking) hostName;
  inherit (builtins) pathExists;
  hostConf = "${mysecrets}/cloudflared/cf-${hostName}.json.age";
in
{
  age.secrets.cf-tunnel-conf = lib.mkIf (pathExists hostConf) {
    file = hostConf;
  };
}
