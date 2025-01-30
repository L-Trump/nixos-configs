{...}: {
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
      wayland.enable = false;
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
      duplicati.enable = false;
      vaultwarden.enable = false;
      homepage-dashboard.enable = false;
      minio.enable = false;
      juicefs.enable = false;
      redis = {
        juicefs-meta.enable = false;
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
      wayland.enable = false;
      xorg.enable = false;
      daily.enable = false;
      daily.game.enable = false;
    };
  };
}
