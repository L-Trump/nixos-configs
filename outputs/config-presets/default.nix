{ lib }:
{
  bare = import ./bare.nix { inherit lib; };
  daily = import ./daily.nix { inherit lib; };
  server = import ./server.nix { inherit lib; };
}
