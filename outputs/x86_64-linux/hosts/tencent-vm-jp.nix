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
  name = "tencent-vm-jp";
  tags = [
    name
    "vm-jp"
    # "all"
    # "vps"
  ];
  ssh-user = "root";

  preset = mypresets.server;
  myconfigs.mymodules = lib.recursiveUpdate preset.mymodules {
    server = {
      juicefs.enable = true;
      redis.juicefs-meta = {
        enable = true;
        isSlave = true;
      };
    };
  };
  myconfigs.myhome = preset.myhome;
  modules = {
    nixos-modules = map mylib.relativeToRoot [
      # common
      "secrets/modules"
      "modules/nixos/default.nix"
      # host specific
      "hosts/${name}/modules"
    ];
    home-modules = map mylib.relativeToRoot [
      # common
      "home/default.nix"
      "secrets/home"
    ];
  };

  systemArgs = modules // args // myconfigs;
in
{
  nixosConfigurations."${name}" = mylib.nixosSystem systemArgs;

  colmena."${name}" = mylib.colmenaSystem (systemArgs // { inherit tags ssh-user; });

  colmenaMeta = {
    nodeNixpkgs."${name}" = import inputs.nixpkgs {
      inherit system;
      config = myvars.nixpkgs-config;
    };
    nodeSpecialArgs."${name}" = { inherit (myconfigs) mymodules; };
  };
}
