{
  inputs,
  myvars,
  lib,
  pkgs,
  nixpkgs,
  ...
}: {
  # Save storage
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = lib.mkDefault true;
    frequency = lib.mkDefault "weekly";
    options = lib.mkDefault "--delete-older-than 7d --option use-xdg-base-directories true";
  };

  # make `nix run nixpkgs#nixpkgs` use the same nixpkgs as the one used by this flake.
  nix.registry.nixpkgs.flake = nixpkgs;
}