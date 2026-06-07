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
      package = pkgs.caddy.withPlugins {
        plugins = [
          "github.com/caddy-dns/cloudflare@v0.2.4"
        ];
        hash = "sha256-J0HWjCPoOoARAxDpG2bS9c0x5Wv4Q23qWZbTjd8nW84=";
      };
      configFile = cfgPath;
      enableReload = false;
    };
    # General public ports
    networking.firewall.allowedTCPPorts = [
      80
      443
      8080
      8443
      18088
    ];
  };
}
