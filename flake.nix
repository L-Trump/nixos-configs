{
  description = "LTrump's NixOS flake";

  inputs = {
    # unstable nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # hardware optimization
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # home-manager unstable
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # NUR packages
    nur.url = "github:nix-community/NUR";
    # Hyprland
    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Hyprland gestures
    hyprgrass = {
      url = "github:horriblename/hyprgrass";
      inputs.hyprland.follows = "hyprland"; # IMPORTANT
    };
    # xddxdd packages, for qq/wechat
    nur-xddxdd = {
      url = "github:xddxdd/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Agenix - secrets manager
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # My Nvimdots
    nvimdots = {
      url = "github:L-Trump/nvimdots/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Lan mouse
    lan-mouse = {
      url = "github:feschber/lan-mouse";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, nur, agenix, ... }@inputs:
    let
      inherit (nixpkgs) lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages."${system}";
      mylib = import ./lib { inherit lib; };
      genSpecialArgs = { inherit mylib inputs; };
    in
    {
      packages."${system}" = import ./packages { inherit pkgs; };
      nixosConfigurations.ltrumpNixOS = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = genSpecialArgs;
        modules = [
          ./hosts/matebook-gt14
          ./overlays
          ./secrets/default.nix
          ./secrets/hosts/matebook-gt14/default.nix
          nixos-hardware.nixosModules.common-cpu-intel
          nixos-hardware.nixosModules.common-pc-laptop
          nixos-hardware.nixosModules.common-pc-ssd
          {
            nixpkgs.overlays = [
              nur.overlay
              agenix.overlays.default
              inputs.hyprland.overlays.default
            ];
          }
          # XDDXDD overlay
          inputs.nur-xddxdd.nixosModules.setupOverlay
          # XDDXDD cache substituter
          inputs.nur-xddxdd.nixosModules.nix-cache-attic
          agenix.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.ltrump = {
              imports = [
                ./hosts/matebook-gt14/home.nix
                ./secrets/home.nix
              ];
            };
            home-manager.sharedModules = [
              agenix.homeManagerModules.default
              inputs.nvimdots.homeManagerModules.nvimdots
              inputs.lan-mouse.homeManagerModules.default
            ];
            home-manager.extraSpecialArgs = genSpecialArgs;
          }
        ];
      };
    };

}
