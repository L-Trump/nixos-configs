{ pkgs, config, lib, ... }:

{
  age.secrets.easytier-conf = {
    file = ./easytier-ltnet.conf.age;
    path = "/etc/easytier/ltnet.conf";
  };
}
