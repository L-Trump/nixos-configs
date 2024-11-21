{
  pkgs ? import <nixpkgs> {},
  pkgs-stable,
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

  # TODO wait upstream merge https://nixpk.gs/pr-tracker.html?pr=357032
  siyuan = pkgs.callPackage ./siyuan {};

  # TODO wait upstream merge https://nixpk.gs/pr-tracker.html?pr=357050
  linuxPackages_latest = pkgs.linuxPackages_latest.extend (_: _: {
    ipu6-drivers = pkgs.linuxPackages_latest.callPackage ./ipu6-drivers {};
  });

  # openvswitch = pkgs-stable.openvswitch.override {kernel = null;};
  # easytier = pkgs.callPackage ./easytier {};
  # clouddrive2 = pkgs.callPackage ./clouddrive2 {};
  # snipaste = pkgs.callPackage ./snipaste {};
}
