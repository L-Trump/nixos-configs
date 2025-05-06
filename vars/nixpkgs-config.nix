_: {
  allowUnfree = true;
  permittedInsecurePackages = [
    # "electron-27.3.11" # deps for logseq
    # "openssl-1.1.1w"
    # "nix-2.24.5"
    "electron-32.3.3" # deps for lx-music-desktop
    "clash-verge-rev-2.2.3" # TODO wait fix
    "clash-verge-rev-unwrapped-2.2.3"
    "clash-verge-rev-webui-2.2.3"
    "clash-verge-rev-service-2.2.3"
  ];
}
