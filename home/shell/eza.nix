{ config, pkgs, lib, ... }:

{
  programs.eza = {
    enable = true;
    icons = true;
    git = true;
  };
  programs.fish.shellAliases = {
    l = "eza -la";
  };
}
