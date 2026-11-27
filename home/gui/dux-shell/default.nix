{
  inputs,
  pkgs,
  lib,
  ...
}@args:
let
  dmsSettings = import ./dms-settings.nix args;
  dmsSession = import ./dms-session.nix args;
  pluginSettings = import ./dms-plugin-settings.nix args;
in
{
  imports = [
    inputs.dms.homeModules.dank-material-shell
    inputs.dms-plugin-registry.homeModules.default
  ];

  programs.dank-material-shell = {
    enable = true;
    # dms package with custom patches
    package = (inputs.dms.packages.${pkgs.stdenv.hostPlatform.system}.default).overrideAttrs (old: {
      postInstall = (old.postInstall or "") + ''
         # custom powermenu button key
        substituteInPlace $out/share/quickshell/dms/Services/SessionService.qml \
          --replace-fail '"key": ""' '"key": button?.key || ""'
        # add noConfirm option for custom powermenu button
        substituteInPlace $out/share/quickshell/dms/Modules/PowerMenu/PowerMenuContent.qml \
          --replace-fail 'return action !== "lock" && action !== "restart";' \
          'return action.startsWith("custom:") ? !(SettingsData.customPowerButtons[parseInt(action.slice(7))]?.noConfirm ?? false) : (action !== "lock" && action !== "restart");'
        # Island hidden when fullscreen
        substituteInPlace $out/share/quickshell/dms/Modules/DBar/DBarBody.qml \
          --replace-fail '!barWindow.isIsland && !usesFrameBarChrome' '!usesFrameBarChrome'
      '';
    });
    systemd.enable = true;

    # immutable settings
    settings = dmsSettings;

    # spotlight plugin for niri window search
    plugins.niriWindows.enable = true;
    # interval command plugin
    plugins.intervalCommand = {
      enable = true;
      settings = pluginSettings.intervalCommand;
    };
  };

  home.packages = [ pkgs.quickshell ];

  # mutable session.json with seed
  home.activation.dmsSessionSeed = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -e "$HOME/.local/state/dms/session.json" ]; then
      run mkdir -p "$HOME/.local/state/dms"
      cat > "$HOME/.local/state/dms/session.json" <<'DMS_SESSION'
    ${builtins.toJSON dmsSession}
    DMS_SESSION
    fi
  '';
}
