{ mylib, ... }:

{
  imports = mylib.scanPaths ./.;
}