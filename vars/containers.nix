_: {
  nezha-server = {
    image = "registry.cn-shanghai.aliyuncs.com/naibahq/nezha-dashboard";
    tag = "v1.13.0";
    digest = "sha256:0666c519bd0c2186a32634302c1b8fb30420e62211cc8d4121353b01f4a59a97";
  };
  immich-machine-learning = {
    image = "ghcr.m.daocloud.io/immich-app/immich-machine-learning";
    tag = "v1.138.1";
    latestTag = "release";
    digest = "sha256:f34e855424fd91c5990132e5b2bde91e1d178ec5205de293ebd8779839a4a77c";
  };
  siyuan-server = {
    image = "docker.m.daocloud.io/b3log/siyuan";
    tag = "v3.2.1";
    digest = "sha256:d7a8ae7848187aa2e17e3040db51fbb38902a1eee8754bbd27821f49aeec7f67";
  };
  cloudreve = {
    image = "docker.m.daocloud.io/cloudreve/cloudreve";
    tag = "4.6.0";
    digest = "sha256:31a69b3654942ee7b6a8450e0f775c5e917b7105a199a9e261749c1b20189e3f";
  };
  cloudreve-redis = {
    image = "docker.m.daocloud.io/library/redis";
    tag = "8.2.1-bookworm";
    digest = "sha256:cc2dfb8f5151da2684b4a09bd04b567f92d07591d91980eb3eca21df07e12760";
  };
  cloudreve-postgresql = {
    image = "docker.m.daocloud.io/library/postgres";
    tag = "17.6-trixie";
    digest = "sha256:29e0bb09c8e7e7fc265ea9f4367de9622e55bae6b0b97e7cce740c2d63c2ebc0";
  };
}
