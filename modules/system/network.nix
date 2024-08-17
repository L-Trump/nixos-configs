{ config, lib, pkgs, ... }:

{
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;
  networking.nftables.enable = true;

  services.tailscale.enable = true;
 
  # Clash
  programs.clash-verge = {
    enable = true;
    autoStart = false;
    tunMode = true;
    package = pkgs.clash-verge-rev;
  };
  systemd.services.clash-verge-rev = {
    enable = true;
    description = "Clash Verge Rev Service";
    serviceConfig = {
      ExecStart = "${pkgs.clash-verge-rev}/lib/clash-verge/resources/clash-verge-service";
    };
    wantedBy = [ "multi-user.target" ];
  };
}

