{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg.cf.enable = builtins.hasAttr "cf-tunnel-conf" config.age.secrets;
in
{
  environment.systemPackages = lib.mkIf cfg.cf.enable [ pkgs.cloudflared ];
  services.cloudflared = lib.mkIf cfg.cf.enable {
    enable = true;
    # user = "root";
    # group = "root";
    tunnels.host-tunnel = {
      credentialsFile = "${config.age.secrets.cf-tunnel-conf.path}";
      default = "http_status:404";
    };
  };
}
