{pkgs ? import <nixpkgs> {}, ...}: let
  inherit (pkgs) lib libsForQt5;
in {
  xdg-desktop-portal-termfilechooser = pkgs.callPackage ./xdg-desktop-portal-termfilechooser {};
  wpsoffice-cn = libsForQt5.callPackage ./wpsoffice-cn {};
  # openvswitch = pkgs.openvswitch.override {kernel = null;};
  # easytier = pkgs.callPackage ./easytier {};
  clouddrive2 = pkgs.callPackage ./clouddrive2 {};
  # snipaste = pkgs.callPackage ./snipaste {};
}
