{ ... }:
{
  mymodules = {
    virtualization = {
      enable = false;
      docker.enable = false;
      qemu.enable = false;
      microvm = {
        host.enable = false;
        guest.enable = false;
        guest.isInfra = false;
      };
    };
    desktop = {
      enable = false;
      animeboot.enable = false;
      hyprland.enable = false;
      niri.enable = false;
      xorg.enable = false;
      game.enable = false;
      keyremap.enable = false;
      remote-desktop.sunshine.enable = false;
    };
    server = {
      easytier.enable = false;
      nezha-agent.enable = false;
      nezha-server.enable = false;
      rustdesk-server.enable = false;
      rustdesk-api.enable = false;
      duplicati.enable = false;
      kopia-server.enable = false;
      backrest.enable = false;
      syncthing.enable = false;
      hubproxy.enable = false;
      vaultwarden.enable = false;
      homepage-dashboard.enable = false;
      minio.enable = false;
      openlist.enable = false;
      siyuan-server.enable = false;
      xpipe-webtop.enable = false;
      authentik.enable = false;
      sshwifty.enable = false;
      ncm-api.enable = false;
      immich.machine-learning.enable = false;
      juicefs.enable = false;
      redis = {
        juicefs-meta.enable = false;
      };
      cloudreve = {
        master.enable = false;
      };
    };
  };

  myhome = {
    tuiExtra = {
      enable = false;
      mail.enable = false;
      lsp.enable = false;
      # lsp.lang = ["all"];
    };
    desktop = {
      enable = false;
      hyprland.enable = false;
      niri.enable = false;
      xorg.enable = false;
      daily.enable = false;
      daily.game.enable = false;
    };
  };
}
