{
  lib,
  mymodules,
  ...
}: let
  rawcfg = mymodules;
in {
  imports =
    [
      ./base
      ./extras
      ../base
      ../options.nix
    ]
    ++ lib.optional (rawcfg.desktop.enable) ./desktop;

  mymodules = rawcfg;
}
