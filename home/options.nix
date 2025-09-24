{
  lib,
  config,
  ...
}:
with lib;
let
  kdlType =
    with lib.types;
    nullOr (oneOf [
      bool
      int
      float
      str
      path
      (attrsOf kdlType)
      (listOf kdlType)
    ]);
in
{
  options.myhome = {
    tuiExtra = {
      enable = mkEnableOption "Extra TUI configs (mainly for developing)";
      mail.enable = mkEnableOption "E-Mail related";
      lsp = {
        enable = mkEnableOption "Enable language server protocols programs";
        lang = mkOption {
          type = types.listOf (
            types.enum [
              "nix"
              "markdown"
              "rust"
              "bash"
              "c"
              "all"
            ]
          );
          default = [
            "nix"
            "bash"
          ];
          description = "Enabled languages";
        };
      };
    };
    desktop = {
      enable = mkEnableOption "Enable Desktop Environment";
      hyprland.enable = mkEnableOption "Hyprland WM" // {
        default = true;
      };
      niri = {
        enable = mkEnableOption "Niri WM" // {
          default = true;
        };
        settings = mkOption {
          type = types.submodule { freeformType = kdlType; };
          default = { };
          description = "Niri Configuration";
        };
      };
      xorg.enable = mkEnableOption "Xorg Display Server" // {
        default = true;
      };
      daily.enable = mkEnableOption "Daily stuffs";
      daily.game.enable = mkEnableOption "Games";
    };
  };
}
