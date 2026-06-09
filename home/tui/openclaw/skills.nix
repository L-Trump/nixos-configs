{
  # Skill 系统配置。
  skills = {
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
  };
}
