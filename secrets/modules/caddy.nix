{
  inputs,
  config,
  lib,
  ...
}:
let
  inherit (inputs) mysecrets;
  inherit (config.networking) hostName;
  inherit (builtins) pathExists;
  hostConf = "${mysecrets}/caddy/caddyfile-${hostName}.age";
in
{
  age.secrets.caddyfile = lib.mkIf (pathExists hostConf) {
    file = hostConf;
    owner = "caddy";
    group = "caddy";
    mode = "444";
  };
}
