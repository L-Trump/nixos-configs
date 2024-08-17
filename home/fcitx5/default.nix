{ config, pkgs, ... }:

{
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = 
    with pkgs; [
      fcitx5-configtool
      fcitx5-chinese-addons
    ];
  };

  home.file.".local/share/fcitx5/table/flypy.dict".source = ./flypy.dict;
  home.file.".local/share/fcitx5/inputmethod/flypy.conf".source = ./flypy.conf;
}
