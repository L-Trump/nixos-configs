{ lib, ... }:
{
  boot.loader.timeout = lib.mkDefault 3;
  # we use Git for version control, so we don't need to keep too many generations.
  boot.loader.grub.configurationLimit = lib.mkDefault 10;

  # Power save
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  # handle powerkey
  services.logind.settings.Login = {
    # don’t shutdown when power button is short-pressed
    HandlePowerKey = "suspend";
  };
}
