_: {
  nezha-server = {
    image = "registry.cn-shanghai.aliyuncs.com/naibahq/nezha-dashboard";
    tag = "v1.13.0";
  };
  immich-machine-learning = {
    image = "ghcr.m.daocloud.io/immich-app/immich-machine-learning";
    tag = "v1.135.3";
    latestTag = "release";
  };
  siyuan-server = {
    image = "docker.m.daocloud.io/b3log/siyuan";
    tag = "v3.2.0";
  };
  cloudreve = {
    image = "docker.m.daocloud.io/cloudreve/cloudreve";
    tag = "4.2.0";
  };
  cloudreve-redis = {
    image = "docker.m.daocloud.io/library/redis";
    tag = "8.0.2-bookworm";
  };
  cloudreve-postgresql = {
    image = "docker.m.daocloud.io/library/postgres";
    tag = "17.5-bookworm";
  };
}
