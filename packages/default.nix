{
  inputs,
  pkgs ? import <nixpkgs> { },
  pkgs-unstable ? import <nixpkgs> { },
  pkgs-stable ? import <nixpkgs> { },
  ...
}:
let
  inherit (pkgs) lib libsForQt5 fetchFromGitHub;

  # DRM/KMS backend for rustdesk
  libdrmtap = pkgs.callPackage ./libdrmtap { };
in
{
  wpsoffice-365 = libsForQt5.callPackage ./wpsoffice-365 { };

  edrawmax = libsForQt5.callPackage ./edrawmax { };
  edrawmax-cn = libsForQt5.callPackage ./edrawmax {
    useChineseVersion = true;
  };

  lceda-pro = pkgs.callPackage ./lceda-pro { };

  rustdesk-server-pro = pkgs.callPackage ./rustdesk-server-pro { };

  rustdesk-unattended-wayland = pkgs.callPackage ./rustdesk-unattended-wayland { };

  inherit libdrmtap;

  hubproxy = pkgs.callPackage ./hubproxy { };

  niri = inputs.niri-flake.packages.${pkgs.stdenv.hostPlatform.system}.niri-unstable;

  dbeaver-ultimate = pkgs.callPackage ./dbeaver-ultimate { };

  hokit = pkgs.callPackage ./hokit { };

  colmena = inputs.colmena.packages.${pkgs.stdenv.hostPlatform.system}.colmena;

  lossless-claw = pkgs.callPackage ./lossless-claw { };

  pi-web = pkgs.callPackage ./pi-web { };

  hdc = pkgs.callPackage ./hdc { };

  sidecar = pkgs.callPackage ./sidecar { };

  td = pkgs.callPackage ./td { };

  grok-bot-cli = pkgs.callPackage ./grok-bot-cli { };

  workbuddy = pkgs.nur.repos.MCSeekeri.workbuddy;

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
