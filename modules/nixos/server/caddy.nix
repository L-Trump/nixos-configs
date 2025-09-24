{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (builtins) pathExists;
  inherit (config.networking) hostName;
  inherit (inputs) mysecrets;
  plainCfgPath = "${mysecrets}/caddy/caddyfile-${hostName}";
  cfg.enable = lib.or (builtins.hasAttr "caddyfile" config.age.secrets) (pathExists plainCfgPath);
  cfgPath =
    if (builtins.hasAttr "caddyfile" config.age.secrets) then
      config.age.secrets.caddyfile.path
    else
      plainCfgPath;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.caddy ];

    services.caddy = {
      enable = true;
      configFile = cfgPath;
      enableReload = false;
    };
    # General public ports
    networking.firewall.allowedTCPPorts = [
      80
      443
      8080
      8443
    ];
  };
}
