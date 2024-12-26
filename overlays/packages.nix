{
  config,
  pkgs,
  pkgs-stable,
  pkgs-unstable,
  lib,
  ...
}: {
  nixpkgs.overlays = [
    (final: prev: let
      nameValuePair = n: v: {
        name = n;
        value = v;
      };
      pkgAttrs = import ../packages {
        inherit pkgs-stable pkgs-unstable;
        pkgs = prev;
      };
    in
      builtins.listToAttrs (map (n: nameValuePair n pkgAttrs.${n}) (builtins.attrNames pkgAttrs)))
  ];
}
