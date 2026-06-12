{ config }:
{
  # Skill 系统配置。
  skills = {
    # 允许 workspace/skills 中指向 .agents/skills 的 symlink，消除 lark-cli skills 的 symlink-escape 警告。
    load.allowSymlinkTargets = [
      "${config.home.homeDirectory}/.openclaw/workspace/.agents/skills"
    ];

    # 允许加载的内置/bundled skills。
    allowBundled = [
      "clawhub"
      "healthcheck"
      "node-connect"
      "skill-creator"
      "taskflow"
      "taskflow-inbox-triage"
      "tmux"
      "video-frames"
      "coding-agent"
      "gh-issues"
      "mcporter"
    ];

    # 显式启用 Zotero 增强 skill entry。
    entries.zotero-enhanced.enabled = true;

    # 使用 lark-cli / lark-* skills 后，禁用旧 OpenClaw Feishu 原生 skills，避免和 lark-cli 重叠。
    entries.feishu-doc.enabled = false;
    entries.feishu-drive.enabled = false;
    entries.feishu-wiki.enabled = false;
    entries.feishu-perm.enabled = false;
  };
}
