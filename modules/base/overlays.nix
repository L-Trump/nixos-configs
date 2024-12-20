{inputs, ...}: {
  imports = [
    # XDDXDD overlay
    inputs.nur-xddxdd.nixosModules.setupOverlay
    # XDDXDD cache substituter
    inputs.nur-xddxdd.nixosModules.nix-cache-attic
    # Overlays
    ../../overlays
  ];

  nixpkgs.overlays = [
    inputs.nur.overlays.default
    # inputs.hyprland.overlays.default
    inputs.nix-matlab.overlay
    # inputs.helix-driver.overlays.default
  ];
}
