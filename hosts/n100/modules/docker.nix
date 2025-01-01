_: {
  virtualisation.docker.daemon.settings = {
    proxies = {
      "http-proxy" = "http://192.168.2.110:19234";
      "https-proxy" = "http://192.168.2.110:19234";
      "no-proxy" = "127.0.0.0/8,192.168.0.0/16,10.0.0.0/8,172.16.0.0/12";
    };
  };
}
