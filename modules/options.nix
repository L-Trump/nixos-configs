{
  lib,
  myvars,
  options,
  ...
}:
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
      microvm = {
        host.enable = mkEnableOption "Enable MicroVM Host";
        host.infras = mkOption {
          type = types.listOf types.str;
          default = [];
          description = "VM Infrastructures on host";
        };
        guest.enable = mkEnableOption "Enable MicroVM Guest";
        guest.isInfra = (mkEnableOption "Current build is infra or not") // {default = true;};
      };
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
      remote-desktop = {
        sunshine.enable = mkEnableOption "Enable sunshine remote desktop";
      };
    };

    server = {
      nezha-agent.enable = mkEnableOption "Enable nezha-monitor agent";
      nezha-server.enable = mkEnableOption "Enable nezha-monitor server";
      rustdesk-server.enable = mkEnableOption "Enable rustdesk server";
      duplicati.enable = mkEnableOption "Enable duplicati backup tool";
      kopia-server.enable = mkEnableOption "Enable duplicati backup tool";
      vaultwarden.enable = mkEnableOption "Enable vaultwarden password manager";
      homepage-dashboard.enable = mkEnableOption "Enable homepage-dashboard";
      minio.enable = mkEnableOption "Enable minio s3 storage";
      alist.enable = mkEnableOption "Enable Alist file driver";
      juicefs = {
        enable = mkEnableOption "Enable juicefs daemon";
        enableS3Gateway = mkEnableOption "Enable juicefs s3 gateway";
        meta-url = mkOption {
          type = types.str;
          description = "Metadata url for juicefs";
        };
      };
      redis = {
        juicefs-meta = {
          enable = mkEnableOption "Enable juicefs meta redis database";
          port = mkOption {
            type = types.port;
            default = 6379;
          };
          isSlave = mkEnableOption "Whether the databse is slave";
        };
      };
      easytier = {
        enable = mkEnableOption "Enable easytier with web controller";
        config-server = mkOption {
          type = types.str;
          default = "${myvars.username}";
        };
      };
    };
  };
}
