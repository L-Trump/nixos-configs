{
  self,
  nixpkgs,
  ...
} @ inputs: let
  inherit (inputs.nixpkgs) lib;
  mylib = import ../lib {inherit lib;};
  myvars = import ../vars {inherit lib;};

  # Add my custom lib, vars, nixpkgs instance, and all the inputs to specialArgs,
  # genSpecialArgs = { inherit mylib inputs nixpkgs; };
  genSpecialArgs = system:
    inputs
    // {
      inherit mylib myvars inputs;

      # use unstable branch for some packages to get the latest updates
      pkgs-unstable = import inputs.nixpkgs-unstable {
        inherit system; # refer the `system` parameter form outer scope recursively
        # To use chrome, we need to allow the installation of non-free software
        config.allowUnfree = true;
      };
      pkgs-stable = import inputs.nixpkgs-stable {
        inherit system;
        # To use chrome, we need to allow the installation of non-free software
        config.allowUnfree = true;
        config.permittedInsecurePackages = [
          "electron-27.3.11" # deps for logseq
        ];
      };
    };

  # This is the args for all the haumea modules in this folder.
  args = {inherit inputs lib mylib myvars genSpecialArgs;};

  # modules for each supported system
  nixosSystems = {
    x86_64-linux = import ./x86_64-linux (args // {system = "x86_64-linux";});
  };
  darwinSystems = {};
  allSystems = nixosSystems // darwinSystems;
  allSystemNames = builtins.attrNames allSystems;
  nixosSystemValues = builtins.attrValues nixosSystems;
  darwinSystemValues = builtins.attrValues darwinSystems;
  allSystemValues = nixosSystemValues ++ darwinSystemValues;

  # Helper function to generate a set of attributes for each system
  forAllSystems = func: (nixpkgs.lib.genAttrs allSystemNames func);
in {
  # Add attribute sets into outputs, for debugging
  debugAttrs = {inherit myvars nixosSystems darwinSystems allSystems allSystemNames;};

  # NixOS Hosts
  nixosConfigurations =
    lib.attrsets.mergeAttrsList (map (it: it.nixosConfigurations or {}) nixosSystemValues);

  colmena =
    {
      meta = let
        system = "x86_64-linux";
      in {
        # default nixpkgs & specialArgs
        nixpkgs = import nixpkgs {inherit system;};
        specialArgs = genSpecialArgs system;
        # per-node nixpkgs & specialArgs
        nodeNixpkgs = lib.attrsets.mergeAttrsList (map (it: it.colmenaMeta.nodeNixpkgs or {}) nixosSystemValues);
        nodeSpecialArgs = lib.attrsets.mergeAttrsList (map (it: it.colmenaMeta.nodeSpecialArgs or {}) nixosSystemValues);
      };
    }
    // lib.attrsets.mergeAttrsList (map (it: it.colmena or {}) nixosSystemValues);

  # Packages
  packages = forAllSystems (
    system: let
      pkgs = nixpkgs.legacyPackages."${system}";
      pkgs-stable = inputs.nixpkgs-stable.legacyPackages."${system}";
      pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages."${system}";
    in
      (allSystems.${system}.packages or {})
      // (
        import ../packages {inherit pkgs pkgs-stable pkgs-unstable;}
      )
  );

  # Eval Tests for all NixOS & darwin systems.
  evalTests = lib.lists.all (it: it.evalTests == {}) allSystemValues;

  # macOS Hosts
  darwinConfigurations =
    lib.attrsets.mergeAttrsList (map (it: it.darwinConfigurations or {}) darwinSystemValues);

  # Format the nix code in this flake
  formatter = forAllSystems (
    # alejandra is a nix formatter with a beautiful output
    system: nixpkgs.legacyPackages.${system}.alejandra
  );
}
