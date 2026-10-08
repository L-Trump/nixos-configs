{
  lib,
  config,
  inputs,
  ...
}:
let
  # 私有 nixos-secrets flake，提供加密后的 pi-web 环境变量文件。
  inherit (inputs) mysecrets;

  # 用户级 pi-web 开关。
  cfg = config.myhome.tuiExtra.pi.pi-web;
in
{
  config = lib.mkIf cfg.enable {
    age.secrets.pi-web-env = {
      file = "${mysecrets}/pi-web/pi-web.env.age";
      path = "${config.home.homeDirectory}/.pi/pi-web.env";
    };
  };
}
