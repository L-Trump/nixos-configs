abbr -a psu -- sudo pacman -Syu
abbr -a pcm -- sudo pacman
abbr -a pcms -- sudo pacman -S
abbr -a pcmsu -- sudo pacman -Syu
abbr -a pcmsyu -- sudo pacman -Syu
abbr -a ysu -- yay -Sau
abbr -a yays -- yay -S
abbr -a yaysu -- yay -Sau

if functions -q projectdo_build
    abbr -a b --function projectdo_build
    abbr -a r --function projectdo_run
    abbr -a t --function projectdo_test
    abbr -a p --function projectdo_tool
end
