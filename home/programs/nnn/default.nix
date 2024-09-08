{ config, pkgs, ... }:

let
  pkg-nnn-dbus = pkgs.stdenv.mkDerivation {
    name = "nnn-dbus";
    propagatedBuildInputs = with pkgs; [
      gobject-introspection
      (python3.withPackages (pyPkgs: with pyPkgs; [
        pip
        pygobject3
        pycairo
        pydbus
      ]))
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
    package = (pkgs.nnn.override { withNerdIcons = true; });
    bookmarks = {
      n = "~/nixos-configs";
      u = "~/Onedrive/上交";
      c = "~/Codes";
      d = "~/Documents";
      D = "~/Downloads";
      U = "/run/media";
      m = "/run/media";
    };
    plugins.src = (pkgs.fetchFromGitHub {
      owner = "jarun";
      repo = "nnn";
      rev = "v5.0";
      hash = "sha256-HShHSjqD0zeE1/St1Y2dUeHfac6HQnPFfjmFvSuEXUA=";
    }) + "/plugins";
    plugins.mappings = {
      z = "autojump";
      d = "dragdrop";
      s = "!fish -i*";
      e = ''-!nvim "\$nnn"*'';
      p = "preview-tui";
      # c = ''!convert "$nnn" png:- | xclip -sel clipboard -t image/png*'';
      c = ''!convert "\$nnn" png:- | wl-copy -t image/png*'';
      f = "fzplug";
    };
    extraPackages = with pkgs; [
      xdragon
      # For preview-tui
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

  home.sessionVariables = {
    NNN_OPTS = "xa";
    NNN_COLORS = "2136";
    NNN_ARCHIVE = "\\.(7z|a|ace|alz|arc|arj|bz|bz2|cab|cpio|deb|gz|jar|lha|lz|lzh|lzma|lzo|rar|rpm|rz|t7z|tar|tbz|tbz2|tgz|tlz|txz|tZ|tzo|war|xpi|xz|Z|zip)\$";
    sel = "$HOME/.config/nnn/.selection";
  };

  xdg.configFile."fish/functions/n.fish".source = ./n.fish;

  xdg.configFile."fish/conf.d/nnn.fish".source = ./nnn.fish;

  xdg.desktopEntries.nnn = {
    name = "nnn";
    comment = "Terminal file manager";
    exec = "${nnn-scripts}/bin/term-nnn %f";
    icon = "nnn";
    mimeType = [ "inode/directory" ];
    categories = [ "System" "FileTools" "FileManager" "ConsoleOnly" ];
    settings.Keywords = "File;Manager;Management;Explorer;Launcher";
  };
}
