{
  # 需要 nix-openclaw 作为 runtime plugin 链接/启用的插件。
  runtimePlugins = [
    # 飞书 channel runtime plugin。
    "feishu"
    # Brave web search provider runtime plugin。
    "brave"
    "codex"
  ];

  # 插件相关 OpenClaw runtime 配置。
  config = {
    plugins = {
      # 允许加载/配置的插件 ID 列表。
      allow = [
        "brave"
        "browser"
        "deepseek"
        "execution-validator-plugin"
        "feishu"
        "google"
        "graph-memory"
        "minimax"
        "telegram"
        "codex"
        "openai"
      ];

      # 指定上下文引擎插件为 graph-memory。
      slots.contextEngine = "graph-memory";

      # 只按 allow/entries/slots 发现 bundled plugins，避免旧兼容模式绕过 allowlist。
      bundledDiscovery = "allowlist";

      # 各插件启用状态和插件私有配置。
      entries = {
        telegram.enabled = true;
        feishu.enabled = true;
        minimax.enabled = true;
        deepseek.enabled = true;
        codex.enabled = true;
        google = {
          enabled = true;
          # Google web search API key，从 agenix SecretRef 获取。
          config.webSearch.apiKey = {
            source = "file";
            provider = "openclaw";
            id = "/plugins/google/webSearch/apiKey";
          };
        };
        brave = {
          enabled = true;
          # Brave web search API key，从 agenix SecretRef 获取。
          config.webSearch.apiKey = {
            source = "file";
            provider = "openclaw";
            id = "/plugins/brave/webSearch/apiKey";
          };
        };

        # Graph Memory 上下文引擎配置。
        graph-memory = {
          # 启用 graph-memory 插件。
          enabled = true;
          # graph-memory 插件私有配置。
          config = {
            # 记忆抽取/归纳使用的 LLM 配置。
            llm = {
              # LLM API key，从 agenix SecretRef 获取。
              apiKey = {
                source = "file";
                provider = "openclaw";
                id = "/plugins/graph-memory/llm/apiKey";
              };
              # graph-memory 使用的 LLM 模型名。
              model = "MiniMax-M2.7-highspeed";
              # graph-memory 直接调用 MiniMax OpenAI-compatible endpoint。
              baseURL = "https://api.minimaxi.com/v1";
            };

            # 语义检索/去重使用的 embedding 配置。
            embedding = {
              # Embedding API key，从 agenix SecretRef 获取。
              apiKey = {
                source = "file";
                provider = "openclaw";
                id = "/plugins/graph-memory/embedding/apiKey";
              };
              # Jina embedding 模型。
              model = "jina-embeddings-v5-text-small";
              baseURL = "https://api.jina.ai/v1";
              # 向量维度，需与数据库中 embedding 维度一致。
              dimensions = 1024;
              # 查询文本 embedding task。
              taskQuery = "retrieval.query";
              # 语料/节点文本 embedding task。
              taskPassage = "retrieval.passage";
              # 使用归一化向量，便于余弦相似度检索。
              normalized = true;
            };

            # graph-memory SQLite 数据库路径。
            dbPath = "~/.openclaw/graph-memory.db";
            # 每隔多少 afterTurn 触发周期性归纳/维护。
            compactTurnCount = 7;
            # 单次召回最大节点数。
            recallMaxNodes = 15;
            # 图遍历召回最大深度。
            recallMaxDepth = 2;
            # 兼容旧配置的近期尾部消息数量参数。
            freshTailCount = 10;
            # 向量去重阈值，越高越严格。
            dedupThreshold = 0.9;
            # PageRank 阻尼系数。
            pagerankDamping = 0.85;
            # PageRank 迭代次数。
            pagerankIterations = 20;
            # 输出 graph-memory 注入上下文预览日志，方便排障。
            debugContextPreview = true;
          };
        };
        # 禁用 browser 插件；当前优先使用外部/agent-browser 方案。
        browser.enabled = false;
        # 启用执行校验插件。
        execution-validator-plugin.enabled = true;
        # 禁用 memory-core，避免与 graph-memory context engine 重叠。
        memory-core.enabled = false;
      };
    };
  };
}
