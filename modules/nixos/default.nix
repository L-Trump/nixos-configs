{
  config,
  lib,
  mymodules,
  ...
} @ args:
with lib; let
  rawcfg = mymodules;
in {
  imports =
    [
      ./base
      ../base
      ../options.nix
    ]
    ++ lib.optional (rawcfg.desktop.enable) ./desktop;

  mymodules = rawcfg;
}
