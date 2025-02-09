{
  programs.zellij = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = false;
    enableFishIntegration = false;
  };
  # only works in bash/zsh, not nushell
  home.shellAliases = {
    "zj" = "zellij";
  };

  xdg.configFile."zellij/config.kdl".source = ./config.kdl;
}
