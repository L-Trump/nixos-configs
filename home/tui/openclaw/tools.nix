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
