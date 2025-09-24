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
  name = "iso";
  dname = "iso";
  preset = mypresets.bare;
  myconfigs.mymodules = lib.recursiveUpdate preset.mymodules {
    desktop = {
      enable = true;
      niri.enable = true;
      keyremap.enable = true;
    };
    server = {
      easytier.enable = true;
    };
  };
  myconfigs.myhome = lib.recursiveUpdate preset.myhome {
    desktop = {
      enable = true;
      niri.enable = true;
    };
  };
  base-modules = {
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
    ];
  };
in
{
  nixosConfigurations = {
    # host with hyprland compositor
    "${name}" = mylib.nixosSystem (base-modules // args // myconfigs);
  };

  # generate iso image for hosts with desktop environment
  packages = {
    "${name}" = inputs.self.nixosConfigurations."${name}".config.formats.iso;
  };
}
