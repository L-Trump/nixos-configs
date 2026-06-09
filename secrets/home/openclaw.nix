{
  lib,
  config,
  inputs,
  ...
}:
let
  # 私有 nixos-secrets flake，提供加密后的 openclaw secrets.json.age。
  inherit (inputs) mysecrets;

  # 用户级 OpenClaw 开关。
  cfg = config.myhome.tuiExtra.openclaw;
in
{
  # 仅在 OpenClaw 启用时声明对应 agenix secret。
  config = lib.mkIf cfg.enable {
    # OpenClaw 使用的聚合 JSON secret，供 secrets.providers.openclaw 读取。
    age.secrets.openclaw-secrets = {
      # age 加密文件位置；解密后的 runtime path 由 agenix 自动生成。
      file = "${mysecrets}/openclaw/secrets.json.age";
    };
  };
}
