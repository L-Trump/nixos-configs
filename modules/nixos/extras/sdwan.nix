{
  config,
  myvars,
  pkgs,
  lib,
  ...
}: let
  inherit (myvars.networking) hostsRecord;
  easytier-pkg = pkgs.easytier;
  cfg.et.enable = builtins.hasAttr "easytier-conf" config.age.secrets;
in {
  services.tailscale.enable = true;

  environment.systemPackages = [easytier-pkg];

  networking.hosts = lib.mkIf cfg.et.enable hostsRecord;
  systemd.services.easytier-ltnet = lib.mkIf cfg.et.enable {
    path = with pkgs; [easytier-pkg iproute2 bash];
    description = "EasyTier Service";
    wants = ["network-online.target" "nss-lookup.target"];
    after = ["network-online.target" "nss-lookup.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${easytier-pkg}/bin/easytier-core -c ${config.age.secrets.easytier-conf.path} --multi-thread";
      Restart = "on-failure";
    };
    wantedBy = ["multi-user.target"];
  };
}
