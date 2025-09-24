{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Set your time zone.
  time.timeZone = "Asia/Shanghai";
  environment.variables = {
    # fix https://github.com/NixOS/nixpkgs/issues/238025
    TZ = "${config.time.timeZone}";
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "en_GB.UTF-8/UTF-8"
    "zh_CN.UTF-8/UTF-8"
  ];

  # i18n.extraLocaleSettings = {
  #   LC_ADDRESS = "zh_CN.UTF-8";
  #   LC_IDENTIFICATION = "zh_CN.UTF-8";
  #   LC_MEASUREMENT = "zh_CN.UTF-8";
  #   LC_MONETARY = "zh_CN.UTF-8";
  #   LC_NAME = "zh_CN.UTF-8";
  #   LC_NUMERIC = "zh_CN.UTF-8";
  #   LC_PAPER = "zh_CN.UTF-8";
  #   LC_TELEPHONE = "zh_CN.UTF-8";
  #   LC_TIME = "zh_CN.UTF-8";
  # };
}
