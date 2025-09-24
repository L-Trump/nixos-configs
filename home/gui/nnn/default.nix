{
  config,
  lib,
  pkgs,
  ...
}:
let
  pkg-nnn-dbus = pkgs.stdenv.mkDerivation {
    name = "nnn-dbus";
    propagatedBuildInputs = with pkgs; [
      gobject-introspection
      (python3.withPackages (
        pyPkgs: with pyPkgs; [
          pip
          pygobject3
          pycairo
          pydbus
        ]
      ))
    ];
    nativeBuildInputs = with pkgs; [ wrapGAppsHook ];
    dontUnpack = true;
    installPhase = ''
      install -Dm755 ${./nnn-dbus} $out/bin/nnn-dbus
    '';
  };
  nnn-scripts = pkgs.mkScriptsPackage "nnn-scripts" ./scripts;
in
{
  home.packages = with pkgs; [
    pkg-nnn-dbus
    nnn-scripts
  ];

  programs.nnn = {
    enable = true;
    package = lib.mkForce (pkgs.nnn.override { withNerdIcons = true; });
    bookmarks = {
      n = "~/nixos-configs";
      u = "~/Onedrive/上交";
      c = "~/Codes";
      d = "~/Documents";
      D = "~/Downloads";
      U = "/run/media";
      m = "/run/media";
    };
    plugins.mappings = {
      d = "dragdrop";
      p = "preview-tui";
      # c = ''!convert "$nnn" png:- | xclip -sel clipboard -t image/png*'';
      c = ''!convert "\$nnn" png:- | wl-copy -t image/png*'';
    };
    extraPackages = with pkgs; [
      # for drag and drop
      xdragon
      # for preview-tui
      bat
      libarchive
      imagemagick
      ffmpeg
      ffmpegthumbnailer
      poppler_utils
      fontpreview
      glow
    ];
  };

  xdg.desktopEntries.nnn = {
    name = "nnn";
    comment = "Terminal file manager";
    exec = "${nnn-scripts}/bin/term-nnn %f";
    icon = "nnn";
    mimeType = [ "inode/directory" ];
    categories = [
      "System"
      "FileTools"
      "FileManager"
      "ConsoleOnly"
    ];
    settings.Keywords = "File;Manager;Management;Explorer;Launcher";
  };
}
