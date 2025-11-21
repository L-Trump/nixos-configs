{ pkgs, ... }:
let
  tomlFormat = pkgs.formats.toml { };
  configFile = tomlFormat.generate "tlrc-config.toml" {
    cache = {
      auto_update = true;
      defer_auto_update = false;
      dir = "~/.cache/tlrc";
      languages = [ ];
      max_age = 336;
      mirror = "https://ghfast.top/https://github.com/tldr-pages/tldr/releases/latest/download";
    };
    indent = {
      bullet = 2;
      description = 2;
      example = 4;
      title = 2;
    };
    output = {
      compact = false;
      example_prefix = "- ";
      line_length = 0;
      option_style = "long";
      platform_title = false;
      raw_markdown = false;
      show_hyphens = false;
      show_title = true;
    };
    style = {
      bullet = {
        background = "default";
        bold = false;
        color = "green";
        dim = false;
        italic = false;
        strikethrough = false;
        underline = false;
      };
      description = {
        background = "default";
        bold = false;
        color = "magenta";
        dim = false;
        italic = false;
        strikethrough = false;
        underline = false;
      };
      example = {
        background = "default";
        bold = false;
        color = "cyan";
        dim = false;
        italic = false;
        strikethrough = false;
        underline = false;
      };
      inline_code = {
        background = "default";
        bold = false;
        color = "yellow";
        dim = false;
        italic = true;
        strikethrough = false;
        underline = false;
      };
      placeholder = {
        background = "default";
        bold = false;
        color = "red";
        dim = false;
        italic = true;
        strikethrough = false;
        underline = false;
      };
      title = {
        background = "default";
        bold = true;
        color = "magenta";
        dim = false;
        italic = false;
        strikethrough = false;
        underline = false;
      };
      url = {
        background = "default";
        bold = false;
        color = "red";
        dim = false;
        italic = true;
        strikethrough = false;
        underline = false;
      };
    };
  };
in
{
  home.packages = [ pkgs.tlrc ];
  xdg.configFile."tlrc/config.toml" = {
    source = configFile;
  };
}
