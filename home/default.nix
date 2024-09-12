{
  myvars,
  config,
  myhome,
  lib,
  ...
}:
with lib; let
  rawcfg = myhome;
in {
  home = {
    inherit (myvars) username;
    homeDirectory = "/home/${myvars.username}";

    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;

  imports =
    [
      ./options.nix
      ./core
    ]
    ++ optional rawcfg.tuiExtra.enable ./tui
    ++ optional rawcfg.desktop.enable ./gui;

  myhome = rawcfg;
}
