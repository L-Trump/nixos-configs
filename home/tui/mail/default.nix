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
    ./accounts.nix
    ./aerc
    ./aerc/accounts-conf.nix
    ./offlineimap.nix
    ./imapnotify.nix
    ./notmuch.nix
  ];

  config = lib.mkIf cfg.enable {
    home.packages = [ mail-scripts ];
  };
}
