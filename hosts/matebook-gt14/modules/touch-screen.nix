# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  pkgs,
  ...
}:
{
  systemd.services.touchscreen-workaround = {
    description = "Workaround for i2c-hid-based touchscreen";
    after = [
      "systemd-user-sessions.service"
      "getty@tty1.service"
      "systemd-logind.service"
    ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.kmod}/bin/modprobe -r i2c_hid_acpi; ${pkgs.kmod}/bin/modprobe i2c_hid_acpi'";
    };
    wantedBy = [ "multi-user.target" ];
  };

  hardware.opentabletdriver.enable = true;

  # systemd.services.touchegg = {
  #   description = "Touchegg Daemon";
  #   after = [ "touchscreen-workaround.service" ];
  #   serviceConfig = {
  #     Type = "simple";
  #     ExecStart = "${pkgs.touchegg}/bin/touchegg --daemon";
  #     Restart = "on-failure";
  #   };
  #   wantedBy = [ "multi-user.target" ];
  # };
  #
  # environment.systemPackages = [ pkgs.touchegg ];
}
