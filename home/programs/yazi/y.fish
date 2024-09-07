function y --wraps yazi --description 'Enhanced yazi'
    # Block nesting of yazi in subshells
    if test -n "$YAZI_ID"
        echo "yazi is already running"
        return
    end

    # Yazi CD
    set tmp (mktemp -t "yazi-cwd.XXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
      builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end
