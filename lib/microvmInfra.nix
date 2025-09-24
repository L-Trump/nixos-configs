# microvm - a lightweight virtual machines tool
{
  inputs,
  lib,
  nixos-modules,
  home-modules ? [ ],
  myvars,
  system,
  genSpecialArgs,
  targetSystem ? system,
  specialArgs ? (genSpecialArgs targetSystem),
  mymodules ? { },
  myhome ? { },
  ...
}:
let
  inherit (inputs) home-manager;
  spArgs = specialArgs // {
    inherit mymodules myhome;
  };
in
{
  restartIfChanged = false;
  pkgs = import inputs.nixpkgs {
    system = targetSystem;
    config = myvars.nixpkgs-config;
  };
  specialArgs = spArgs;
  config.imports =
    nixos-modules
    ++ (lib.optionals ((lib.lists.length home-modules) > 0) [
      home-manager.nixosModules.home-manager
      (
        { config, ... }:
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = spArgs;
          home-manager.users."${myvars.username}".imports = home-modules;
        }
      )
    ]);
}
