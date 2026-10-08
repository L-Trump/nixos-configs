{ myvars }:
{
  # Gateway 服务配置。
  gateway = {
    # Gateway HTTP/WebSocket 监听端口。
    port = 18789;

    # local 模式：本机 Gateway，不走远端托管模式。
    mode = "local";

    # 绑定到 LAN，可供局域网设备访问；更保守可改为 loopback。
    bind = "lan";

    # 公网 Caddy 经 easytier 转发请求；仅信任这台代理的源地址，
    # 由其重建 X-Forwarded-For，其他来源的转发头继续被拒绝。
    trustedProxies = [ myvars.networking.hostsAddr.easytier.aliyun-vm-sh.ipv4 ];

    # Control UI / WebChat 允许的浏览器 Origin。
    controlUi.allowedOrigins = myvars.openclaw.gateway.controlUi.allowedOrigins;

    # Gateway 认证配置。
    auth = {
      mode = "token";
      # Gateway auth token，从 agenix SecretRef 获取。
      token = {
        source = "file";
        provider = "openclaw";
        id = "/gateway/auth/token";
      };
    };

    # 配对节点禁止执行的高敏命令。
    nodes.commands.deny = [
      "camera.snap"
      "camera.clip"
      "screen.record"
      "contacts.add"
      "calendar.add"
      "reminders.add"
      "sms.send"
    ];

    # 支持热加载的配置即时生效，其他变更按需重启 Gateway。
    reload.mode = "hybrid";
  };
}
