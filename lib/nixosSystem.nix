{
  inputs,
  lib,
  system,
  genSpecialArgs,
  nixos-modules,
  home-modules ? [ ],
  specialArgs ? (genSpecialArgs system),
  mymodules ? { },
  myhome ? { },
  myvars,
  ...
}:
let
  inherit (inputs) nixpkgs home-manager nixos-generators;
  spArgs = specialArgs // {
    inherit mymodules myhome;
  };
in
nixpkgs.lib.nixosSystem {
  inherit system;
  specialArgs = spArgs;
  modules =
    nixos-modules
    ++ [
      nixos-generators.nixosModules.all-formats
    ]
    ++ (lib.optionals ((lib.lists.length home-modules) > 0) [
      home-manager.nixosModules.home-manager
      (
        { config, ... }:
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = spArgs // {
            systemConfig = config;
          };
          home-manager.users."${myvars.username}".imports = home-modules;
        }
      )
    ]);
}
