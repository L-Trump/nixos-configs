# See https://wiki.nixos.org/wiki/Fingerprint_scanner
{ pkgs, ... }:
{
  services.fprintd = {
    enable = true;
  };
  systemd.services.fprintd = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "simple";
  };

  security.pam.services.swaylock = {
    fprintAuth = true;
    allowNullPassword = true;
    rules.auth.unix.order = 11390;
  };
}
