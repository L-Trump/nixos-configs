_: {
  nezha-server = {
    image = "registry.cn-shanghai.aliyuncs.com/naibahq/nezha-dashboard";
    digest = "sha256:c21078e4683300d29659f2011fc54ab9812e0065c60670843650bd377da0549c";
  };
  immich-machine-learning = {
    image = "m.daocloud.io/ghcr.io/immich-app/immich-machine-learning";
    latestTag = "release";
    digest = "sha256:b3deefd1826f113824e9d7bc30d905e7f823535887d03f869330946b6db3b44a";
  };
  siyuan-server = {
    image = "m.daocloud.io/docker.io/b3log/siyuan";
    digest = "sha256:bac87c146ebd11338be28b392971944bcf76a4c530e3ec2384eed5ceb37b9bf3";
  };
  cloudreve = {
    image = "m.daocloud.io/docker.io/cloudreve/cloudreve";
    digest = "sha256:70debed86997389b00624d0ac2fe25ecbaca8dbe444157c6660bc93ca940cc9d";
  };
  cloudreve-redis = {
    image = "m.daocloud.io/docker.io/library/redis";
    digest = "sha256:3906b477e4b60250660573105110c28bfce93b01243eab37610a484daebceb04";
  };
  cloudreve-postgresql = {
    image = "m.daocloud.io/docker.io/library/postgres";
    digest = "sha256:38d5c9d522037d8bf0864c9068e4df2f8a60127c6489ab06f98fdeda535560f9";
  };
  rustdesk-api = {
    image = "docker.linkos.org/lejianwen/rustdesk-api";
    digest = "sha256:ed35016339d3bcadf15c7bb3ae8490af1e3950c33f58fd2261ae009b94f5de45";
  };
  xpipe-webtop = {
    image = "ghcr.linkos.org/xpipe-io/xpipe-webtop";
    digest = "sha256:b7198458c962a35ef360e1e68f6c3837169b64b607d13ef105a83b42ba20e70e";
  };
}
