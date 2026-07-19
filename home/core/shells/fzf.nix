{ pkgs, ... }:
{
  programs.fzf = {
    enable = true;
    defaultCommand = "fd --type f";
    changeDirWidget.command = "fd --type d";
    fileWidget.command = "fd --type f";
    historyWidget.command = "";
  };

  home.packages = [ pkgs.fd ];
}
