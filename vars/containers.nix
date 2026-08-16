_: {
  nezha-server = {
    image = "registry.cn-shanghai.aliyuncs.com/naibahq/nezha-dashboard";
    digest = "sha256:afd4058d06e2eec8da38ee3c159a6aae4ffeb3b8b8dcb02dbdc303b547aef76d";
  };
  immich-machine-learning = {
    image = "m.daocloud.io/ghcr.io/immich-app/immich-machine-learning";
    latestTag = "release";
    digest = "sha256:5a0839dc5303cd7215bcd2180a26aed3af41675aefb3e75e5157e9f10ad16e6e";
  };
  siyuan-server = {
    image = "m.daocloud.io/docker.io/b3log/siyuan";
    digest = "sha256:a2da59a722da6a2243f0c2a99286d9c8e73cc47dbc8757cc81ffd1137d6461a0";
  };
  cloudreve = {
    image = "m.daocloud.io/docker.io/cloudreve/cloudreve";
    digest = "sha256:f7a464100bf6325e9ba58cb2b0ee60f9a24c58fc2eb90647720bc4b8f3cddd9a";
  };
  cloudreve-redis = {
    image = "m.daocloud.io/docker.io/library/redis";
    digest = "sha256:344e3945a0b431c8ff1eecd58c5573538126bd756f02fc7e218ddf1fc2546366";
  };
  cloudreve-postgresql = {
    image = "m.daocloud.io/docker.io/library/postgres";
    digest = "sha256:7157393f508fd8eb46119937fab39813783fe3e7d4c6316c45c12ce2ea25e61d";
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
    digest = "sha256:d5cd90a2ae47261ebf9d6f2738ffc91accd6f9ae700d24b89a25902166642897";
  };
  sub2api = {
    image = "gh.qninq.cn/ghcr.io/wei-shaw/sub2api";
    digest = "sha256:905baf250580334dacd902471f61da7b8b1e5da57e3c8c1769489952d51771a1";
  };
  sub2api-postgres = {
    image = "m.daocloud.io/docker.io/library/postgres";
    latestTag = "18-alpine";
    digest = "sha256:a1d02e4bd40c94d3bf2bdd3678c137388e76d9efcd23c285e9429d336a834b44";
  };
  sub2api-redis = {
    image = "m.daocloud.io/docker.io/library/redis";
    latestTag = "8-alpine";
    digest = "sha256:978f0e01593e65eed801f2402944efcd936d43b5027e4908a7897baf88ed6241";
  };
}
