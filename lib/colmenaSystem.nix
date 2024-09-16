# colmena - Remote Deployment via SSH
{
  lib,
  inputs,
  nixos-modules,
  home-modules ? [],
  myvars,
  system,
  tags,
  ssh-user,
  genSpecialArgs,
  specialArgs ? (genSpecialArgs system),
  myhome ? {},
  ...
}: let
  inherit (inputs) home-manager;
in
  {name, ...}: {
    deployment = {
      inherit tags;
      targetUser = ssh-user;
      targetHost = name; # hostName or IP address
    };

    imports =
      nixos-modules
      ++ (
        lib.optionals ((lib.lists.length home-modules) > 0)
        [
          home-manager.nixosModules.home-manager
          ({config, ...}: {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.extraSpecialArgs =
              specialArgs
              // {
                inherit myhome;
                systemConfig = config;
              };
            home-manager.users."${myvars.username}".imports = home-modules;
          })
        ]
      );
  }
