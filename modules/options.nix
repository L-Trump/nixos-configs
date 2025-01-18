{lib, ...}:
with lib; let
  cfg = config.mymodules;
in {
  options.mymodules = {
    virtualization = {
      enable = mkOption {
        type = types.bool;
        default = cfg.virtualization.docker.enable || cfg.virtualization.qemu.enable;
        description = "Virtualization related";
      };
      docker.enable = mkEnableOption "Enable docker server";
      qemu.enable = mkEnableOption "QEMU KVM";
    };

    desktop = {
      enable = mkOption {
        type = types.bool;
        default = cfg.desktop.wayland.enable || cfg.desktop.xorg.enable;
        description = "Enable Desktop Environments";
      };
      animeboot.enable = mkEnableOption "Enable anime boot with grub theme and plymouth";
      wayland.enable = mkEnableOption "Wayland Display Server";
      xorg.enable = mkEnableOption "Xorg Display Server";
      game.enable = mkEnableOption "Games";
      keyremap.enable = mkEnableOption "Remap capslock and escape";
    };

    server = {
      nezha-agent.enable = mkEnableOption "Enable nezha-monitor agent";
      rustdesk-server.enable = mkEnableOption "Enable rustdesk server";
    };
  };
}
