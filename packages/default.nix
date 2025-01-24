{
  pkgs ? import <nixpkgs> {},
  pkgs-unstable,
  ...
}: let
  inherit (pkgs) lib libsForQt5;
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

  # TODO wait upstream merge https://nixpk.gs/pr-tracker.html?pr=375153
  sunshine = pkgs.callPackage ./sunshine {};

  # Some package derived from unstable repo
  siyuan = pkgs-unstable.siyuan;
  # easytier = pkgs-unstable.easytier;

  # siyuan = pkgs.callPackage ./siyuan {};
  easytier = pkgs.callPackage ./easytier {}; # TODO wait upstream merge https://nixpk.gs/pr-tracker.html?pr=376259
  # siyuan = pkgs.callPackage ./siyuan {};
  # linuxPackages_latest = pkgs.linuxPackages_latest.extend (_: _: {
  #   ipu6-drivers = pkgs.linuxPackages_latest.callPackage ./ipu6-drivers {};
  # });
  # openvswitch = pkgs-stable.openvswitch.override {kernel = null;};
  # clouddrive2 = pkgs.callPackage ./clouddrive2 {};
  # snipaste = pkgs.callPackage ./snipaste {};
}
