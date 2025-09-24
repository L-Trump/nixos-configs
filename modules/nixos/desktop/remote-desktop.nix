{
  config,
  lib,
  ...
}:
let
  cfg = config.mymodules.desktop.remote-desktop;
in
{
  services.sunshine = lib.mkIf cfg.sunshine.enable {
    enable = true;
    openFirewall = true;
    capSysAdmin = true;
  };
}
