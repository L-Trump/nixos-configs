if status is-interactive
    set vi_leader \x20
    # Vi Key bindings
    fish_vi_key_bindings
    bind -M insert -m default jk cancel repaint-mode
    set -g fish_sequence_key_delay_ms 200
    # Vi cursor style
    set -g fish_cursor_insert line
    # Fzf bindings for vi mode
    bind -M default " ff" _fzf_search_directory
    bind -M default " fgl" _fzf_search_git_log
    bind -M default " fgs" _fzf_search_git_status
    bind -M default " fh" _fzf_search_history
    bind -M default -m insert "H" _fzf_search_history
    bind -M default " fp" _fzf_search_history
end
