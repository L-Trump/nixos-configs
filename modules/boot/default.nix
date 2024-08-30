{ config, lib, pkgs, ... }:
let
  meumy-grub-theme = pkgs.stdenvNoCC.mkDerivation {
    name = "meumy-grub-theme";
    src = ./meumy-grub-theme;
    dontUnpack = true;
    # setSourceRoot = "sourceRoot=`pwd`";
    installPhase = ''
      mkdir -p $out/grub/themes/meumy
      cp -r $src/* $out/grub/themes/meumy
    '';
  };
in
{
  boot = {
    plymouth = {
      enable = true;
      theme = "breeze";
    };
    # Enable "Silent Boot"
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=0"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    loader.timeout = 3;
  };
  boot.loader.grub.theme = "${meumy-grub-theme}/grub/themes/meumy";
}
