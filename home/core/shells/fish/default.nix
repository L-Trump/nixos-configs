{
  pkgs,
  lib,
  ...
}:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
    '';
    plugins = with pkgs; [
      {
        name = "done";
        src = fishPlugins.done.src;
      }
      {
        name = "foreign-env";
        src = fishPlugins.foreign-env.src;
      }
      {
        name = "fzf-fish";
        src = fishPlugins.fzf-fish.src;
      }
      {
        name = "plugin-git";
        src = fishPlugins.plugin-git.src;
      }
      {
        name = "puffer";
        src = fishPlugins.puffer.src;
      }
      {
        name = "autopair";
        src = fishPlugins.autopair.src;
      }
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

  xdg.configFile =
    with lib.attrsets;
    (mapAttrs' (
      path: _type: nameValuePair ("fish/functions/" + path) { source = ./fish-funcs + "/${path}"; }
    ) (filterAttrs (path: _type: lib.strings.hasSuffix ".fish" path) (builtins.readDir ./fish-funcs)))
    // (mapAttrs' (
      path: _type: nameValuePair ("fish/conf.d/" + path) { source = ./fish-confs + "/${path}"; }
    ) (filterAttrs (path: _type: lib.strings.hasSuffix ".fish" path) (builtins.readDir ./fish-confs)));
}
