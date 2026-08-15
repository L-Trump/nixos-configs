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
    digest = "sha256:908faf8ec55d391d95244982c081edabbaec118552d01fc3dc189d098cc0ffc8";
  };
  cloudreve = {
    image = "m.daocloud.io/docker.io/cloudreve/cloudreve";
    digest = "sha256:f7a464100bf6325e9ba58cb2b0ee60f9a24c58fc2eb90647720bc4b8f3cddd9a";
  };
  cloudreve-redis = {
    image = "m.daocloud.io/docker.io/library/redis";
    digest = "sha256:077ba791400f390cb96d9d419d90259d5e72e697fca7abc3bbde6d83285d7346";
  };
  cloudreve-postgresql = {
    image = "m.daocloud.io/docker.io/library/postgres";
    digest = "sha256:3a82e1f56c8f0f5616a11103ac3d47e632c3938698946a7ad26da0df1334744a";
  };
  rustdesk-api = {
    image = "gh.qninq.cn/lejianwen/rustdesk-api";
    digest = "sha256:ed35016339d3bcadf15c7bb3ae8490af1e3950c33f58fd2261ae009b94f5de45";
  };
  xpipe-webtop = {
    image = "gh.qninq.cn/ghcr.io/xpipe-io/xpipe-webtop";
    digest = "sha256:519367f54f07b556da479d130fb52c0f09916606ef48af243798487273bbe1d5";
  };
  ncm-api = {
    image = "gh.qninq.cn/moefurina/ncm-api";
    digest = "sha256:d5cd90a2ae47261ebf9d6f2738ffc91accd6f9ae700d24b89a25902166642897";
  };
  sub2api = {
    image = "gh.qninq.cn/ghcr.io/wei-shaw/sub2api";
    digest = "sha256:c9ee04bc92f916c9fce269c23e01bbde4ca6aee190e99221114224e37aa91ed9";
  };
  sub2api-postgres = {
    image = "m.daocloud.io/docker.io/library/postgres";
    latestTag = "18-alpine";
    digest = "sha256:9a8afca54e7861fd90fab5fdf4c42477a6b1cb7d293595148e674e0a3181de15";
  };
  sub2api-redis = {
    image = "m.daocloud.io/docker.io/library/redis";
    latestTag = "8-alpine";
    digest = "sha256:e8eb6f2980c06c6a25c08f62cb2e00dc7d2fead9aa492cfdd8b54a42109ae0f2";
  };
}
