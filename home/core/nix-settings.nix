{
  inputs,
  myvars,
  lib,
  pkgs,
  nixpkgs,
  ...
}:
{
  imports = [
    inputs.nix-index-database.homeModules.nix-index
  ];
  # Save storage
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "weekly";
    options = lib.mkDefault "--delete-older-than 7d --option use-xdg-base-directories true";
  };

  # make `nix run nixpkgs#nixpkgs` use the same nixpkgs as the one used by this flake.
  nix.registry.nixpkgs.flake = nixpkgs;

  programs.nix-index.enable = true;
  programs.nix-index-database.comma.enable = true;
}
