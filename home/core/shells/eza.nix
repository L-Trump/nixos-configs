{
  # A modern replacement for ‘ls’
  # useful in bash/zsh prompt
  programs.eza = {
    enable = true;
    icons = true;
    git = true;
  };
  programs.fish.shellAliases = {
    l = "eza -la";
  };
}
