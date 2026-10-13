{ config, ... }: {
  # Agent 默认配置。
  agents.defaults = {
    # 默认文本模型和 fallback 链。
    model = {
      # 新会话/未 pin 会话的主模型。
      primary = "sjtu/glm-5.3";

      # 主模型失败或过载时依次尝试的备用模型。
      fallbacks = [
        "minimax/MiniMax-M3.1-Flash-Preview"
        "opencode-go/deepseek-flash"
        "rhcg/gpt-6-luna"
      ];
    };

    # 默认视觉/图片理解模型。
    imageModel = {
      # 优先使用 MiniMax M3 处理图片/多模态。
      primary = "rhcg/gpt-6-sol";

      # 视觉模型 fallback。
      fallbacks = [
        "minimax/MiniMax-M3.1-Flash-Preview"
        "rhcg/gpt-6-luna"
      ];
    };

    # 模型别名，供 /model、子代理和工具配置中使用短名。
    models = {
      "minimax/MiniMax-M2.7-highspeed".alias = "m2.7";
      "minimax/MiniMax-M3".alias = "m3";
      "minimax/MiniMax-M3.1-Flash-Preview".alias = "m3.1f";
      "deepseek/deepseek-v4-flash".alias = "ds4f";
      "deepseek/deepseek-v4-pro".alias = "ds4p";
      # OpenCode Go 订阅的 DeepSeek 模型（与官方 API 区分）。
      "opencode-go/deepseek-v4-flash".alias = "ds4f-go";
      "opencode-go/deepseek-v4-pro".alias = "ds4p-go";
      # DeepSeek V4.1 Flash（OpenCode Go 侧 ID 为 deepseek-flash）。
      "opencode-go/deepseek-flash".alias = "ds4.1f-go";
      "sjtu/glm-5.3".alias = "glm5.3";
      "rhcg/gpt-6-luna" = {
        alias = "gpt6-luna";
        params = {
          parallel_tool_calls = true;
          text_verbosity = "low";
        };
      };
      "rhcg/gpt-6-sol" = {
        alias = "gpt6-sol";
        params = {
          parallel_tool_calls = true;
          text_verbosity = "low";
        };
      };
      "rhcg/gpt-5.6-luna" = {
        alias = "gpt5.6-luna";
        params = {
          parallel_tool_calls = true;
          text_verbosity = "low";
        };
      };
      "rhcg/gpt-5.6-sol" = {
        alias = "gpt5.6-sol";
        params = {
          parallel_tool_calls = true;
          text_verbosity = "low";
        };
      };
      "rhcg/gpt-5.6-terra" = {
        alias = "gpt5.6-terra";
        params = {
          parallel_tool_calls = true;
          text_verbosity = "low";
        };
      };
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

    # Live tool result 上限；同时影响 aggregate tool-result truncation 阈值（约为 4x）。
    # contextLimits = {
    #   toolResultMaxChars = 64000;
    # };

    # 上下文压缩策略（cache-ttl 模式）。
    contextPruning = {
      mode = "cache-ttl";
      # 和 cacheRetention="long" 对齐，5min 太短、1h 才好命中。
      ttl = "1h";
    };

    # 上下文压缩兜底策略：lossless-claw 作为 context engine 负责主路径，
    # OpenClaw 内置 compaction 仅保留轻量 fallback，避免 safeguard 质量审计拖慢溢出恢复。
    compaction = {
      mode = "default";
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

  # 显式 agent 配置，以 agent ID 为键。
  agents.entries.main = {
    # 不设置 agent identity，避免 Feishu 等消息渠道把 name/emoji 渲染成卡片 header。
    # 新版不支持仅供 Dashboard/WebChat 使用的 ui.assistant，暂不配置显示身份。
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
  };
}
