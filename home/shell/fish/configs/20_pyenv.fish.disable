if not command -qv pyenv; and test -d $HOME/.pyenv/bin
    fish_add_path -Pp $PYENV_ROOT/bin
end

if command -qv pyenv
    set -gx PYENV_ROOT $HOME/.pyenv
    pyenv init - | source
end
