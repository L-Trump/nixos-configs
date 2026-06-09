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

    # 渠道健康检查间隔；0 表示关闭定期检查。
    channelHealthCheckMinutes = 0;

    # 配对节点禁止执行的高敏命令。
    nodes.denyCommands = [
      "camera.snap"
      "camera.clip"
      "screen.record"
      "contacts.add"
      "calendar.add"
      "reminders.add"
      "sms.send"
    ];

    # 配置 reload 策略；支持 hot reload 的字段尽量热加载。
    reload.mode = "hot";
  };
}
