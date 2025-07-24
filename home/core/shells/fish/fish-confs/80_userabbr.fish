abbr -a psu -- sudo pacman -Syu
abbr -a pcm -- sudo pacman
abbr -a pcms -- sudo pacman -S
abbr -a pcmsu -- sudo pacman -Syu
abbr -a pcmsyu -- sudo pacman -Syu
abbr -a ysu -- yay -Sau
abbr -a yays -- yay -S
abbr -a yaysu -- yay -Sau
abbr -a ngc -- sudo nix-collect-garbage -d
abbr -a nsw -- sudo nixos-rebuild switch
abbr -a nswd -- sudo nixos-rebuild switch --show-trace --print-build-logs --verbose
abbr -a nr. -- nix run
abbr -a nrn -- nix run nixpkgs\#
abbr -a nsh -- nix shell
abbr -a nsn -- nix shell nixpkgs\#
abbr -a psrg -- ps -aux \| rg -i

if functions -q projectdo_build
    abbr -a b --function projectdo_build
    abbr -a r --function projectdo_run
    abbr -a t --function projectdo_test
    abbr -a p --function projectdo_tool
end
