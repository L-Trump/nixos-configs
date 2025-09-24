{
  mylib,
  lib,
  myhome,
  ...
}:
let
  rawcfg = myhome.desktop.daily;
in
{
  imports = lib.optionals rawcfg.enable (mylib.scanPaths ./.);
}
