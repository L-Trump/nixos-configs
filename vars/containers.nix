_: {
  nezha-server = {
    image = "registry.cn-shanghai.aliyuncs.com/naibahq/nezha-dashboard";
    digest = "sha256:89391a7843df1f679abdd773c1c3518e24da76e8db4f7ec13d5a183d28ec46b7";
  };
  immich-machine-learning = {
    image = "m.daocloud.io/ghcr.io/immich-app/immich-machine-learning";
    latestTag = "release";
    digest = "sha256:5a0839dc5303cd7215bcd2180a26aed3af41675aefb3e75e5157e9f10ad16e6e";
  };
  siyuan-server = {
    image = "m.daocloud.io/docker.io/b3log/siyuan";
    digest = "sha256:8e6395e3c328b57bcb47c101e67a7e7fbb02d8a7b748ba21f583309d03dbe539";
  };
  cloudreve = {
    image = "m.daocloud.io/docker.io/cloudreve/cloudreve";
    digest = "sha256:f7a464100bf6325e9ba58cb2b0ee60f9a24c58fc2eb90647720bc4b8f3cddd9a";
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
    digest = "sha256:7ee287ea02fa8607849d7686ac725871f013c3b492525b8b061dc4745f1ccdea";
  };
  ncm-api = {
    image = "gh.qninq.cn/moefurina/ncm-api";
    digest = "sha256:7d0aa12f2b2e754d95fc8a5e649c9024a35da539035fd76b36ea4a6eaf6ad06f";
  };
  sub2api = {
    image = "gh.qninq.cn/ghcr.io/wei-shaw/sub2api";
    digest = "sha256:cff6bc3ed1a6eba7ea240bad8637cf12856161a4efb98be0882c2fa7aff371e3";
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
