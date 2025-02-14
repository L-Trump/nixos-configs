{
  pkgs ? import <nixpkgs> {},
  pkgs-unstable,
  ...
}: let
  inherit (pkgs) lib libsForQt5 fetchFromGitHub;
in {
  xdg-desktop-portal-termfilechooser = pkgs.callPackage ./xdg-desktop-portal-termfilechooser {};

  wpsoffice-cn = libsForQt5.callPackage ./wpsoffice {
    useChineseVersion = true;
  };
  wpsoffice-365 = libsForQt5.callPackage ./wpsoffice {
    use365Version = true;
  };

  edrawmax = libsForQt5.callPackage ./edrawmax {};
  edrawmax-cn = libsForQt5.callPackage ./edrawmax {
    useChineseVersion = true;
  };

  nezha-agent = pkgs.callPackage ./nezha-agent {};

  sctgdesk-server = pkgs.callPackage ./sctgdesk-server {};

  # Some package derived from unstable repo
  # siyuan = pkgs-unstable.siyuan;
  easytier = pkgs-unstable.easytier;

  # TODO wait fix https://github.com/NixOS/nixpkgs/issues/381521
  tela-icon-theme = pkgs.tela-icon-theme.overrideAttrs {
    dontCheckForBrokenSymlinks = true;
  };

  siyuan = pkgs.callPackage ./siyuan {};  # TODO wait r-ryantm update
  # easytier = pkgs.callPackage ./easytier {};
  # siyuan = pkgs.callPackage ./siyuan {};
  linuxPackages_latest = pkgs.linuxPackages_latest.extend (_: prev: {
    # ipu6-drivers = pkgs.linuxPackages_latest.callPackage ./ipu6-drivers {};
    ipu6-drivers = prev.ipu6-drivers.overrideAttrs (_: _: {
      src = fetchFromGitHub {
        owner = "intel";
        repo = "ipu6-drivers";
        rev = "e2136ae84dac25d6e0be071bda460d852bb975d1";
        hash = "sha256-HLo3gC61+nRUMzonc3d5uwy+OmWQMQkLAGj15Ynbcoc=";
      };
    });
  });
  # openvswitch = pkgs-stable.openvswitch.override {kernel = null;};
  # clouddrive2 = pkgs.callPackage ./clouddrive2 {};
  # snipaste = pkgs.callPackage ./snipaste {};
  # sunshine = pkgs.callPackage ./sunshine {};
}
