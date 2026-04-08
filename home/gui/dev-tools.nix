{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    # let vscode sync and update its configuration & extensions across devices, using github account.
    # userSettings = {};
    profiles.default.extensions = with pkgs.vscode-marketplace; [
      bbenoist.nix
      mkhl.direnv
      jnoortheen.nix-ide
      arrterian.nix-env-selector
      ms-toolsai.jupyter
      ms-toolsai.jupyter-keymap
      ms-toolsai.jupyter-renderers
      ms-toolsai.vscode-jupyter-cell-tags
      ms-toolsai.vscode-jupyter-slideshow
      ms-python.python
      ms-python.vscode-pylance
      ms-python.debugpy
      ms-ceintl.vscode-language-pack-zh-hans
    ];
    # package = pkgs.vscode.override {
    #   # isInsiders = true;
    #   # https://wiki.archlinux.org/title/Wayland#Electron
    #   commandLineArgs = [
    #     "--ozone-platform-hint=auto"
    #     # make it use GTK_IM_MODULE if it runs with Gtk4, so fcitx5 can work with it.
    #     # (only supported by chromium/chrome at this time, not electron)
    #     # "--gtk-version=4"
    #     # make it use text-input-v1, which works for kwin 5.27 and weston
    #     "--enable-wayland-ime"
    #   ];
    # };
  };
}
