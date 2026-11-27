{
  description = "LTrump's NixOS flake";

  outputs = inputs: import ./outputs inputs;

  inputs = {
    # Official NixOS package source, using nixos's unstable branch by default
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";

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
    # xddxdd packages, for qq/wechat
    # nur-xddxdd = {
    #   url = "github:xddxdd/nur-packages";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
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
    # Fcitx5 voice input (cloud ASR only, i.e. the "lite" build).
    fcitx5-vinput = {
      url = "github:xifan2333/fcitx5-vinput";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # My secrets
    mysecrets = {
      url = "git+ssh://git@github.com/L-Trump/nixos-secrets.git?shallow=1";
      flake = false;
    };
    # My fonts
    myfonts = {
      url = "git+https://github.com/L-Trump/nixos-fonts.git?shallow=1";
      flake = false;
    };
    # My wallpapers
    mywallpapers = {
      url = "git+https://github.com/L-Trump/nixos-wallpapers.git?shallow=1";
      flake = false;
    };
    # Impermanence
    impermanence.url = "github:nix-community/impermanence";

    colmena = {
      url = "github:nix-community/colmena";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.stable.follows = "nixpkgs-stable";
    };

    # Niri use git version
    niri-flake = {
      url = "github:epireyn/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
    };

    # Dux Modular Shell
    dms = {
      url = "github:duxlabs-dev/dux-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # DMS Plugins
    dms-plugin-registry = {
      url = "github:duxlabs-dev/dux-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    haumea = {
      url = "github:nix-community/haumea/v0.2.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixOS matlab wrapper
    # nix-matlab = {
    #   url = "gitlab:doronbehar/nix-matlab";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # Proxmox on NixOS
    proxmox-nixos = {
      url = "github:SaumonNet/proxmox-nixos";
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

    # Authentik-Nix
    authentik-nix = {
      url = "github:nix-community/authentik-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # VSCode Extensions (from community)
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Nix OpenClaw
    nix-openclaw = {
      # my fork
      url = "github:L-Trump/nix-openclaw";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    # OpenViking context database
    openviking = {
      url = "github:Daaboulex/openviking-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # noVNC (static web frontend for websockify)
    novnc = {
      url = "github:novnc/noVNC";
      flake = false;
    };
  };
}
