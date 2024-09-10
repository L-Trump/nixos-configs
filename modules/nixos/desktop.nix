{ pkgs
, config
, lib
, myvars
, ...
}:

with lib; {
  imports = [
    ./base
    ../base
    ./desktop
  ];

  options.modules.desktop = {
    main = mkOption {
      type = enum [ "xorg" "wayland" ];
      default = "wayland";
      description = "Main Display Server";
    };
    wayland = {
      enable = mkEnableOption "Wayland Display Server" //
        { default = true; };
    };
    xorg = {
      enable = mkEnableOption "Xorg Display Server" //
        { default = true; };
    };
  };
}
