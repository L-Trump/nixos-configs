{lib, ...}: {
  boot.loader.timeout = 3;
  # we use Git for version control, so we don't need to keep too many generations.
  boot.loader.grub.configurationLimit = 10;

  # Power save
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
}
