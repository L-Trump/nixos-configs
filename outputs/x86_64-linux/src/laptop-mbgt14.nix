{
  # NOTE: the args not used in this file CAN NOT be removed!
  # because haumea pass argument lazily,
  # and these arguments are used in the functions like `mylib.nixosSystem`, `mylib.colmenaSystem`, etc.
  inputs
, lib
, myvars
, mylib
, system
, genSpecialArgs
, ...
} @ args:

let
  # Huawei Matebook-GT14
  name = "matebook-gt14";
  dname = "matebook-gt14";
  base-modules = {
    nixos-modules = map mylib.relativeToRoot [
      # common
      "secrets/default.nix"
      "modules/nixos/desktop.nix"
      # host specific
      "secrets/hosts/${dname}"
      "hosts/${dname}"
    ];
    home-modules = map mylib.relativeToRoot [
      # common
      "secrets/home.nix"
      "home/default.nix"
      # host specific
      "hosts/${dname}/home.nix"
    ];
  };

  modules-hyprland = {
    nixos-modules =
      [
        {
          modules.desktop.wayland.enable = true;
        }
      ]
      ++ base-modules.nixos-modules;
    home-modules =
      [
        { modules.desktop.hyprland.enable = true; }
      ]
      ++ base-modules.home-modules;
  };
in
{
  nixosConfigurations = {
    # host with hyprland compositor
    "${name}" = mylib.nixosSystem (base-modules // args);
  };

  # generate iso image for hosts with desktop environment
  # packages = {
  #   "${name}" = inputs.self.nixosConfigurations."${name}".config.formats.iso;
  # };

  # packages."${system}" = import ./packages { inherit pkgs; };
  # nixosConfigurations.ltrumpNixOS = nixpkgs.lib.nixosSystem {
  #   inherit system;
  #   specialArgs = genSpecialArgs;
  #   modules = [
  #     home-manager.nixosModules.home-manager
  #     {
  #       home-manager.useGlobalPkgs = true;
  #       home-manager.useUserPackages = true;
  #       home-manager.users.ltrump = {
  #       };
  #       home-manager.sharedModules = [
  #       ];
  #       home-manager.extraSpecialArgs = genSpecialArgs;
  #     }
  #   ];
  # };
}
