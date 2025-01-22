{...}: {
  mymodules = {
    virtualization = {
      enable = false;
      docker.enable = false;
      qemu.enable = false;
      microvm = {
        host.enable = false;
        guest.enable = false;
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
      nezha-agent.enable = false;
      rustdesk-server.enable = false;
      easytier.enable = false;
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
