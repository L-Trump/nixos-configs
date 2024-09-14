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
    inputs.nur.overlay
    inputs.hyprland.overlays.default
    # inputs.helix-driver.overlays.default
  ];
}
