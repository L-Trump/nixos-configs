_: {
  nezha-server = {
    image = "registry.cn-shanghai.aliyuncs.com/naibahq/nezha-dashboard";
    digest = "sha256:8a2cfff23fa807df5e23c5557fde571fe0f57256cd176781d69e2011e2ab270c";
  };
  immich-machine-learning = {
    image = "m.daocloud.io/ghcr.io/immich-app/immich-machine-learning";
    latestTag = "release";
    digest = "sha256:60dfcf266a9ef3b7376f5678e8c980d4fb61db5fc48c078fe8a326ab1535d60d";
  };
  siyuan-server = {
    image = "m.daocloud.io/docker.io/b3log/siyuan";
    digest = "sha256:6ab17ed3ca40f646eab674f3fdcc459ff186614c02434b9b07709bd4cc98716d";
  };
  cloudreve = {
    image = "m.daocloud.io/docker.io/cloudreve/cloudreve";
    digest = "sha256:d8e2ab58e163f760b0890f589d294c994f45e3eeac6563ee644a90647d6f9554";
  };
  cloudreve-redis = {
    image = "m.daocloud.io/docker.io/library/redis";
    digest = "sha256:298e5b3bc566bade82f46ad5511777a4a07a294097ce16ada2f6a42be5239df5";
  };
  cloudreve-postgresql = {
    image = "m.daocloud.io/docker.io/library/postgres";
    digest = "sha256:4ef4dbc939d61acea57712655ddb4b4ab27419c913f94cca0cd57cb3ea3c2280";
  };
  rustdesk-api = {
    image = "gh.qninq.cn/lejianwen/rustdesk-api";
    digest = "sha256:ed35016339d3bcadf15c7bb3ae8490af1e3950c33f58fd2261ae009b94f5de45";
  };
  xpipe-webtop = {
    image = "gh.qninq.cn/ghcr.io/xpipe-io/xpipe-webtop";
    digest = "sha256:76a27e7251944b84143d77c715ea9ae75b1ea74cc64d854119854581b5437e92";
  };
  ncm-api = {
    image = "gh.qninq.cn/moefurina/ncm-api";
    digest = "sha256:7d0aa12f2b2e754d95fc8a5e649c9024a35da539035fd76b36ea4a6eaf6ad06f";
  };
  sub2api = {
    image = "gh.qninq.cn/ghcr.io/wei-shaw/sub2api";
    digest = "sha256:5d5c2cdd45e8c944fec9aa5d379b5361f704dfcdf6d3be4f3446242d2e133cc2";
  };
  sub2api-postgres = {
    image = "m.daocloud.io/docker.io/library/postgres";
    latestTag = "18-alpine";
    digest = "sha256:d3e1620b530c944afa6e887d22eb899824da68e19c52024bf98f5220c88a65b2";
  };
  sub2api-redis = {
    image = "m.daocloud.io/docker.io/library/redis";
    latestTag = "8-alpine";
    digest = "sha256:becdda6c7f4b3fb42e42fd7f120bbf5c54c4caaaf16f26da24e4563d2c1f0576";
  };
}
