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
      lsp = {
        enable = mkEnableOption "Enable language server protocols programs";
        lang = mkOption {
          type = types.listOf (types.enum [
            "nix"
            "markdown"
            "rust"
            "bash"
            "c"
            "all"
          ]);
          default = [ "nix" "bash" ];
          description = "Enabled languages";
        };
      };
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
