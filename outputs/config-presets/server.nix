{ lib, ... }:
let
  bare = import ./bare.nix { inherit lib; };
in
lib.recursiveUpdate bare {
  mymodules = {
    virtualization = {
      enable = true;
      docker.enable = true;
    };
    server = {
      nezha-agent.enable = true;
      easytier.enable = true;
    };
  };
}
