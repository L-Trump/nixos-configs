{
  # A modern replacement for ‘ls’
  # useful in bash/zsh prompt
  programs.eza = {
    enable = true;
    icons = "auto";
    git = true;
  };
  programs.fish.shellAliases = {
    l = "eza -la";
  };
}
