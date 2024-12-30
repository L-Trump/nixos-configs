{pkgs, ...}: {
  # Clash
  programs.clash-verge = {
    enable = true;
    autoStart = false;
    package = pkgs.clash-verge-rev;
  };
}
