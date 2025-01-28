{
  inputs,
  config,
  lib,
  ...
}: let
  inherit (inputs) mysecrets;
  cfg = config.mymodules.server.minio;
in {
  age.secrets.minio-env = lib.mkIf cfg.enable {
    file = "${mysecrets}/minio/minio.env.age";
    owner = "minio";
    group = "minio";
  };
}
