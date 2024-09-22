{
  pkgs,
  config,
  ...
}:
# processing audio/video
{
  home.packages = with pkgs; [
    # audio control
    pavucontrol
    playerctl
    pulsemixer

    ffmpeg-full

    # images
    imv # Simple image viewer
    vimiv-qt # A better vim-like image viewer
    viu # Terminal image viewer with native support for iTerm and Kitty
    imagemagick
    graphviz

    # video/audio tools
    libva-utils
    vdpauinfo
    vulkan-tools
    glxinfo
  ];

  programs = {
    mpv = {
      enable = true;
      defaultProfiles = ["gpu-hq"];
      scripts = [pkgs.mpvScripts.mpris];
    };
  };

  services.playerctld.enable = true;
  services.mpris-proxy.enable = true;
}
