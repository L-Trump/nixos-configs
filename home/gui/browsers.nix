{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    firefox
    # google-chrome
    # microsoft-edge
  ];

  home.sessionVariables = {
    "MOZ_USE_XINPUT2" = 1;
  };

  programs.google-chrome = {
    enable = true;

    # https://wiki.archlinux.org/title/Chromium#Native_Wayland_support
    commandLineArgs = [
      "--ozone-platform-hint=auto"
      "--enable-features=WaylandWindowDecorations"
      # make it use text-input-v1, which works for kwin 5.27 and weston
      "--enable-wayland-ime"

      # enable hardware acceleration - vulkan api
      # "--enable-features=Vulkan"
    ];
  };
}
