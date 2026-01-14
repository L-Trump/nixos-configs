{
  inputs,
  config,
  lib,
  ...
}:
let
  inherit (inputs) mysecrets;
  inherit (config.networking) hostName;
  cfg = config.mymodules.server.minio;
  cfgJfs = config.mymodules.server.juicefs;
in
{
  age.secrets.minio-env = lib.mkIf cfg.enable {
    file = "${mysecrets}/minio/minio-${hostName}.env.age";
    owner = "minio";
    group = "minio";
  };

  age.secrets.jfs-s3-env = lib.mkIf (cfgJfs.enableS3Gateway || cfgJfs.enableWebdav) {
    file = "${mysecrets}/minio/minio-juicefs.env.age";
  };
}
