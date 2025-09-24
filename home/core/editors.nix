{
  pkgs,
  lib,
  ...
}:
{
  programs.helix = {
    enable = true;
    package = pkgs.helix;

    settings = {
      theme = "zed_onedark";
      editor = {
        line-number = "relative";
        cursorline = true;
        color-modes = true;
        lsp.display-messages = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        indent-guides.render = true;
      };
      keys.normal = {
        space = {
          space = "file_picker_in_current_buffer_directory";
          w = ":w";
          q = ":q";
          x = ":bc";
        };
        esc = [
          "collapse_selection"
          "keep_primary_selection"
        ];
      };
      # keys.insert = {
      #   j.k = "normal_mode";
      # };
    };
  };

  programs.neovim.enable = true;

  home.sessionVariables = {
    EDITOR = lib.mkForce "hx";
    SYSTEMD_EDITOR = lib.mkForce "hx";
  };
}
