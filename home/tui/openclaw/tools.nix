{ myvars }:
{
  # 工具能力配置。
  tools = {
    # 工具 profile；full 暴露完整工具集合，再由运行时策略过滤。
    profile = "full";

    # Web 搜索/抓取工具配置。
    web = {
      # 搜索工具配置。
      search = {
        # 启用 web_search。
        enabled = true;
        # 默认搜索 provider。
        provider = "brave";
      };
      # 启用 web_fetch。
      fetch.enabled = true;
    };

    # 允许查看/操作所有可见 session，便于跨 session 管理和排障。
    sessions.visibility = "all";

    # elevated 工具全局配置。
    elevated = {
      # 启用 elevated 能力。
      enabled = true;
      # 限定 elevated 来源；空集表示使用运行时审批/默认策略。
      allowFrom = { };
    };
  };

  # 消息渲染和群聊消息策略。
  messages = {
    # 群聊中自动决定可见回复策略。
    groupChat.visibleReplies = "automatic";
    # ACK reaction 只在群聊 mention 场景使用，降低噪音。
    ackReactionScope = "group-mentions";
  };

  # Session 生命周期和隔离策略。
  session = {
    # DM session 按 channel + peer 隔离。
    dmScope = "per-channel-peer";

    # lossless-claw README 推荐的兜底 idle reset：7 天无活动后 reset。
    # resetByChannel / resetByType 会覆盖特定 channel/type；这里覆盖 direct 等默认场景。
    reset = {
      mode = "idle";
      idleMinutes = 10080;
    };

    # Dashboard/WebChat session 按 channel 特判为 7 天 idle reset。
    # 不设置 resetByType.direct，保留 Feishu 私聊等 direct 会话的默认 daily reset。
    resetByChannel = {
      webchat = {
        mode = "idle";
        idleMinutes = 10080;
      };
      # 保险覆盖 dashboard 原始 provider/channel key；运行态目前主要命中 webchat。
      dashboard = {
        mode = "idle";
        idleMinutes = 10080;
      };
    };

    # 按 session 类型设置自动 reset 策略。
    resetByType = {
      # 群聊 session 空闲 7 天后 reset。
      group = {
        mode = "idle";
        idleMinutes = 10080;
      };
      # thread session 空闲 7 天后 reset。
      thread = {
        mode = "idle";
        idleMinutes = 10080;
      };
    };
  };

  # 诊断配置。默认保持关闭；需要排查 prompt cache 行为时可临时启用。
  diagnostics = {
    # 关闭 cache trace，避免长 jsonl 持续写入。
    cacheTrace = {
      enabled = false;
    };
  };

  # 用户命令和 slash/native command 行为。
  commands = {
    # native command 自动启用策略。
    native = "auto";
    # skill 中声明的 native command 自动启用策略。
    nativeSkills = "auto";
    # 允许通过命令触发 restart 流程；实际重启仍遵守确认规则。
    restart = true;
    # owner 显示原始 ID，便于排查授权。
    ownerDisplay = "raw";
    # 允许执行命令的飞书用户 open_id allowlist。
    allowFrom.feishu = myvars.openclaw.commands.allowFrom.feishu;
  };
}
