{ config, pkgs, ... }:

{
  programs.nnn = {
    enable = true;
    package = (pkgs.nnn.override { withNerdIcons = true; });
    bookmarks = {
      u = "~/Onedrive/上交";
      c = "~/Codes";
      d = "~/Documents";
      D = "~/Downloads";
      U = "/run/media";
      m = "/run/media";
    };
    plugins.src = (pkgs.fetchFromGitHub {
      owner = "jarun";
      repo = "nnn";
      rev = "v4.9";
      hash = "sha256-g19uI36HyzTF2YUQKFP4DE2ZBsArGryVHhX79Y0XzhU=";
    }) + "/plugins";
    plugins.mappings = {
      z = "autojump";
      d = "dragdrop";
      s = "!fish -i*";
      e = ''-!nvim "$nnn"*'';
      p = "preview-tui";
      c = ''!convert "$nnn" png:- | xclip -sel clipboard -t image/png*'';
    };
  };

  home.sessionVariables = {
    NNN_OPTS = "x";
    NNN_COLORS = "2136";
    NNN_ARCHIVE = "\\.(7z|a|ace|alz|arc|arj|bz|bz2|cab|cpio|deb|gz|jar|lha|lz|lzh|lzma|lzo|rar|rpm|rz|t7z|tar|tbz|tbz2|tgz|tlz|txz|tZ|tzo|war|xpi|xz|Z|zip)\$";
    sel = "$HOME/.config/nnn/.selection";
  };

  xdg.configFile."fish/functions/n.fish".source = ./n.fish;

  xdg.configFile."fish/conf.d/nnn.fish".text = ''
    if command -qv nnn
        # Setup quitcd
        if test -f ${config.programs.nnn.finalPackage}/share/quitcd/quitcd.fish
            source ${config.programs.nnn.finalPackage}/share/quitcd/quitcd.fish
        end
        # Setup nnn cd
        function nnn_cd
            if not test -z $NNN_PIPE
                printf "%s\0" "0c$PWD" > $NNN_PIPE &
                disown
            end
        end
        trap nnn_cd EXIT

        # With the original prompt function renamed, we can override with our own.
        if not test -z "$NNNLVL"
            functions -c fish_prompt _old_prompt_before_nnn
            function fish_prompt
                # Save the return status of the last command.
                set -l old_status $status

                # Output the venv prompt; color taken from the blue of the Python logo.
                printf "\n%s%s%s" (set_color -o) "(In NNN$NNNLVL) " (set_color normal)

                # Restore the return status of the previous command.
                echo "exit $old_status" | .
                # Output the original/"old" prompt.
                _old_prompt_before_nnn
            end
        end
    end
  '';
}
