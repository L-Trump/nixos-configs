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
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, nur, agenix, ... }@inputs:
    let
      inherit (inputs.nixpkgs) lib;
      mylib = import ./lib { inherit lib; };
      genSpecialArgs = { inherit mylib; };
    in
    {
      nixosConfigurations.ltrumpNixOS = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = genSpecialArgs;
        modules = [
          ./hosts/matebook-gt14
          nixos-hardware.nixosModules.common-cpu-intel
          nixos-hardware.nixosModules.common-pc-laptop
          nixos-hardware.nixosModules.common-pc-ssd
          {
            nixpkgs.overlays = [
              nur.overlay
              agenix.overlays.default
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
            home-manager.users.ltrump = import ./home;
            home-manager.sharedModules = [
              agenix.homeManagerModules.default
              inputs.nvimdots.homeManagerModules.nvimdots
            ];
            home-manager.extraSpecialArgs = genSpecialArgs;
          }
        ];
      };
    };

}
