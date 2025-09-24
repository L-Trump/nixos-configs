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
    # XDDXDD cache substituter
    inputs.nur-xddxdd.nixosModules.nix-cache-attic
    inputs.nix-index-database.nixosModules.nix-index
  ];
  # auto upgrade nix to the unstable version
  # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/tools/package-management/nix/default.nix#L284
  nix.package = pkgs.nixVersions.latest;
  nix.settings = {
    substituters = lib.mkBefore [
      # Priority of the official substititer is 40
      # See https://cache.nixos.org/nix-cache-info
      "https://mirrors.ustc.edu.cn/nix-channels/store?priority=37"
      # "https://mirror.sjtu.edu.cn/nix-channels/store?priority=38"
      "https://nix-community.cachix.org"
      "https://nixpkgs-update-cache.nix-community.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixpkgs-update-cache.nix-community.org-1:U8d6wiQecHUPJFSqHN9GSSmNkmdiFW7GW7WNAnHW0SM="
    ];
    trusted-users = [ myvars.username ];
    builders-use-substitutes = true;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  # Save storage
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "weekly";
    options = lib.mkDefault "--delete-older-than 7d";
  };

  nixpkgs.config = myvars.nixpkgs-config;

  # make `nix run nixpkgs#nixpkgs` use the same nixpkgs as the one used by this flake.
  nix.registry.nixpkgs.flake = nixpkgs;

  environment.etc."nix/inputs/nixpkgs".source = "${nixpkgs}";
  # make `nix repl '<nixpkgs>'` use the same nixpkgs as the one used by this flake.
  # discard all the default paths, and only use the one from this flake.
  nix.nixPath = lib.mkForce [ "/etc/nix/inputs" ];
  # https://github.com/NixOS/nix/issues/9574
  nix.settings.nix-path = lib.mkForce "nixpkgs=/etc/nix/inputs/nixpkgs";

  programs.nix-index.enable = true;
  programs.nix-index-database.comma.enable = true;
}
