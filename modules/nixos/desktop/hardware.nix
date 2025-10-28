{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mymodules.desktop;
in
{
  environment.systemPackages = with pkgs; [
    pulseaudio # provides `pactl`, which is required by some apps(e.g. sonic-pi)
  ];

  # Enable sound by pipewire.
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    wireplumber.enable = true;
  };
  # rtkit is optional but recommended
  security.rtkit.enable = true;

  services.blueman.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.geoclue2.enable = true;
  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.udisks2.enable = true;

  services.udev.packages = with pkgs; [
    gnome-settings-daemon
    # platformio # udev rules for platformio
    # openocd # required by platformio, see https://github.com/NixOS/nixpkgs/issues/224895
    openfpgaloader
  ];

  services.keyd = lib.mkIf (cfg.keyremap.enable) {
    enable = true;
    keyboards.default.settings = {
      main = {
        # overloads the capslock key to function as both escape (when tapped) and control (when held)
        capslock = "overload(control, esc)";
        esc = "capslock";
      };
    };
  };

  services.fwupd.enable = true;

  security.wrappers.brightnessctl = {
    setuid = true;
    owner = "root";
    group = "root";
    source = "${pkgs.brightnessctl}/bin/brightnessctl";
  };
}
