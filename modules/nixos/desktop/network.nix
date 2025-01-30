{pkgs, ...}: {
  # Clash
  programs.clash-verge = {
    enable = true;
    autoStart = false;
    package = pkgs.clash-verge-rev;
  };
  networking.firewall.allowedTCPPortRanges = [
    {
      from = 7890;
      to = 7895;
    }
  ];
}
