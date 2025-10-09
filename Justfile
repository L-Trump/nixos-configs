# just is a command runner, Justfile is very similar to Makefile, but simpler.

# Use nushell for shell commands
# To usage this justfile, you need to enter a shell with just & nushell installed:
# 
#   nix shell nixpkgs#just nixpkgs#nushell
set shell := ["fish", "-c"]

############################################################################
#
#  Common commands(suitable for all machines)
#
############################################################################

# List all the just commands
default:
    @just --list

# Run eval tests
[group('nix')]
switch:
  sudo nixos-rebuild switch --flake .

# Run eval tests
[group('nix')]
preview:
  nixos-rebuild build --flake . $argv && nvd diff /run/current-system result

[group('nix')]
diff:
  nvd diff $(command ls -d1v /nix/var/nix/profiles/system-*-link|tail -n 2)

# Run eval tests
[group('nix')]
test:
  nix eval .#evalTests --show-trace --print-build-logs --verbose

# Update all the flake inputs
[group('nix')]
up:
  nix flake update

# Update specific input
# Usage: just upp nixpkgs
[group('nix')]
upp input:
  nix flake update {{input}}

# List all generations of the system profile
[group('nix')]
history:
  nix profile history --profile /nix/var/nix/profiles/system

# Open a nix shell with the flake
[group('nix')]
repl:
  nix repl -f flake:nixpkgs

# remove all generations older than 7 days
# on darwin, you may need to switch to root user to run this command
[group('nix')]
clean:
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d

# Garbage collect all unused nix store entries
[group('nix')]
gc:
  # garbage collect all unused nix store entries(system-wide)
  sudo nix-collect-garbage --delete-older-than 7d
  # garbage collect all unused nix store entries(for the user - home-manager)
  # https://github.com/LnL7/nix-darwin/issues/237
  nix-collect-garbage --delete-older-than 7d
  nix-collect-garbage --delete-older-than 7d --option use-xdg-base-directories true

[group('nix')]
gcall:
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system
  sudo nix profile wipe-history --profile /etc/profiles/per-user/ltrump
  nix profile wipe-history --profile ~/.nix-profile
  sudo nix-collect-garbage -d
  nix-collect-garbage -d
  nix-collect-garbage -d --option use-xdg-base-directories true

[group('nix')]
gc7d:
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d
  sudo nix profile wipe-history --profile /etc/profiles/per-user/ltrump --older-than 7d
  nix profile wipe-history --profile ~/.nix-profile --older-than 7d
  sudo nix-collect-garbage --delete-older-than 7d
  nix-collect-garbage --delete-older-than 7d
  nix-collect-garbage --delete-older-than 7d --option use-xdg-base-directories true

# Enter a shell session which has all the necessary tools for this flake
[linux]
[group('nix')]
shell:
  nix shell nixpkgs#git nixpkgs#neovim nixpkgs#colmena

[group('nix')]
fmt:
  # format the nix files in this repo
  nix fmt

# Show all the auto gc roots in the nix store
[group('nix')]
gcroot:
  ls -al /nix/var/nix/gcroots/auto/

[group('colmena')]
col tag:
  colmena apply --on '@{{tag}}' --verbose --show-trace

############################################################################
#
#  Neovim related commands
#
############################################################################

[group('neovim')]
nvim-test:
  rm -rf $"($env.HOME)/.config/nvim"
  rsync -avz --copy-links --chmod=D2755,F744 home/base/tui/editors/neovim/nvim/ $"($env.HOME)/.config/nvim/"

[group('neovim')]
nvim-clean:
  rm -rf $"($env.HOME)/.config/nvim"

# =================================================
# Emacs related commands
# =================================================

[group('emacs')]
emacs-test:
  rm -rf $"($env.HOME)/.config/doom"
  rsync -avz --copy-links --chmod=D2755,F744 home/base/tui/editors/emacs/doom/ $"($env.HOME)/.config/doom/"
  doom clean
  doom sync

[group('emacs')]
emacs-clean:
  rm -rf $"($env.HOME)/.config/doom/"

[group('emacs')]
emacs-purge:
  doom purge
  doom clean
  doom sync

[linux]
[group('emacs')]
emacs-reload:
  doom sync
  systemctl --user restart emacs.service
  systemctl --user status emacs.service


emacs-plist-path := "~/Library/LaunchAgents/org.nix-community.home.emacs.plist"

[macos]
[group('emacs')]
emacs-reload:
  doom sync
  launchctl unload {{emacs-plist-path}}
  launchctl load {{emacs-plist-path}}
  tail -f ~/Library/Logs/emacs-daemon.stderr.log

# =================================================
#
# Other useful commands
#
# =================================================

[group('common')]
path:
   $env.PATH | split row ":"

[linux]
[group('common')]
penvof pid:
  sudo cat $"/proc/($pid)/environ" | tr '\0' '\n'

# Remove all reflog entries and prune unreachable objects
[group('git')]
ggc:
  git reflog expire --expire-unreachable=now --all
  git gc --prune=now

# Amend the last commit without changing the commit message
[group('git')]
game:
  git commit --amend -a --no-edit

# Delete all failed pods
[group('k8s')]
del-failed:
  kubectl delete pod --all-namespaces --field-selector="status.phase==Failed"

[linux]
[group('services')]
list-inactive:
  systemctl list-units -all --state=inactive

[linux]
[group('services')]
list-failed:
  systemctl list-units -all --state=failed

[group('waybar')]
waybar-test:
  rm -rf $HOME/.config/waybar/config.jsonc
  rm -rf $HOME/.config/waybar/style.css
  rsync -avz --copy-links --chmod=D2755,F744 ./home/gui/wayland/waybar/config.jsonc $HOME/.config/waybar/config.jsonc
  rsync -avz --copy-links --chmod=D2755,F744 ./home/gui/wayland/waybar/style.css $HOME/.config/waybar/style.css

[group('waybar')]
waybar-clean:
  rm -rf $HOME/.config/waybar/config.jsonc
  rm -rf $HOME/.config/waybar/style.css
