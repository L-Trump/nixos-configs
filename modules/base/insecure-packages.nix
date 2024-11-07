{
  nixpkgs.config.permittedInsecurePackages = [
    # "electron-27.3.11" # deps for logseq
    # "openssl-1.1.1w"
    # "nix-2.24.5"
    "electron-30.5.1" # deps for lx-music-desktop
  ];
}
