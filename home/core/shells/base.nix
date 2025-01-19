_: {
  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  home.shellAliases = {
    nv = "nvim";
    clr = "clear";
    ssh = "TERM=xterm-256color command ssh";
  };
}
