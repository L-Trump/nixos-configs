{
  self,
  nixpkgs,
  mysecrets,
  ...
}@inputs:
let
  inherit (inputs.nixpkgs) lib;
  mylib = import ../lib { inherit lib; };
  vars = import ../vars { inherit lib; };
  secret-vars = import "${mysecrets}/vars" { inherit lib; };
  myvars = lib.recursiveUpdate vars secret-vars;
  mypresets = import ./config-presets { inherit lib; };

  # Add my custom lib, vars, nixpkgs instance, and all the inputs to specialArgs,
  # genSpecialArgs = { inherit mylib inputs nixpkgs; };
  genSpecialArgs =
    system:
    inputs
    // {
      inherit
        mylib
        myvars
        inputs
        genSpecialArgs
        ;

      # use unstable branch for some packages to get the latest updates
      pkgs-unstable = import inputs.nixpkgs-unstable {
        inherit system; # refer the `system` parameter form outer scope recursively
        # To use chrome, we need to allow the installation of non-free software
        config = myvars.nixpkgs-config;
      };
      pkgs-stable = import inputs.nixpkgs-stable {
        inherit system;
        # To use chrome, we need to allow the installation of non-free software
        config = myvars.nixpkgs-config;
      };
    };

  # This is the args for all the haumea modules in this folder.
  args = {
    inherit
      inputs
      lib
      mylib
      myvars
      mypresets
      genSpecialArgs
      ;
  };

  # modules for each supported system
  nixosSystems = {
    x86_64-linux = import ./x86_64-linux (args // { system = "x86_64-linux"; });
  };
  darwinSystems = { };
  allSystems = nixosSystems // darwinSystems;
  allSystemNames = builtins.attrNames allSystems;
  nixosSystemValues = builtins.attrValues nixosSystems;
  darwinSystemValues = builtins.attrValues darwinSystems;
  allSystemValues = nixosSystemValues ++ darwinSystemValues;

  # Helper function to generate a set of attributes for each system
  forAllSystems = func: (nixpkgs.lib.genAttrs allSystemNames func);

  # The hive in its raw form: `meta` plus one attribute per node.
  # Consumed both by the `colmena` output (legacy evaluation) and by
  # `colmena.lib.makeHive` (see the `colmenaHive` output).
  colmenaRaw = {
    meta =
      let
        system = "x86_64-linux";
      in
      {
        # default nixpkgs & specialArgs
        nixpkgs = import nixpkgs {
          inherit system;
          config = myvars.nixpkgs-config;
        };
        specialArgs = genSpecialArgs system;
        # per-node nixpkgs & specialArgs
        nodeNixpkgs = lib.attrsets.mergeAttrsList (
          map (it: it.colmenaMeta.nodeNixpkgs or { }) nixosSystemValues
        );
        nodeSpecialArgs = lib.attrsets.mergeAttrsList (
          map (it: it.colmenaMeta.nodeSpecialArgs or { }) nixosSystemValues
        );
      };
  }
  // lib.attrsets.mergeAttrsList (map (it: it.colmena or { }) nixosSystemValues);
in
{
  # Add attribute sets into outputs, for debugging
  debugAttrs = {
    inherit
      myvars
      nixosSystems
      darwinSystems
      allSystems
      allSystemNames
      ;
  };

  # NixOS Hosts
  nixosConfigurations = lib.attrsets.mergeAttrsList (
    map (it: it.nixosConfigurations or { }) nixosSystemValues
  );

  # Raw hive, kept for debugging and for `--legacy-flake-eval`.
  colmena = colmenaRaw;

  # Prepared hive required by Colmena >= 0.5's default (direct flake evaluation):
  # the CLI asserts `__schema == "v0.5"`, which only `colmena.lib.makeHive` sets.
  colmenaHive = inputs.colmena.lib.makeHive colmenaRaw;

  # MicroVM infras configs
  microvm-infras = lib.attrsets.mergeAttrsList (map (it: it.microvm-infras or { }) nixosSystemValues);

  # Packages
  packages = forAllSystems (
    system:
    let
      pkgs = nixpkgs.legacyPackages."${system}";
      pkgs-stable = inputs.nixpkgs-stable.legacyPackages."${system}";
      pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages."${system}";
    in
    (allSystems.${system}.packages or { })
    // (import ../packages {
      inherit
        pkgs
        pkgs-stable
        pkgs-unstable
        inputs
        ;
    })
  );

  # Eval Tests for all NixOS & darwin systems.
  evalTests = lib.lists.all (it: it.evalTests == { }) allSystemValues;

  # macOS Hosts
  darwinConfigurations = lib.attrsets.mergeAttrsList (
    map (it: it.darwinConfigurations or { }) darwinSystemValues
  );

  formatter = forAllSystems (system: nixpkgs.legacyPackages."${system}".nixfmt-tree);
}
