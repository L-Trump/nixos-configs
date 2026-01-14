{
  pkgs ? import <nixpkgs> { },
  pkgs-unstable ? import <nixpkgs> { },
  pkgs-stable ? import <nixpkgs> { },
  ...
}:
let
  inherit (pkgs) lib libsForQt5 fetchFromGitHub;
in
{
  wpsoffice-365 = libsForQt5.callPackage ./wpsoffice-365 { };

  edrawmax = libsForQt5.callPackage ./edrawmax { };
  edrawmax-cn = libsForQt5.callPackage ./edrawmax {
    useChineseVersion = true;
  };

  rustdesk-server-pro = pkgs.callPackage ./rustdesk-server-pro { };

  canokey-manager = pkgs.callPackage ./canokey-manager { };

  hubproxy = pkgs.callPackage ./hubproxy { };

  # vaultwarden = pkgs.callPackage ./vaultwarden-unstable { };

  obs-studio-plugins = pkgs.obs-studio-plugins // {
    obs-nvfbc = pkgs.callPackage ./obs-nvfbc { };
  };

  niri = pkgs.niri.overrideAttrs (
    final: prev: {
      # TODO wait upstream merge  https://github.com/YaLTeR/niri/pull/1791
      patches = [
        (pkgs.fetchpatch {
          name = "niri-support-shm.patch";
          url = "https://github.com/wrvsrx/niri/compare/tag_support-shm-sharing_2~19..tag_support-shm-sharing_2.patch";
          hash = "sha256-M2Z2HMwuJpDtk7bvvREXF21cHVra+qqUUeaKCywLt48=";
        })
      ];
    }
  );

  dbeaver-agent = pkgs.callPackage ./dbeaver-agent { };
  dbeaver-ultimate = pkgs.callPackage ./dbeaver-ultimate { };

  rustdesk-flutter = pkgs-unstable.rustdesk-flutter; # TODO wait upstream merge 461661

  # Some package derived from unstable repo
  # siyuan = pkgs-unstable.siyuan;
  # easytier = pkgs-unstable.easytier;
  # niri = pkgs-unstable.niri;

  # intel-graphics-compiler =  pkgs-unstable.intel-graphics-compiler;
  # siyuan = pkgs.callPackage ./siyuan {};
  # easytier = pkgs.callPackage ./easytier { };
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
