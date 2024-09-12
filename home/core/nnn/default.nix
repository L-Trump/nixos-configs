{
  config,
  pkgs,
  ...
}: {
  programs.nnn = {
    enable = true;
    plugins.src =
      (pkgs.fetchFromGitHub {
        owner = "jarun";
        repo = "nnn";
        rev = "v5.0";
        hash = "sha256-HShHSjqD0zeE1/St1Y2dUeHfac6HQnPFfjmFvSuEXUA=";
      })
      + "/plugins";
    plugins.mappings = {
      z = "autojump";
      s = "!fish -i*";
      e = ''-!nvim "\$nnn"*'';
      f = "fzcd";
    };
  };

  home.sessionVariables = {
    NNN_OPTS = "xa";
    NNN_COLORS = "2136";
    NNN_ARCHIVE = "\\.(7z|a|ace|alz|arc|arj|bz|bz2|cab|cpio|deb|gz|jar|lha|lz|lzh|lzma|lzo|rar|rpm|rz|t7z|tar|tbz|tbz2|tgz|tlz|txz|tZ|tzo|war|xpi|xz|Z|zip)\$";
    sel = "$HOME/.config/nnn/.selection";
  };

  xdg.configFile."fish/functions/n.fish".source = ./n.fish;
  xdg.configFile."fish/conf.d/nnn.fish".source = ./nnn.fish;
}
