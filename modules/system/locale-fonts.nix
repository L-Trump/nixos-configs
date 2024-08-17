{ config, lib, pkgs, ... }:

{
  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "en_GB.UTF-8/UTF-8"
    "zh_CN.UTF-8/UTF-8"
  ];
  
  fonts = {
    packages = with pkgs; [
      # icon fonts
      material-design-icons

      # normal fonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      source-code-pro

      vistafonts-chs
      vistafonts

      # nerdfonts
      (nerdfonts.override {fonts = [ "FiraCode" "JetBrainsMono" ];})
    ];

  # enableDefaultPackages = false;

  # fontconfig.defaultFonts = {
  #   serif = [ "Noto Serif" "Noto Color Emoji" ];
  #   sansSerif = [ "Noto Sans" "Noto Color Emoji" ];
  #   monospace = [ "JetBrainMono Nerd Font" "Noto Color Emoji" ];
  #   emoji = [ "Noto Color Emoji" ];
  # };
  };
}

