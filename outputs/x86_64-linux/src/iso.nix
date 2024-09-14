{
  # NOTE: the args not used in this file CAN NOT be removed!
  # because haumea pass argument lazily,
  # and these arguments are used in the functions like `mylib.nixosSystem`, `mylib.colmenaSystem`, etc.
  inputs,
  lib,
  myvars,
  mylib,
  system,
  genSpecialArgs,
  ...
} @ args: let
  # Huawei Matebook-GT14
  name = "iso";
  dname = "iso";
  myconfigs.mymodules = {
    visualization = {
      enable = false;
    };
    desktop = {
      enable = true;
      animeboot.enable = false;
      wayland.enable = true;
      xorg.enable = false;
      game.enable = false;
      keyremap.enable = true;
    };
  };
  myconfigs.myhome = {
    tuiExtra = {
      enable = true;
      mail.enable = false;
      lsp.enable = true;
    };
    desktop = {
      enable = true;
      wayland.enable = true;
      xorg.enable = false;
      daily.enable = false;
      daily.game.enable = false;
    };
  };
  base-modules = {
    nixos-modules = map mylib.relativeToRoot [
      # common
      "secrets/default.nix"
      "modules/nixos/default.nix"
      # host specific
      "hosts/${dname}/modules"
    ];
    home-modules = map mylib.relativeToRoot [
      # common
      "home/default.nix"
      "secrets/home.nix"
    ];
  };
in {
  nixosConfigurations = {
    # host with hyprland compositor
    "${name}" = mylib.nixosSystem (base-modules // args // myconfigs);
  };

  # generate iso image for hosts with desktop environment
  packages = {
    "${name}" = inputs.self.nixosConfigurations."${name}".config.formats.iso;
  };
}
