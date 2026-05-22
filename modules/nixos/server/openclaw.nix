{
  config,
  lib,
  inputs,
  pkgs,
  mymodules,
  ...
}:
let
  cfg = config.mymodules.server.openclaw;
  rawcfg = mymodules.server.openclaw;
in
{
  imports = lib.optionals rawcfg.enable [
    inputs.nix-openclaw.nixosModules.openclaw-gateway
  ];

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [
      inputs.nix-openclaw.overlays.default
    ];

    nix.settings = {
      substituters = [ "https://cache.garnix.io" ];
      trusted-public-keys = [ "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=" ];
    };

    environment.systemPackages = [
      pkgs.openclawPackages.openclaw
    ];
  };
}
