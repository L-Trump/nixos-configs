{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.mymodules.server.homepage-dashboard;
  cfgDir = "${inputs.mysecrets}/homepage-dashboard";
in
{
  services.homepage-dashboard = lib.mkIf cfg.enable {
    enable = true;
    listenPort = 8225;
    # openFirewall = true;
    environmentFile = config.age.secrets.homepage-dashboard-env.path;
    settings = import "${cfgDir}/settings.nix";
    services = import "${cfgDir}/services.nix";
    widgets = import "${cfgDir}/widgets.nix";
    docker = import "${cfgDir}/docker.nix";
  };
}
