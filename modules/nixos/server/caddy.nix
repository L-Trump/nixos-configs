{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (builtins) pathExists;
  inherit (config.networking) hostName;
  inherit (inputs) mysecrets;
  plainCfgPath = "${mysecrets}/caddy/caddyfile-${hostName}";
  cfg.enable =
    lib.or (builtins.hasAttr "caddyfile" config.age.secrets) (pathExists plainCfgPath);
  cfgPath =
    if (builtins.hasAttr "caddyfile" config.age.secrets)
    then config.age.secrets.caddyfile.path
    else plainCfgPath;
in {
  environment.systemPackages = lib.mkIf cfg.enable [pkgs.caddy];

  services.caddy = lib.mkIf cfg.enable {
    enable = true;
    configFile = cfgPath;
  };
}
