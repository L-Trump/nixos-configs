{
  config,
  pkgs,
  lib,
  ...
}: {
  nixpkgs.overlays = [
    (final: prev: let
      nameValuePair = n: v: {
        name = n;
        value = v;
      };
      pkgAttrs = import ../packages {pkgs = prev;};
    in
      builtins.listToAttrs (map (n: nameValuePair n pkgAttrs.${n}) (builtins.attrNames pkgAttrs)))
  ];
}
