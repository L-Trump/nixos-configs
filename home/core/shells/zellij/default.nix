{
  pkgs,
  ...
}:
let
  # `scrollback_editor` for zellij's `EditScrollback ansi=true` action: show the
  # ANSI dump in a read-only neovim pager (./scrollback-pager.lua) instead of
  # opening it as a plain text file with the system editor ($EDITOR).
  #
  # NOTE: the name ends with "nvim" on purpose.  zellij only forwards the scrollback
  # row the pane is looking at (`+<line>`) to editors whose command ends with
  # vim/nvim/emacs/nano/kak (build_command() in zellij-server/src/os_input_output.rs).
  zellij-scrollback-nvim = pkgs.writeShellApplication {
    name = "zellij-scrollback-nvim";
    runtimeInputs = [ pkgs.neovim ];
    text = ''
      line=0
      if [[ ''${1-} == +* ]]; then
        line=''${1#+}
        shift
      fi
      dump=''${1-}
      if [[ -z $dump || ! -r $dump ]]; then
        echo "usage: zellij-scrollback-nvim [+LINE] <dump-file>" >&2
        exit 1
      fi
      export ZELLIJ_SCROLLBACK_DUMP=$dump
      export ZELLIJ_SCROLLBACK_LINE=$line
      exec nvim -u NONE -R -M -c "lua dofile('${./scrollback-pager.lua}')()"
    '';
  };
in
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

  home.packages = [ zellij-scrollback-nvim ];

  xdg.configFile."zellij/config.kdl".source = ./config.kdl;
}
