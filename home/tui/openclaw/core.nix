{
  # 日志配置。
  logging = {
    # 日志级别；debug 便于排查 Gateway、插件和模型调用问题。
    level = "debug";

    # 敏感信息脱敏模式；off 保留完整调试信息，后续可考虑改为 tools。
    redactSensitive = "off";
  };

  # 浏览器/网页访问安全策略。
  browser = {
    # 允许浏览器/网页工具访问私有网段；用于访问本机/LAN 服务，需信任调用场景。
    ssrfPolicy.dangerouslyAllowPrivateNetwork = true;
  };
}
