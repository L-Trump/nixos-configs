{
  lib,
  config,
  inputs,
  ...
}:
let
  inherit (inputs) mysecrets;
  cfg = config.myhome.tuiExtra.mail;
in
{
  config = lib.mkIf cfg.enable {
    age.secrets.aerc-accounts = {
      file = "${mysecrets}/mail/aerc-accounts.conf.age";
      path = "${config.xdg.configHome}/aerc/accounts.conf";
    };

    age.secrets.goimapnotify-conf = {
      file = "${mysecrets}/mail/goimapnotify-config.yaml.age";
      path = "${config.xdg.configHome}/goimapnotify/goimapnotify.yaml";
    };

    age.secrets.offlineimaprc = {
      file = "${mysecrets}/mail/offlineimaprc.age";
      path = "${config.xdg.configHome}/offlineimap/config";
    };

    home.file.".passage/store/Email" = {
      source = "${mysecrets}/passage/Email";
      recursive = true;
    };
  };
}
