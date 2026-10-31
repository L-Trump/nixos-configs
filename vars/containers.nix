_: {
  nezha-server = {
    image = "registry.cn-shanghai.aliyuncs.com/naibahq/nezha-dashboard";
    digest = "sha256:c3de06b940fc2da673e7d29be3c742270440cb881675df84b35e474ab9799bf1";
  };
  immich-machine-learning = {
    image = "m.daocloud.io/ghcr.io/immich-app/immich-machine-learning";
    latestTag = "release";
    digest = "sha256:5b28c9352c8374b8a1ed96fbdd8d6755fea6e43510ec43fdf6538aa02ea40f56";
  };
  siyuan-server = {
    image = "m.daocloud.io/docker.io/b3log/siyuan";
    digest = "sha256:4f9c119048b9dc685603b04aebf9e9d513695014c9fbd834e0dadd1c22801235";
  };
  cloudreve = {
    image = "m.daocloud.io/docker.io/cloudreve/cloudreve";
    digest = "sha256:5c6c5baf7fa5bc6e1bb9a7509c09dde00e80b618d180244eb1d5f7e36b358ea2";
  };
  cloudreve-redis = {
    image = "m.daocloud.io/docker.io/library/redis";
    digest = "sha256:4764ce37931aac77c0d033680b339b19b4a4a81772204d268947cb851212d0ac";
  };
  cloudreve-postgresql = {
    image = "m.daocloud.io/docker.io/library/postgres";
    digest = "sha256:979bccfde35445db618c65107d27d08c6c21339d8dc3ad4c830c6633947be0e4";
  };
  rustdesk-api = {
    image = "gh.qninq.cn/lejianwen/rustdesk-api";
    digest = "sha256:ed35016339d3bcadf15c7bb3ae8490af1e3950c33f58fd2261ae009b94f5de45";
  };
  xpipe-webtop = {
    image = "gh.qninq.cn/ghcr.io/xpipe-io/xpipe-webtop";
    digest = "sha256:ad385a08044040335f971eb57d84465ead22fe9fd1120883e2f1fed6b8d1f1dc";
  };
  ncm-api = {
    image = "gh.qninq.cn/moefurina/ncm-api";
    digest = "sha256:2fcf4dc49313109a91f6cec99c6b36ebd17e8f1fdc89686121dfd14525937896";
  };
  sub2api = {
    image = "gh.qninq.cn/ghcr.io/wei-shaw/sub2api";
    digest = "sha256:969e5c0fddc13f52be2772ea86e8e03ee2261f80ff08495916ffff68292c8380";
  };
  sub2api-postgres = {
    image = "m.daocloud.io/docker.io/library/postgres";
    latestTag = "18-alpine";
    digest = "sha256:10a5c69a83035ab5239f5620d708520e8b28f5aa1f2b20143e6024532edadfb5";
  };
  sub2api-redis = {
    image = "m.daocloud.io/docker.io/library/redis";
    latestTag = "8-alpine";
    digest = "sha256:21090af93f8324db2f0f0f4f38a7c60369d47d917e000c3423d89d2ae2883537";
  };
}
