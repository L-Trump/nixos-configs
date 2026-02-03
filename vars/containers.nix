_: {
  nezha-server = {
    image = "registry.cn-shanghai.aliyuncs.com/naibahq/nezha-dashboard";
    digest = "sha256:870adc32957498f23bf0a3554cab884a3505c83c77b7a4c5f8c862f3e62a2351";
  };
  immich-machine-learning = {
    image = "m.daocloud.io/ghcr.io/immich-app/immich-machine-learning";
    latestTag = "release";
    digest = "sha256:531d2bccbe20d0412496e36455715a18d692911eca5e2ee37d32e1e4f50e14bb";
  };
  siyuan-server = {
    image = "m.daocloud.io/docker.io/b3log/siyuan";
    digest = "sha256:d3981892e6e4021320a6da80f2c7e95e08759c355077bac57f3cf1cf4145ea2b";
  };
  cloudreve = {
    image = "m.daocloud.io/docker.io/cloudreve/cloudreve";
    digest = "sha256:6fc2945b016005d69de1bfd9c327c66a58362d69fc4ee662414f0e3ee1296a41";
  };
  cloudreve-redis = {
    image = "m.daocloud.io/docker.io/library/redis";
    digest = "sha256:73dad4271642c5966db88db7a7585fae7cf10b685d1e48006f31e0294c29fdd7";
  };
  cloudreve-postgresql = {
    image = "m.daocloud.io/docker.io/library/postgres";
    digest = "sha256:5773fe724c49c42a7a9ca70202e11e1dff21fb7235b335a73f39297d200b73a2";
  };
  rustdesk-api = {
    image = "docker.linkos.org/lejianwen/rustdesk-api";
    digest = "sha256:ed35016339d3bcadf15c7bb3ae8490af1e3950c33f58fd2261ae009b94f5de45";
  };
  xpipe-webtop = {
    image = "gh.qninq.cn/ghcr.io/xpipe-io/xpipe-webtop";
    digest = "sha256:b7198458c962a35ef360e1e68f6c3837169b64b607d13ef105a83b42ba20e70e";
  };
  ncm-api = {
    image = "docker.linkos.org/moefurina/ncm-api";
    digest = "sha256:7842091b794d24801d054d5b7cd47bd4fe8c12aed9dae0aa5f0fe76dc15463d8";
  };
}
