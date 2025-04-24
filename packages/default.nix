{
  pkgs ? import <nixpkgs> {},
  pkgs-unstable,
  pkgs-stable,
  inputs,
  ...
}: let
  inherit (pkgs) lib libsForQt5 fetchFromGitHub;
in {
  xdg-desktop-portal-termfilechooser = pkgs.callPackage ./xdg-desktop-portal-termfilechooser {};

  wpsoffice-cn = libsForQt5.callPackage ./wpsoffice {
    useChineseVersion = true;
  };
  wpsoffice-365 = libsForQt5.callPackage ./wpsoffice-365 {};

  edrawmax = libsForQt5.callPackage ./edrawmax {};
  edrawmax-cn = libsForQt5.callPackage ./edrawmax {
    useChineseVersion = true;
  };

  sctgdesk-server = pkgs.callPackage ./sctgdesk-server {};

  obs-studio-plugins =
    pkgs.obs-studio-plugins
    // {
      obs-nvfbc = pkgs.callPackage ./obs-nvfbc {};
    };

  # Some package derived from unstable repo
  # siyuan = pkgs-unstable.siyuan;
  # easytier = pkgs-unstable.easytier;

  # siyuan = pkgs.callPackage ./siyuan {};
  # easytier = pkgs.callPackage ./easytier {};
  # siyuan = pkgs.callPackage ./siyuan {};
  # linuxPackages_latest = pkgs.linuxPackages_latest.extend (_: prev: {
  #   ipu6-drivers = pkgs.linuxPackages_latest.callPackage ./ipu6-drivers {};
  #   ipu6-drivers = prev.ipu6-drivers.overrideAttrs (_: _: {
  #     src = fetchFromGitHub {
  #       owner = "intel";
  #       repo = "ipu6-drivers";
  #       rev = "7af071481f3d2d3cef1e70113c10f62ac6351723";
  #       hash = "sha256-pe7lqK+CHpgNWpC8GEZ3FKfYcuVuRUaWlW18D9AsrSk=";
  #     };
  #   });
  # });
  # openvswitch = pkgs-stable.openvswitch.override {kernel = null;};
  # clouddrive2 = pkgs.callPackage ./clouddrive2 {};
  # snipaste = pkgs.callPackage ./snipaste {};
  # sunshine = pkgs.callPackage ./sunshine {};
  # nezha-agent = pkgs.callPackage ./nezha-agent {};
}
