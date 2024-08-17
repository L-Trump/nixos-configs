set editor_list nvim vim nano vi
for editor in $editor_list
    if command -qv $editor
        set -gx EDITOR $editor
        set -gx SYSTEMD_EDITOR $editor
        break
    end
end
