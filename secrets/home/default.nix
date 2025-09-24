{
  mylib,
  inputs,
  ...
}:
{
  imports = [
    inputs.agenix.homeManagerModules.default
  ]
  ++ mylib.scanPaths ./.;
}
