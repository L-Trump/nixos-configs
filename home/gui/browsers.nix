{
  config,
  pkgs,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    firefox-bin
    # google-chrome
    # microsoft-edge
  ];

  home.sessionVariables = {
    "MOZ_USE_XINPUT2" = 1;
    "BROWSER" = "firefox";
  };
}
