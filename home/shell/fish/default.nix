{ config, pkgs, lib, ... }:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
      # set -gx GTK_USE_PORTAL 1
    '';
    plugins = with pkgs; [
      { name = "foreign-env"; src = fishPlugins.foreign-env.src; }
      { name = "fzf-fish"; src = fishPlugins.fzf-fish.src; }
      { name = "plugin-git"; src = fishPlugins.plugin-git.src; }
      { name = "plugin-git"; src = fishPlugins.plugin-git.src; }
      { name = "puffer"; src = fishPlugins.puffer.src; }
      { name = "done"; src = fishPlugins.done.src; }
      { name = "autopair"; src = fishPlugins.autopair.src; }
    ];
  };
  xdg.configFile =
    with lib.attrsets;
    (
      mapAttrs'
        (path: _type: nameValuePair ("fish/functions/" + path)
          { source = ./functions + "/${path}"; }
        )
        (filterAttrs
          (path: _type: lib.strings.hasSuffix ".fish" path)
          (builtins.readDir ./functions))
    ) // (
      mapAttrs'
        (path: _type: nameValuePair ("fish/conf.d/" + path)
          { source = ./configs + "/${path}"; }
        )
        (filterAttrs
          (path: _type: lib.strings.hasSuffix ".fish" path)
          (builtins.readDir ./configs))
    );
}
