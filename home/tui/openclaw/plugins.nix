{ lib }:
{
  # 需要 nix-openclaw 作为 runtime plugin 链接/启用的插件。
  runtimePlugins = [
    # 飞书 channel runtime plugin。
    "feishu"
    # Brave web search provider runtime plugin。
    "brave"
    "codex"
    # 本仓库 overlay 提供的第三方 Lossless Context Management 插件。
    "lossless-claw"
  ];

  runtimePluginSources = [ ];

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
        "lossless-claw"
        "workboard"
      ];

      # 只按 allow/entries/slots 发现 bundled plugins，避免旧兼容模式绕过 allowlist。
      bundledDiscovery = "allowlist";

      # 使用 lossless-claw 接管 context engine / compaction。
      slots.contextEngine = "lossless-claw";

      # 各插件启用状态和插件私有配置。
      entries = {
        telegram.enabled = true;
        feishu.enabled = true;
        minimax.enabled = true;
        deepseek.enabled = true;
        codex.enabled = true;
        workboard.enabled = true;
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

        # Graph Memory hook-only 记忆插件配置。
        graph-memory = {
          # 启用 graph-memory 插件。
          enabled = true;
          # graph-memory 需要读取会话消息并注入召回上下文；非 bundled 插件需显式授权 typed hooks。
          hooks = {
            allowConversationAccess = true;
            allowPromptInjection = true;
          };
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
            # 每隔多少 agent_end 触发周期性归纳/维护。
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
        # Lossless Context Management context-engine 插件。
        lossless-claw = {
          enabled = true;
          hooks = {
            allowConversationAccess = true;
            allowPromptInjection = true;
          };
          llm = {
            allowModelOverride = true;
            allowedModels = [
              "minimax/MiniMax-M2.7-highspeed"
              "rhcg/gpt-5.4-mini"
              "openai/gpt-5.4-mini"
            ];
          };
          subagent = {
            allowModelOverride = true;
            allowedModels = [
              "minimax/MiniMax-M2.7-highspeed"
              "rhcg/gpt-5.4-mini"
              "openai/gpt-5.4-mini"
            ];
          };
          config = {
            freshTailCount = 64;
            leafChunkTokens = 40000;
            newSessionRetainDepth = 2;
            contextThreshold = 0.75;
            cacheAwareCompaction = {
              "enabled" = true;
              "cacheTTLSeconds" = 300;
            };
            ignoreSessionPatterns = [
              "agent:*:cron:**"
            ];
            transcriptGcEnabled = false;
            proactiveThresholdCompactionMode = "deferred";
            summaryModel = "minimax/MiniMax-M2.7-highspeed";
            expansionModel = "minimax/MiniMax-M2.7-highspeed";
            delegationTimeoutMs = 180000;
            summaryTimeoutMs = 60000;
            summaryCallWindowMs = 600000;
            summaryMaxCallsPerWindow = 24;
            summarySpendBackoffMs = 1800000;
            # 自动 rotate 超大 session JSONL，避免 session 累积拖慢 gateway 启动和 dashboard 渲染。
            # 2 MiB 是 lossless-claw 推荐默认阈值；首次启用保留 SQLite backup 更稳妥。
            autoRotateSessionFiles = {
              enabled = true;
              createBackups = true;
              sizeBytes = 2097152;
              startup = "rotate";
              runtime = "rotate";
            };
            # LCM v0.12.0+: 压缩 summarization 前剥离 graph-memory 通过 prependContext
            # 注入的 <gm_memory> 块，避免历史召回上下文污染 compacted summaries。
            stripInjectedContextTags = [ "gm_memory" ];
          };
        };
        # 禁用 memory-core，避免与 graph-memory 记忆插件重叠。
        memory-core.enabled = false;
      };
    };
  };
}
