{
  config,
  lib,
  ...
}:
let
  cfg = config.mymodules.server.minio;
in
{
  services.minio = lib.mkIf cfg.enable {
    enable = true;
    browser = true; # Enable or disable access to web UI.

    dataDir = [ "/data/app/minio/data" ];
    configDir = "/data/app/minio/config";
    listenAddress = ":9096";
    consoleAddress = ":9097"; # Web UI
    region = "us-east-1"; # default to us-east-1, same as AWS S3.

    # File containing the MINIO_ROOT_USER, default is “minioadmin”, and MINIO_ROOT_PASSWORD (length >= 8), default is “minioadmin”;
    rootCredentialsFile = config.age.secrets.minio-env.path;
  };
}
