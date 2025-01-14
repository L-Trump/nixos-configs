{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg.enable = builtins.hasAttr "caddyfile" config.age.secrets;
in {
  environment.systemPackages = lib.mkIf cfg.enable [pkgs.caddy];

  services.caddy = lib.mkIf cfg.enable {
    enable = true;
    configFile = config.age.secrets.caddyfile.path;
  };
}
