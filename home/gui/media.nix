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

    # ffmpeg-full
    ffmpeg

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
    mesa-demos
  ];

  programs = {
    mpv = {
      enable = true;
      defaultProfiles = [ "gpu-hq" ];
      scripts = with pkgs.mpvScripts; [
        mpris
        encode
        mpv-cheatsheet
        uosc
        thumbfast
      ];
      config = {
        osd-bar = "no";
        border = "no";
      };
      bindings = {
        space = "cycle pause; script-binding uosc/flash-pause-indicator";
        right = "seek 5; script-binding uosc/flash-timeline";
        left = "seek -5; script-binding uosc/flash-timeline";
        "shift+right" = "seek 30; script-binding uosc/flash-timeline";
        "shift+left" = "seek -30; script-binding uosc/flash-timeline";
        m = "no-osd cycle mute; script-binding uosc/flash-volume";
        up = "no-osd add volume 10; script-binding uosc/flash-volume";
        down = "no-osd add volume -10; script-binding uosc/flash-volume";
        "[" = "no-osd add speed -0.1; script-binding uosc/flash-speed";
        "]" = "no-osd add speed 0.1; script-binding uosc/flash-speed";
        "\\" = "no-osd set speed 1; script-binding uosc/flash-speed";
        ">" = "script-binding uosc/next; script-message-to uosc flash-elements top_bar,timeline";
        "<" = "script-binding uosc/prev; script-message-to uosc flash-elements top_bar,timeline";
      };
    };
  };

  services.playerctld.enable = true;
  services.mpris-proxy.enable = true;
}
