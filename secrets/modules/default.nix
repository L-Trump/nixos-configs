{
  mylib,
  inputs,
  ...
}:
{
  imports = [
    inputs.agenix.nixosModules.default
  ]
  ++ mylib.scanPaths ./.;

  nixpkgs.overlays = [
    inputs.agenix.overlays.default
  ];
}
