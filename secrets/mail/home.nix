{ pkgs, config, lib, ... }:

{
  age.secrets.aerc-accounts = {
    file = ./aerc-accounts.conf.age;
    path = "${config.xdg.configHome}/aerc/accounts.conf";
  };

  age.secrets.goimapnotify-conf = {
    file = ./goimapnotify-config.yaml.age;
    path = "${config.xdg.configHome}/goimapnotify/goimapnotify.yaml";
  };

  age.secrets.offlineimaprc = {
    file = ./offlineimaprc.age;
    path = "${config.xdg.configHome}/offlineimap/config";
  };

  home.file.".passage/store/Email" = {
    source = ../passage/Email;
    recursive = true;
  };
}
