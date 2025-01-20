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
  name = "matebook-gt14";
  dname = "matebook-gt14";
  myconfigs.mymodules = {
    virtualization = {
      enable = true;
      docker.enable = true;
      qemu.enable = false;
    };
    desktop = {
      enable = true;
      animeboot.enable = true;
      wayland.enable = true;
      xorg.enable = true;
      game.enable = false;
      keyremap.enable = true;
      remote-desktop.sunshine.enable = true;
    };
    server = {
      easytier.enable = true;
    };
  };
  myconfigs.myhome = {
    tuiExtra = {
      enable = true;
      mail.enable = true;
      lsp.enable = true;
      lsp.lang = ["all"];
    };
    desktop = {
      enable = true;
      wayland.enable = true;
      xorg.enable = true;
      daily.enable = true;
      daily.game.enable = false;
    };
  };
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
in {
  nixosConfigurations = {
    # host with hyprland compositor
    "${name}" = mylib.nixosSystem systemArgs;
  };
}
