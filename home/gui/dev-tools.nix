{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    # let vscode sync and update its configuration & extensions across devices, using github account.
    # userSettings = {};
    package = pkgs.vscode.override {
      # isInsiders = true;
      # https://wiki.archlinux.org/title/Wayland#Electron
      commandLineArgs = [
        "--ozone-platform-hint=auto"
        # make it use GTK_IM_MODULE if it runs with Gtk4, so fcitx5 can work with it.
        # (only supported by chromium/chrome at this time, not electron)
        # "--gtk-version=4"
        # make it use text-input-v1, which works for kwin 5.27 and weston
        "--enable-wayland-ime"
      ];
    };
  };
}
