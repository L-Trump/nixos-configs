if command -qv nnn
    # Setup quitcd
    # if test -f ${config.programs.nnn.finalPackage}/share/quitcd/quitcd.fish
    #     source ${config.programs.nnn.finalPackage}/share/quitcd/quitcd.fish
    # end
    # Setup nnn cd
    # function nnn_cd
    #     if not test -z $NNN_PIPE
    #         fish -c 'printf "%s\0" "0c$PWD" > $NNN_PIPE' &
    #         disown
    #     end
    # end

    # trap nnn_cd EXIT

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
