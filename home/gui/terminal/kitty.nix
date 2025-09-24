{
  lib,
  pkgs,
  ...
}:
{
  programs.kitty = {
    enable = true;
    font = {
      name = "Source Code Pro";
      size = 12;
      package = pkgs.source-code-pro;
    };
    settings = {
      scrollback_lines = 10000;
      enable_audio_bell = false;
      update_check_interval = 0;

      foreground = "#eff0eb";
      background = "#282a36";
      background_opacity = "0.9";
      color0 = "#282a36";
      color8 = "#767676";
      color1 = "#ff5c57";
      color9 = "#ff2400";
      color2 = "#5af78e";
      color10 = "#23fd00";
      color3 = "#f3f99d";
      color11 = "#fdff00";
      color4 = "#57c7ff";
      color12 = "#007fff";
      color5 = "#ff6ac1";
      color13 = "#ff1493";
      color6 = "#9aedfe";
      color14 = "#14ffff";
      color7 = "#f1f1f0";
      color15 = "#fffafa";

      # remote settings
      allow_remote_control = "yes";
      listen_on = "unix:/tmp/kitty";
    };
    keybindings = {
      "ctrl+shift+space" = "show_scrollback";
    };
    extraConfig = ''
      scrollback_pager nvim -u NONE -R -M -c 'lua dofile("${./kitty-pager.lua}")(INPUT_LINE_NUMBER, CURSOR_LINE, CURSOR_COLUMN)' -
    '';
  };

  home.shellAliases = {
    kssh = lib.mkForce "kitten ssh";
  };
}
