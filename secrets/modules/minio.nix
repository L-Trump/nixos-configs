{
  inputs,
  config,
  lib,
  ...
}: let
  inherit (inputs) mysecrets;
  inherit (config.networking) hostName;
  cfg = config.mymodules.server.minio;
in {
  age.secrets.minio-env = lib.mkIf cfg.enable {
    file = "${mysecrets}/minio/minio-${hostName}.env.age";
    owner = "minio";
    group = "minio";
  };
}
