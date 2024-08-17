{ config, lib, pkgs, ... }:

{
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
  services.fwupd.enable = true;

  # Enable sound by pipewire.
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.udisks2.enable = true;
}
