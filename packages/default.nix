{
  pkgs ? import <nixpkgs> {},
  pkgs-unstable  ? import <nixpkgs> {},
  pkgs-stable  ? import <nixpkgs> {},
  ...
}: let
  inherit (pkgs) lib libsForQt5 fetchFromGitHub;
in {
  wpsoffice-365 = libsForQt5.callPackage ./wpsoffice-365 {};

  edrawmax = libsForQt5.callPackage ./edrawmax {};
  edrawmax-cn = libsForQt5.callPackage ./edrawmax {
    useChineseVersion = true;
  };

  rustdesk-server-pro = pkgs.callPackage ./rustdesk-server-pro {};

  hubproxy = pkgs.callPackage ./hubproxy {};

  obs-studio-plugins =
    pkgs.obs-studio-plugins
    // {
      obs-nvfbc = pkgs.callPackage ./obs-nvfbc {};
    };

  niri = pkgs.niri.overrideAttrs (final: prev: {
    # TODO wait upstream merge  https://github.com/YaLTeR/niri/pull/1791
    patches = [
      (pkgs.fetchpatch {
        name = "niri-support-shm.patch";
        url = "https://github.com/wrvsrx/niri/compare/tag_support-shm-sharing~17..tag_support-shm-sharing.patch";
        hash = "sha256-aqsbn8iHtepiyG6dPVFvUt8qWWbvU+sZ6AGhQ8RYSko=";
      })
    ];
  });

  # Some package derived from unstable repo
  # siyuan = pkgs-unstable.siyuan;
  # easytier = pkgs-unstable.easytier;
  # niri = pkgs-unstable.niri;

  # siyuan = pkgs.callPackage ./siyuan {};
  # easytier = pkgs.callPackage ./easytier {};
  # siyuan = pkgs.callPackage ./siyuan {};
  # linuxPackages_latest = pkgs.linuxPackages_latest.extend (_: prev: {
  #   # ipu6-drivers = pkgs.linuxPackages_latest.callPackage ./ipu6-drivers {};
  #   ipu6-drivers = prev.ipu6-drivers.overrideAttrs (_: _: {
  #     src = fetchFromGitHub {
  #       owner = "intel";
  #       repo = "ipu6-drivers";
  #       rev = "69b2fde9edcbc24128b91541fdf2791fbd4bf7a4";
  #       hash = "sha256-uiRbbSw7tQ3Fn297D1I7i7hyaNtpOWER4lvPMSTpwpk=";
  #     };
  #   });
  # });
  # openvswitch = pkgs-stable.openvswitch.override {kernel = null;};
  # clouddrive2 = pkgs.callPackage ./clouddrive2 {};
  # snipaste = pkgs.callPackage ./snipaste {};
  # sunshine = pkgs.callPackage ./sunshine {};
  # nezha-agent = pkgs.callPackage ./nezha-agent {};
  # dbeaver-bin = pkgs-unstable.dbeaver-bin;
  # openlist = pkgs.callPackage ./openlist {};
  # xdg-desktop-portal-termfilechooser = pkgs.callPackage ./xdg-desktop-portal-termfilechooser {};
  # sctgdesk-server = pkgs.callPackage ./sctgdesk-server {};
  # wpsoffice-cn = libsForQt5.callPackage ./wpsoffice {
  #   useChineseVersion = true;
  # };
}
