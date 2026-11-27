{
  pkgs,
  lib,
  myhome,
  ...
}:
let
  cfg = myhome.desktop.niri;
in
{
  imports = [
    ./niri
  ]
  ++ lib.optionals cfg.enable [
    ./swaylock.nix
  ];

  config = lib.mkIf cfg.enable {
    home.pointerCursor.x11.enable = true;
    programs.rofi = {
      enable = true;
      extraConfig.dpi = lib.mkForce 96;
      package = pkgs.rofi;
    };

    home.packages = with pkgs; [
      snipaste
      wl-clipboard-rs
      grim
      slurp
      swappy
      acpi
      mpvpaper
      xorg.xrdb
    ];
  };
}
