_: {
  nezha-server = {
    image = "registry.cn-shanghai.aliyuncs.com/naibahq/nezha-dashboard";
    digest = "sha256:531839f142a24ddd71de2fe09213182c2886aa2d324b9a501797046437715074";
  };
  immich-machine-learning = {
    image = "gh.mmm.fan/ghcr.io/immich-app/immich-machine-learning";
    latestTag = "release";
    digest = "sha256:45626a33361ef7ed361de41b0d2dc19e5949442cdf0a8eb64b157dc8a04e9855";
  };
  siyuan-server = {
    image = "gh.mmm.fan/b3log/siyuan";
    digest = "sha256:f83d07e1ebf00ba00a9e86876594a607e9b6833d770330df7b0ee29a415e8a1d";
  };
  cloudreve = {
    image = "gh.mmm.fan/cloudreve/cloudreve";
    digest = "sha256:a553e5138ffc039388a0b45124189d0dec08f0c9b90d57469dc6240df9bfa452";
  };
  cloudreve-redis = {
    image = "gh.mmm.fan/library/redis";
    digest = "sha256:f0957bcaa75fd58a9a1847c1f07caf370579196259d69ac07f2e27b5b389b021";
  };
  cloudreve-postgresql = {
    image = "gh.mmm.fan/library/postgres";
    digest = "sha256:073e7c8b84e2197f94c8083634640ab37105effe1bc853ca4d5fbece3219b0e8";
  };
  rustdesk-api = {
    image = "gh.mmm.fan/lejianwen/rustdesk-api";
    digest = "sha256:ed35016339d3bcadf15c7bb3ae8490af1e3950c33f58fd2261ae009b94f5de45";
  };
  xpipe-webtop = {
    image = "gh.mmm.fan/ghcr.io/xpipe-io/xpipe-webtop";
    digest = "sha256:a78765c7718bfb7ee46fafc7e30fe96e5f347007b1f0d05ace56d0fff542d05d";
  };
}
