{ ... }:
let
  background_merry = builtins.path { path = ../../wallpapers/Meumy/84369477.jpg; };
in
{
  enable = true;
  settings = {
    general = {
      hide_cursor = true;
    };
    background = {
      monitor = "";
      path = background_merry;
    };
  };
}
