{ inputs, ... }:
{
  nixpkgs.overlays = [
    # overlays
    inputs.nur.overlays.default
    # inputs.hyprland.overlays.default
    inputs.nix-matlab.overlay
    # inputs.helix-driver.overlays.default
    (final: prev: {
      nur-xddxdd = inputs.nur-xddxdd.overlays.default final prev;
    })
  ];
}
