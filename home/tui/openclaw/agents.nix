{ config, ... }:
{
  # Agent 默认配置。
  agents.defaults = {
    # 默认文本模型和 fallback 链。
    model = {
      # 新会话/未 pin 会话的主模型。
      primary = "minimax/MiniMax-M2.7-highspeed";

      # 主模型失败或过载时依次尝试的备用模型。
      fallbacks = [
        "minimax/MiniMax-M3"
        "rhcg/gpt-5.4"
      ];
    };

    # 默认视觉/图片理解模型。
    imageModel = {
      # 优先使用 MiniMax M3 处理图片/多模态。
      primary = "minimax/MiniMax-M3";

      # 视觉模型 fallback。
      fallbacks = [ "rhcg/gpt-5.4" ];
    };

    # 模型别名，供 /model、子代理和工具配置中使用短名。
    models = {
      "minimax/MiniMax-M2.7-highspeed".alias = "m2.7";
      "minimax/MiniMax-M3".alias = "m3";
      "deepseek/deepseek-v4-flash".alias = "ds4f";
      "deepseek/deepseek-v4-pro".alias = "ds4p";
      # Volcano Engine Ark Coding Plan models from the official OpenClaw example.
      "volcengine-plan/ark-code-latest".alias = "ark";
      "volcengine-plan/doubao-seed-2.0-code".alias = "seedcode";
      "volcengine-plan/doubao-seed-2.0-pro".alias = "seedpro";
      "volcengine-plan/doubao-seed-2.0-lite".alias = "seedlite";
      "volcengine-plan/doubao-seed-code".alias = "seed1code";
      "volcengine-plan/glm-5.1".alias = "vol-glm5.1";
      "volcengine-plan/minimax-m3".alias = "vol-m3";
      "volcengine-plan/kimi-k2.6".alias = "vol-k2.6";
      "volcengine-plan/deepseek-v4-flash".alias = "vol-ds4f";
      "volcengine-plan/deepseek-v4-pro".alias = "vol-ds4p";
      "rhcg/gpt-5.5".alias = "gpt5.5";
      "rhcg/gpt-5.4".alias = "gpt5.4";
      "rhcg/gpt-5.4-mini".alias = "gpt5.4m";
      "openai/gpt-5.5" = { };
      "openai/gpt-5.4" = { };
      "openai/gpt-5.4-mini" = { };
    };

    # 默认 workspace，AGENTS.md / SOUL.md 等上下文从这里读取。
    workspace = "${config.home.homeDirectory}/.openclaw/workspace";

    # 单个 bootstrap 文件最大读取字符数。
    bootstrapMaxChars = 25000;

    # 所有 bootstrap 文件合计最大读取字符数。
    bootstrapTotalMaxChars = 150000;

    # 默认 agent 模型调用参数：把 Anthropic / OpenAI 系列的 prompt cache
    params = {
      cacheRetention = "long";
    };

    # 上下文压缩策略（cache-ttl 模式）。
    contextPruning = {
      mode = "cache-ttl";
      # 和 cacheRetention="long" 对齐，5min 太短、1h 才好命中。
      ttl = "1h";
      # softTrim/hardClear 阈值：context 用到 70% 先软剪，90% 再硬清。
      softTrimRatio = 0.7;
      hardClearRatio = 0.9;
    };

    # 上下文压缩策略。
    compaction = {
      # safeguard 模式：保守压缩，降低重要上下文丢失概率。
      mode = "safeguard";
      # 压缩时预留的输出/工具调用 token 下限。
      reserveTokensFloor = 20000;
      # 压缩任务最长等待时间。
      timeoutSeconds = 1200;
    };

    # 默认允许 elevated 工具能力；具体执行仍受 OpenClaw 审批/策略约束。
    elevatedDefault = "full";

    # 主 agent 心跳配置。
    heartbeat = {
      # 心跳间隔。
      every = "30m";
      # 心跳默认不主动发送到聊天目标。
      target = "none";
      # 心跳使用隔离 session，避免污染主会话上下文。
      isolatedSession = true;
    };

    # 主 agent 同时处理的最大任务数。
    maxConcurrent = 4;
    # 子代理最大并发数。
    subagents.maxConcurrent = 8;
  };

  # 显式 agent 列表。
  agents.list = [
    {
      id = "main";
      # 不设置 agent identity，避免 Feishu 等消息渠道把 name/emoji 渲染成卡片 header。
      # Dashboard/WebChat 的显示偏好应走 UI 自身设置，而不是 agent runtime identity。
      # 主 agent 工具授权。
      tools = {
        # 使用 full 工具 profile。
        profile = "full";
        # 在 full profile 之外额外允许的工具。
        alsoAllow = [
          "canvas"
          "message"
          "agents_list"
          "tts"
        ];
        # elevated 工具配置。
        elevated = {
          # 允许 elevated 工具能力。
          enabled = true;
          # 限定允许来源；空集表示沿用全局/运行时审批策略。
          allowFrom = { };
        };
      };
    }
  ];
}
