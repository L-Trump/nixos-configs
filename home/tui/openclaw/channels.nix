{ myvars }:
{
  # Telegram 渠道配置。
  channels.telegram = {
    # 启用 Telegram channel。
    enabled = true;

    # 私聊只允许已 pairing 的用户。
    dmPolicy = "pairing";

    # Telegram bot token，从 agenix SecretRef 获取。
    botToken = {
      source = "file";
      provider = "openclaw";
      id = "/channels/telegram/botToken";
    };

    # 群聊只允许 allowlist。
    groupPolicy = "allowlist";

    # Telegram 流式输出配置。
    streaming = {
      # partial 模式：边生成边更新部分内容。
      mode = "partial";
    };

    # exec 审批消息投递策略。
    execApprovals = {
      # 启用命令审批。
      enabled = true;
      # 审批发送到 DM，避免在群里暴露命令细节。
      target = "dm";
    };
  };

  # 飞书渠道配置。
  channels.feishu = {
    # 启用 Feishu channel。
    enabled = true;
    # 飞书应用 ID，不是 secret。
    appId = myvars.openclaw.channels.feishu.appId;
    # 飞书应用 secret，从 agenix SecretRef 获取。
    appSecret = {
      source = "file";
      provider = "openclaw";
      id = "/channels/feishu/appSecret";
    };
    # 使用长连接 websocket 模式接收事件。
    connectionMode = "websocket";
    # 飞书域选择。
    domain = "feishu";
    # webhook 模式下的事件路径；保留用于兼容/回退。
    webhookPath = "/feishu/events";
    # 私聊只允许 pairing 用户。
    dmPolicy = "pairing";
    # 群聊开放接入，由群聊行为规则和命令 allowFrom 控制实际响应。
    groupPolicy = "open";
    # 只发送自己消息相关的 reaction 通知。
    reactionNotifications = "own";
    # 启用输入状态提示。
    typingIndicator = true;
    # 解析发送者名称，提升群聊可读性。
    resolveSenderNames = true;
    # 群聊中不强制 @ 才处理；由上层群聊行为策略控制是否回复。
    requireMention = false;
    # 启用飞书流式输出/卡片更新。
    streaming = true;
    # 群聊按 topic/thread 划分 session scope。
    groupSessionScope = "group_topic";

    # 使用 lark-cli / lark-* skills 处理飞书 API；禁用 OpenClaw Feishu 原生工具，减少上下文占用和工具选择冲突。
    tools = {
      doc = false;
      chat = false;
      wiki = false;
      drive = false;
      perm = false;
      scopes = false;
      bitable = false;
      base = false;
    };
  };
}
