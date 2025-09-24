{
  # NOTE: the args not used in this file CAN NOT be removed!
  # because haumea pass argument lazily,
  # and these arguments are used in the functions like `mylib.nixosSystem`, `mylib.colmenaSystem`, etc.
  inputs,
  lib,
  myvars,
  mylib,
  mypresets,
  system,
  genSpecialArgs,
  ...
}@args:
let
  name = "microvm-umy";
  tags = [ name ];
  ssh-user = "root";

  preset = lib.recursiveUpdate mypresets.daily {
    mymodules.virtualization.microvm.guest.enable = true;
  };
  myconfigs.mymodules = preset.mymodules;
  myconfigs.myhome = preset.myhome;
  infra-configs.mymodules = lib.recursiveUpdate preset.mymodules {
    virtualization.microvm.guest.isInfra = true;
  };
  infra-configs.myhome = preset.myhome;
  modules = {
    nixos-modules = map mylib.relativeToRoot [
      # common
      "secrets/modules"
      "modules/nixos/default.nix"
      # host specific
      "hosts/microvms/${name}/modules"
    ];
    home-modules = map mylib.relativeToRoot [
      # common
      "home/default.nix"
      "secrets/home"
      # host specific
      "hosts/microvms/${name}/home"
    ];
  };
  infra-modules = modules;

  systemArgs = modules // args // myconfigs;
  infraArgs = infra-modules // args // infra-configs;
in
{
  nixosConfigurations."${name}" = mylib.nixosSystem systemArgs;

  microvm-infras."${name}" = mylib.microvmInfra infraArgs;

  packages = {
    "${name}" = inputs.self.nixosConfigurations."${name}".config.microvm.declaredRunner;
  };

  colmena."${name}" = mylib.colmenaSystem (systemArgs // { inherit tags ssh-user; });

  colmenaMeta = {
    nodeNixpkgs."${name}" = import inputs.nixpkgs {
      inherit system;
      config = myvars.nixpkgs-config;
    };
    nodeSpecialArgs."${name}" = { inherit (myconfigs) mymodules myhome; };
  };
}
