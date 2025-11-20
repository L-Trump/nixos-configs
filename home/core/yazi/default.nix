{
  config,
  pkgs,
  lib,
  myvars,
  ...
}:
let
  inherit (lib) mapAttrsToList;
  bookmarks = myvars.daily.pathBookmarks;
  plugins = {
    z = "plugin zoxide";
    f = "plugin fzf";
    d = ''shell 'dragon -x -i -T "$1"' --confirm'';
    s = ''shell "$SHELL" --block --confirm'';
    c = ''shell 'for path in "$@"; do echo "file://$path"; done | wl-copy -t text/uri-list' --confirm'';
  };
  bookmark_keymaps = lib.flatten (
    mapAttrsToList (key: value: [
      {
        on = [
          "b"
          key
        ];
        run = "cd ${value}";
        desc = "Cd ${value}";
      }
      {
        on = [
          "g"
          key
        ];
        run = "cd ${value}";
        desc = "Cd ${value}";
      }
    ]) bookmarks
  );
  plugin_keymaps = mapAttrsToList (key: value: {
    on = [
      ";"
      key
    ];
    run = value;
  }) plugins;
in
{
  config = lib.mkIf false {
    home.packages = with pkgs; [ xdragon ];
    programs.yazi = {
      enable = true;
      enableFishIntegration = false;
      settings = {
        manager.mouse_events = [
          "click"
          "scroll"
          "touch"
          "drag"
        ];
        opener.open = [
          {
            run = ''xdg-open "$1"'';
            orphan = true;
            desc = "Open";
          }
        ];
      };
      keymap = {
        manager.prepend_keymap = [
          {
            on = "q";
            run = "close";
            desc = "Close the current tab; or quit if it is last tab";
          }
          {
            on = "<C-c>";
            run = "escape";
            desc = "Exit visual mode; clear selected; or cancel search";
          }
          {
            on = "!";
            run = ''shell "$SHELL" --block --confirm'';
            desc = "Open a shell here";
          }
          {
            on = "e";
            run = ''shell "''${EDITOR:-vi} \"$@\"" --block --confirm'';
            desc = "Edit current by $EDITOR";
          }
          {
            on = "<Enter>";
            run = "plugin --sync smart-enter";
            desc = "Enter/open the target";
          }
          {
            on = "l";
            run = "plugin --sync smart-enter";
            desc = "Enter/open the target";
          }
          # { on = [ "n" "f" ]; run = "create"; desc = "Create a file"; }
          # { on = [ "n" "d" ]; run = "create --dir"; desc = "Create a directory"; }
        ]
        ++ bookmark_keymaps
        ++ plugin_keymaps;
      };
      initLua = ./yazi-init.lua;
      plugins.smart-enter = ./plugin-smart-enter;
    };

    xdg.configFile."fish/functions/y.fish".source = ./y.fish;

    programs.fish.interactiveShellInit = ''
      if [ -n "$YAZI_ID" ]
        trap 'ya pub dds-cd --str "$PWD"' EXIT
      end
    '';
  };
}
