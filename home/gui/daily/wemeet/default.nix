{
  pkgs,
  lib,
  ...
}:
let
  pkg-wemeet-openbox-cast = pkgs.stdenv.mkDerivation {
    name = "wemeet-openbox-cast";
    propagatedBuildInputs = with pkgs; [
      gobject-introspection
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      pipewire
      (python3.withPackages (
        pyPkgs: with pyPkgs; [
          pygobject3
          pycairo
          pydbus
          dbus-python
        ]
      ))
    ];
    nativeBuildInputs = with pkgs; [ wrapGAppsHook3 ];
    dontUnpack = true;
    installPhase = ''
      install -Dm755 ${./scripts/xdp-screen-cast} $out/bin/xdp-screen-cast
      install -Dm755 ${./scripts/wemeet-openbox-cast} $out/bin/wemeet-openbox-cast
    '';
  };
in
{
  home.packages = with pkgs; [
    pkg-wemeet-openbox-cast
    xwayland
    openbox
    wemeet
  ];
  xdg.configFile."openbox/rc.xml".source = ./openbox-rc.xml;
  xdg.configFile."openbox/menu.xml".source = ./openbox-menu.xml;
  xdg.desktopEntries.wemeetapp-openbox-cast = {
    name = "Wemeet (OpenBox)";
    exec = "${pkg-wemeet-openbox-cast}/bin/wemeet-openbox-cast %u";
    icon = "wemeetapp";
    mimeType = [ "x-scheme-handler/wemeet" ];
    categories = [ "AudioVideo" ];
    settings."Name[zh_CN]" = "腾讯会议 (OpenBox)";
  };
}
