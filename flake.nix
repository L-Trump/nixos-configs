{
  description = "LTrump's NixOS flake";

  outputs = inputs: import ./outputs inputs;

  inputs = {
    # Official NixOS package source, using nixos's unstable branch by default
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
    # # Hyprland gestures
    # hyprgrass = {
    #   url = "github:horriblename/hyprgrass";
    #   inputs.hyprland.follows = "hyprland"; # IMPORTANT
    # };
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
    # My secrets
    mysecrets = {
      url = "git+ssh://git@github.com/L-Trump/nixos-secrets.git?shallow=1";
      flake = false;
    };
    # My fonts
    myfonts = {
      url = "github:L-Trump/nixos-fonts?shallow=1";
      flake = false;
    };
    # Impermanence
    impermanence.url = "github:nix-community/impermanence";
    # generate iso/qcow2/docker/... image from nixos configuration
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    haumea = {
      url = "github:nix-community/haumea/v0.2.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # NixOS matlab wrapper
    nix-matlab = {
      url = "gitlab:doronbehar/nix-matlab";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Proxmox on NixOS
    proxmox-nixos = {
      url = "github:SaumonNet/proxmox-nixos";
      inputs.nixpkgs-unstable.follows = "nixpkgs";
    };
    # MicroVM
    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # NVIDIA patch
    nvidia-patch = {
      url = "github:icewind1991/nvidia-patch-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
