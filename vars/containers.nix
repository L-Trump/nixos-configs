_: {
  nezha-server = {
    image = "registry.cn-shanghai.aliyuncs.com/naibahq/nezha-dashboard";
    digest = "sha256:4d6e72abda083ff3bd51aa25019d0eb433941e30c3fdb85c033f9c751fecfb46";
  };
  immich-machine-learning = {
    image = "m.daocloud.io/ghcr.io/immich-app/immich-machine-learning";
    latestTag = "release";
    digest = "sha256:379e31b8c75107b0af8141904baa8cc933d7454b88fdb204265ef11749d7d908";
  };
  siyuan-server = {
    image = "m.daocloud.io/docker.io/b3log/siyuan";
    digest = "sha256:d63485de0b47af96aa7b9fc2dc9d53cb682f114510b2b0e8068f8ea11bfd4579";
  };
  cloudreve = {
    image = "m.daocloud.io/docker.io/cloudreve/cloudreve";
    digest = "sha256:70debed86997389b00624d0ac2fe25ecbaca8dbe444157c6660bc93ca940cc9d";
  };
  cloudreve-redis = {
    image = "m.daocloud.io/docker.io/library/redis";
    digest = "sha256:43355efd22490e31ca14b9d569367d05121e2be61fd8e47937563ae2a80952ae";
  };
  cloudreve-postgresql = {
    image = "m.daocloud.io/docker.io/library/postgres";
    digest = "sha256:5ec39c188013123927f30a006987c6b0e20f3ef2b54b140dfa96dac6844d883f";
  };
  rustdesk-api = {
    image = "docker.linkos.org/lejianwen/rustdesk-api";
    digest = "sha256:ed35016339d3bcadf15c7bb3ae8490af1e3950c33f58fd2261ae009b94f5de45";
  };
  xpipe-webtop = {
    image = "ghcr.linkos.org/xpipe-io/xpipe-webtop";
    digest = "sha256:a5de465f7020d13e45014798c428751c979fc857686446bccebc18f620fd7354";
  };
}
