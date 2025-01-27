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
    ++ lib.optional (rawcfg.desktop.enable) ./desktop
    ++ lib.optional (rawcfg.virtualization.docker.enable) ./containers;

  mymodules = rawcfg;
}
