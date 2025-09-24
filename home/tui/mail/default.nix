{
  config,
  myhome,
  pkgs,
  lib,
  ...
}:
let
  mail-scripts = pkgs.mkScriptsPackage "mail-scripts" ./scripts;
  cfg = config.myhome.tuiExtra.mail;
  rawcfg = myhome.tuiExtra.mail;
in
{
  imports = lib.optionals rawcfg.enable [
    ./aerc
    ./offlineimap
    ./imapnotify
  ];

  config = lib.mkIf cfg.enable {
    home.packages = [ mail-scripts ];
  };
}
