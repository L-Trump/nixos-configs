{
  inputs,
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

  hubproxy = pkgs.callPackage ./hubproxy { };

  niri = pkgs.niri.overrideAttrs (
    final: prev: {
      # TODO wait upstream merge  https://github.com/YaLTeR/niri/pull/1791
      patches = [
        (pkgs.fetchpatch {
          name = "niri-support-shm.patch";
          url = "https://github.com/wrvsrx/niri/compare/tag_support-shm-sharing_4~19..tag_support-shm-sharing_4.patch";
          hash = "sha256-mfX0CVJWSFb/Hr1lDvlggphpXc2PI6C5CBa+aGwkVIM=";
        })
      ];
    }
  );

  dbeaver-ultimate = pkgs.callPackage ./dbeaver-ultimate { };

  # TODO wait upstream merge https://github.com/NixOS/nixpkgs/pull/556768
  # 上游 7.15.1 的 rpm 已被 RealVNC 下架（只剩 8.x 的新路径），故本地跟 PR 打到 8.5.0。
  realvnc-vnc-viewer = pkgs.callPackage ./realvnc-vnc-viewer { };

  # rustdesk-flutter = pkgs-unstable.rustdesk-flutter;

  hokit = pkgs.callPackage ./hokit { };

  lossless-claw = pkgs.callPackage ./lossless-claw { };

  # TODO: wait upstream merge https://github.com/NixOS/nixpkgs/pull/553055
  mcporter = pkgs-unstable.mcporter;

  hdc = pkgs.callPackage ./hdc { };

  sidecar = pkgs.callPackage ./sidecar { };

  td = pkgs.callPackage ./td { };

  # intel-graphics-compiler =  pkgs-unstable.intel-graphics-compiler;
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
}
