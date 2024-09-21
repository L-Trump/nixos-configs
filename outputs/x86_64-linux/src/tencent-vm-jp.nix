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
  name = "tencent-vm-jp";
  tags = [name "vm-jp"];
  ssh-user = "root";

  myconfigs.mymodules = {
    virtualization = {
      enable = true;
      docker.enable = true;
      qemu.enable = false;
    };
    desktop = {
      enable = false;
      animeboot.enable = false;
      wayland.enable = false;
      xorg.enable = false;
      game.enable = false;
      keyremap.enable = false;
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
  modules = {
    nixos-modules = map mylib.relativeToRoot [
      # common
      "secrets/default.nix"
      "modules/nixos/default.nix"
      # host specific
      "hosts/${name}/modules"
    ];
    home-modules = map mylib.relativeToRoot [
      # common
      "home/default.nix"
      "secrets/home.nix"
    ];
  };

  systemArgs = modules // args // myconfigs;
in {
  nixosConfigurations."${name}" = mylib.nixosSystem systemArgs;

  colmena."${name}" =
    mylib.colmenaSystem (systemArgs // {inherit tags ssh-user;});

  colmenaMeta = {
    nodeNixpkgs."${name}" = import inputs.nixpkgs {inherit system;};
    nodeSpecialArgs."${name}" = {inherit (myconfigs) mymodules;};
  };
}
