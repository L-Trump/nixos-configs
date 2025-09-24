{
  # NOTE: the args not used in this file CAN NOT be removed!
  # because haumea pass argument lazily,
  # and these arguments are used in the functions like `mylib.nixosSystem`, `mylib.colmenaSystem`, etc.
  inputs,
  lib,
  myvars,
  mypresets,
  mylib,
  system,
  genSpecialArgs,
  ...
}@args:
let
  # Huawei Matebook-GT14
  name = "matebook-gt14";
  dname = "matebook-gt14";
  preset = mypresets.daily;
  myconfigs.mymodules = lib.recursiveUpdate preset.mymodules {
    server = {
      juicefs.enable = true;
      kopia-server.enable = false;
      backrest.enable = true;
      openlist.enable = false;
      nezha-agent.enable = true;
    };
  };
  myconfigs.myhome = preset.myhome;
  modules = {
    nixos-modules = map mylib.relativeToRoot [
      # common
      "secrets/modules"
      "modules/nixos/default.nix"
      # host specific
      "hosts/${dname}/modules"
    ];
    home-modules = map mylib.relativeToRoot [
      # common
      "home/default.nix"
      "secrets/home"
      # host specific
      "hosts/${dname}/home"
    ];
  };
  systemArgs = modules // args // myconfigs;
in
{
  nixosConfigurations = {
    # host with hyprland compositor
    "${name}" = mylib.nixosSystem systemArgs;
  };
}
