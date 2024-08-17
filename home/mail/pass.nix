{ config, pkgs, lib, ... }:

{
  home.file.".passage/store/Email" = {
    source = ../../secrets/passage/Email;
    recursive = true;
  };
}
