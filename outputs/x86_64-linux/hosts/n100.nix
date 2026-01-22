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
  name = "n100";
  tags = [
    name
    "all"
    "home"
  ];
  ssh-user = "root";

  preset = mypresets.server;
  myconfigs.mymodules = lib.recursiveUpdate preset.mymodules {
    virtualization = {
      qemu.enable = true;
      microvm.host = {
        enable = false;
        # infras = ["microvm-umy"];
      };
    };
    server = {
      juicefs.enable = true;
      redis.juicefs-meta = {
        enable = true;
        isSlave = true;
      };
      xpipe-webtop.enable = true;
      backrest.enable = true;
      syncthing.enable = true;
    };
  };
  myconfigs.myhome = lib.recursiveUpdate preset.myhome {
    tuiExtra = {
      enable = true;
      lsp.enable = true;
      # lsp.lang = ["all"];
    };
  };
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
      "hosts/${name}/home"
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
