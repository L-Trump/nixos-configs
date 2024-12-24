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

  # TODO Wait upstream merge, https://nixpk.gs/pr-tracker.html?pr=362889
  siyuan = pkgs.callPackage ./siyuan {};

  # TODO Wait upstream merge, https://nixpk.gs/pr-tracker.html?pr=367097
  easytier = pkgs.callPackage ./easytier {};

  # linuxPackages_latest = pkgs.linuxPackages_latest.extend (_: _: {
  #   ipu6-drivers = pkgs.linuxPackages_latest.callPackage ./ipu6-drivers {};
  # });
  # openvswitch = pkgs-stable.openvswitch.override {kernel = null;};
  # clouddrive2 = pkgs.callPackage ./clouddrive2 {};
  # snipaste = pkgs.callPackage ./snipaste {};
}
