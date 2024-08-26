{ config, pkgs, lib, ... }:

{
  services.darkman = {
    enable = true;
    settings = {
      lng = 121.4;
      lat = 31;
      dbusserver = true;
      portal = true;
      usegeoclue = false;
    };
  };
}
