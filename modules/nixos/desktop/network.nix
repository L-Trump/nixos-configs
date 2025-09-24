{ pkgs, ... }:
{
  # Clash
  programs.clash-verge = {
    enable = true;
    autoStart = false;
    package = pkgs.clash-verge-rev;
    serviceMode = true;
    tunMode = true;
  };
  networking.firewall.allowedTCPPortRanges = [
    {
      from = 7890;
      to = 7895;
    }
  ];
}
