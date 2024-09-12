{lib, ...}: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
    '';
  };
  xdg.configFile = with lib.attrsets;
    (
      mapAttrs'
      (
        path: _type:
          nameValuePair ("fish/functions/" + path)
          {source = ./fish-funcs + "/${path}";}
      )
      (filterAttrs
        (path: _type: lib.strings.hasSuffix ".fish" path)
        (builtins.readDir ./fish-funcs))
    )
    // (
      mapAttrs'
      (
        path: _type:
          nameValuePair ("fish/conf.d/" + path)
          {source = ./fish-confs + "/${path}";}
      )
      (filterAttrs
        (path: _type: lib.strings.hasSuffix ".fish" path)
        (builtins.readDir ./fish-confs))
    );
}
