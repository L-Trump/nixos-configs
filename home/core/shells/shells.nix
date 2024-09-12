{ config, pkgs, lib, ... }:
{
  programs.fish = {
    enable = true;
    plugins = with pkgs; [
      { name = "done"; src = fishPlugins.done.src; }
      { name = "foreign-env"; src = fishPlugins.foreign-env.src; }
      { name = "fzf-fish"; src = fishPlugins.fzf-fish.src; }
      { name = "plugin-git"; src = fishPlugins.plugin-git.src; }
      { name = "puffer"; src = fishPlugins.puffer.src; }
      { name = "autopair"; src = fishPlugins.autopair.src; }
    ];
    shellAbbrs = {
      ngc = "sudo nix-collect-garbage -d";
      nsw = "sudo nixos-rebuild switch";
      nswd = "sudo nixos-rebuild switch --show-trace --print-build-logs --verbose";
      "nr." = "nix run";
      nrn = "nix run nixpkgs#";
      nsh = "nix shell";
      nsn = "nix shell nixpkgs#";
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  home.shellAliases = {
    nv = "nvim";
    clr = "clear";
    ssh = "TERM=xterm-256color command ssh";
  };
}
