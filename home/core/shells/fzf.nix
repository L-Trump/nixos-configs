{ pkgs, ... }:
{
  programs.fzf = {
    enable = true;
    defaultCommand = "fd --type f";
    changeDirWidgetCommand = "fd --type d";
    fileWidgetCommand = "fd --type f";
  };

  home.packages = [ pkgs.fd ];
}
