{
  config,
  lib,
  pkgs,
  mylib,
  ...
}@args:
with lib;
let
  cfg = config.myhome.desktop.niri;
  sessionEnvArgs = concatStringsSep " " (
    mapAttrsToList (name: value: escapeShellArg "${name}=${value}") cfg.settings.environment
  );
in
{
  config = mkIf cfg.enable {
    myhome.desktop.niri.settings = import ./niri-conf.nix args;

    xdg.configFile."niri/config.kdl".source = pkgs.writeText "config.kdl" (mylib.toKDL cfg.settings);

    programs.fish = {
      interactiveShellInit = lib.mkAfter ''
        # auto login on tty1
        if test -z $DISPLAY; and test -n "$XDG_VTNR"; and test $XDG_VTNR -eq 1; and test "$(tty)" = "/dev/tty1"; and test "$(fgconsole 2>/dev/null || echo 1)" -eq 1
            env ${sessionEnvArgs} niri-session
        end
      '';
    };
  };
}
