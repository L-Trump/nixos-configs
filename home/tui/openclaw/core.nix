{
  # 日志配置。
  logging = {
    # 日志级别；debug 便于排查 Gateway、插件和模型调用问题。
    level = "debug";

  };

  proxy = {
    enabled = true;
    proxyUrl = "http://127.0.0.1:7893";
  };

  # 浏览器/网页访问安全策略。
  browser = {
    # 允许浏览器/网页工具访问私有网段；用于访问本机/LAN 服务，需信任调用场景。
    ssrfPolicy.dangerouslyAllowPrivateNetwork = true;
  };
}
