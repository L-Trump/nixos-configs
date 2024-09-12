{
  lib,
  config,
  ...
}:
with lib; {
  options.myhome = {
    tuiExtra = {
      enable = mkEnableOption "Extra TUI configs";
      mail.enable = mkEnableOption "E-Mail related";
    };
    desktop = {
      enable = mkEnableOption "Enable Desktop Environment";
      wayland.enable = mkEnableOption "Wayland Display Server" // {default = true;};
      xorg.enable = mkEnableOption "Xorg Display Server" // {default = true;};
      daily.enable = mkEnableOption "Daily stuffs";
      daily.game.enable = mkEnableOption "Games";
    };
  };
}
