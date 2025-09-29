_: {
  nezha-server = {
    image = "registry.cn-shanghai.aliyuncs.com/naibahq/nezha-dashboard";
    digest = "sha256:a42ab1da824ed65bcf9ac26814aecb45acf678f6aa47de7c31f8f7784ed6f1ae";
  };
  immich-machine-learning = {
    image = "gh.mmm.fan/ghcr.io/immich-app/immich-machine-learning";
    latestTag = "release";
    digest = "sha256:cc94659771d7e394d6406ebb0664069f2523062fda4f934def31648e903c4de2";
  };
  siyuan-server = {
    image = "gh.mmm.fan/b3log/siyuan";
    digest = "sha256:9888dcc44b84f9a0e8c03d037aec080a8dc6f767dffb10debc36092b02e6d1b0";
  };
  cloudreve = {
    image = "gh.mmm.fan/cloudreve/cloudreve";
    digest = "sha256:31a69b3654942ee7b6a8450e0f775c5e917b7105a199a9e261749c1b20189e3f";
  };
  cloudreve-redis = {
    image = "gh.mmm.fan/library/redis";
    digest = "sha256:acb90ced0bd769b7c04cb4c32c4494ba7b3e0ee068bdbfff0eeb0d31c2a21078";
  };
  cloudreve-postgresql = {
    image = "gh.mmm.fan/library/postgres";
    digest = "sha256:0f4f20021a065d114083d1b95d9fb89ad847cbc4c3cc9238417815c7df42350f";
  };
  rustdesk-api = {
    image = "gh.mmm.fan/lejianwen/rustdesk-api";
    digest = "sha256:9493a5bfca63e8563457f36cdf66d8cec6cb9889016bb50a80145411b327e7c7";
  };
  xpipe-webtop = {
    image = "gh.mmm.fan/ghcr.io/xpipe-io/xpipe-webtop";
    digest = "sha256:a78765c7718bfb7ee46fafc7e30fe96e5f347007b1f0d05ace56d0fff542d05d";
  };
}
