{
  pkgs,
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.lan-mouse.homeManagerModules.default
  ];
  programs.lan-mouse = {
    enable = false;
    systemd = true;
    package = pkgs.lan-mouse;
    settings = {
      right = {
        hostname = "HomeWin";
        activate_on_startup = true;
        ips = [
          "192.168.2.14"
          "10.0.10.8"
          "100.101.101.56"
        ];
      };
    };
  };
  systemd.user.services.lan-mouse.Install.WantedBy = lib.mkForce [ ];
}
