{ pkgs, mylib, ... }:

{
  imports = mylib.scanPaths ./.;
}
