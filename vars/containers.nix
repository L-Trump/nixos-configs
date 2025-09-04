_: {
  nezha-server = {
    image = "registry.cn-shanghai.aliyuncs.com/naibahq/nezha-dashboard";
    tag = "v1.13.2";
    digest = "sha256:a42ab1da824ed65bcf9ac26814aecb45acf678f6aa47de7c31f8f7784ed6f1ae";
  };
  immich-machine-learning = {
    image = "gh.mmm.fan/ghcr.io/immich-app/immich-machine-learning";
    tag = "v1.140.0";
    latestTag = "release";
    digest = "sha256:20b1a58406882400c25909054628ee98565dde88e3e028235f5da493ca33b11a";
  };
  siyuan-server = {
    image = "gh.mmm.fan/b3log/siyuan";
    tag = "v3.3.0";
    digest = "sha256:95c64d9bff15b887b17cd60d3b0a9127613d265412b81de6f108609405c49e99";
  };
  cloudreve = {
    image = "gh.mmm.fan/cloudreve/cloudreve";
    tag = "4.6.0";
    digest = "sha256:31a69b3654942ee7b6a8450e0f775c5e917b7105a199a9e261749c1b20189e3f";
  };
  cloudreve-redis = {
    image = "gh.mmm.fan/library/redis";
    tag = "8.2.1-bookworm";
    digest = "sha256:cc2dfb8f5151da2684b4a09bd04b567f92d07591d91980eb3eca21df07e12760";
  };
  cloudreve-postgresql = {
    image = "gh.mmm.fan/library/postgres";
    tag = "17.6-trixie";
    digest = "sha256:29e0bb09c8e7e7fc265ea9f4367de9622e55bae6b0b97e7cce740c2d63c2ebc0";
  };
  rustdesk-api = {
    image = "gh.mmm.fan/lejianwen/rustdesk-api";
    tag = "v2.6.28";
    digest = "sha256:d96056624bd380567401621ee3921b546642db2aa8274501de151e2111859c4c";
  };
  xpipe-webtop = {
    image = "gh.mmm.fan/ghcr.io/xpipe-io/xpipe-webtop";
    digest = "sha256:ef5732612be689a128ebd0751e12f846051ee450a7616617ca40aad1962ef6a0";
  };
}
