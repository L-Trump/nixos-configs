{
  inputs,
  config,
  mymodules,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.mymodules.virtualization;
  rawcfg = mymodules.virtualization;
in
{
  imports = [
    inputs.microvm.nixosModules.host
  ]
  ++ (lib.optional (
    rawcfg.microvm.guest.enable && !rawcfg.microvm.guest.isInfra
  ) inputs.microvm.nixosModules.microvm);

  nixpkgs.config = lib.mkIf cfg.microvm.guest.enable (lib.mkForce { });
  nix.settings.auto-optimise-store = lib.mkIf cfg.microvm.guest.enable (lib.mkForce false);

  microvm = lib.mkMerge [
    (lib.mkIf (!cfg.enable || !cfg.microvm.host.enable) { host.enable = false; })
    (lib.mkIf (cfg.enable && cfg.microvm.host.enable) {
      host.enable = true;
      vms = lib.genAttrs cfg.microvm.host.infras (name: inputs.self.microvm-infras."${name}");
    })
  ];
}
