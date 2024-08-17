{ config, lib, pkgs, ... }:

{
  nix.settings = {
    substituters = [ 
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    trusted-users = [ "ltrump" ];
    builders-use-substitutes = true;
    experimental-features = [ "nix-command" "flakes" ];
  };

  # Save storage
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "weekly";
    options = lib.mkDefault "--delete-older-than 7d";
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "electron-27.3.11"
    "openssl-1.1.1w"
  ];
}

