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
  name = "n100";
  dname = "n100";
  myconfigs.mymodules = {
    visualization = {
      enable = true;
      docker.enable = true;
      qemu.enable = true;
    };
    desktop = {
      enable = false;
      animeboot.enable = false;
      wayland.enable = false;
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
      # lsp.lang = ["all"];
    };
    desktop = {
      enable = false;
      wayland.enable = false;
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
}
