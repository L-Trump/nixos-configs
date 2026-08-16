{ myvars }: {
  # 模型 provider 配置；渲染到 openclaw.json 的 models.providers。
  models.providers = {
    # MiniMax provider。
    minimax = {
      baseUrl = "https://api.minimaxi.com/anthropic";
      # MiniMax API key，从 agenix SecretRef 获取。
      apiKey = {
        source = "file";
        provider = "openclaw";
        id = "/models/minimax/apiKey";
      };
      api = "anthropic-messages";
      authHeader = true;
      models = [
        {
          id = "MiniMax-M3";
          # UI 展示名称。
          name = "MiniMax M3";
          # 标记支持 reasoning。
          reasoning = true;
          # 支持输入模态。
          input = [
            "text"
            "image"
            "video"
          ];
          # 上下文窗口大小。
          contextWindow = 524288;
          # 单次最大输出 token。
          maxTokens = 131072;
        }
        {
          id = "MiniMax-M2.7-highspeed";
          name = "MiniMax M2.7";
          reasoning = true;
          input = [
            "text"
            "image"
          ];
          contextWindow = 204800;
          maxTokens = 131072;
          api = "anthropic-messages";
        }
      ];
    };

    # DeepSeek provider。
    deepseek = {
      baseUrl = "https://api.deepseek.com";
      api = "openai-completions";
      # DeepSeek API key，从 agenix SecretRef 获取。
      apiKey = {
        source = "file";
        provider = "openclaw";
        id = "/models/deepseek/apiKey";
      };
      models = [
        {
          id = "deepseek-v4-flash";
          name = "DeepSeek V4 Flash";
          reasoning = true;
          input = [ "text" ];
          cost = {
            input = 0.14;
            output = 0.28;
            cacheRead = 0.028;
            cacheWrite = 0;
          };
          contextWindow = 1000000;
          maxTokens = 384000;
          # OpenAI-compatible 兼容能力声明。
          compat = {
            supportsReasoningEffort = true;
            supportsUsageInStreaming = true;
            maxTokensField = "max_tokens";
          };
          api = "openai-completions";
        }
        {
          id = "deepseek-v4-pro";
          name = "DeepSeek V4 Pro";
          reasoning = true;
          input = [ "text" ];
          cost = {
            input = 1.74;
            output = 3.48;
            cacheRead = 0.145;
            cacheWrite = 0;
          };
          contextWindow = 1000000;
          maxTokens = 384000;
          compat = {
            supportsReasoningEffort = true;
            supportsUsageInStreaming = true;
            maxTokensField = "max_tokens";
          };
          api = "openai-completions";
        }
      ];
    };

    # OpenCode Go provider；模型参数与 openclaw 内置 opencode-go 插件
    # (extensions/opencode-go/provider-catalog.ts) 完全对齐。
    opencode-go = {
      baseUrl = "https://opencode.ai/zen/go/v1";
      api = "openai-completions";
      # OpenCode Go API key，从 agenix SecretRef 获取。
      apiKey = {
        source = "file";
        provider = "openclaw";
        id = "/models/opencode-go/apiKey";
      };
      models = [
        {
          id = "deepseek-v4-flash";
          name = "DeepSeek V4 Flash (OpenCode Go)";
          reasoning = true;
          input = [ "text" ];
          cost = {
            input = 0.14;
            output = 0.28;
            cacheRead = 0.028;
            cacheWrite = 0;
          };
          contextWindow = 1000000;
          maxTokens = 384000;
          compat = {
            supportsReasoningEffort = true;
            supportsUsageInStreaming = true;
            maxTokensField = "max_tokens";
          };
          api = "openai-completions";
        }
        {
          id = "deepseek-v4-pro";
          name = "DeepSeek V4 Pro (OpenCode Go)";
          reasoning = true;
          input = [ "text" ];
          cost = {
            input = 1.74;
            output = 3.48;
            cacheRead = 0.145;
            cacheWrite = 0;
          };
          contextWindow = 1000000;
          maxTokens = 384000;
          compat = {
            supportsReasoningEffort = true;
            supportsUsageInStreaming = true;
            maxTokensField = "max_tokens";
          };
          api = "openai-completions";
        }
      ];
    };

    # 阿里云百炼 Token Plan 个人版（华北 2 / 北京）。
    # Provider ID 与新版官方 qwen provider 插件一致；当前 OpenClaw 2026.7.1
    # 仍可通过标准 OpenAI-compatible transport 使用，升级后可直接接管专属兼容逻辑。
    qwen-token-plan = {
      baseUrl = "https://token-plan.cn-beijing.maas.aliyuncs.com/compatible-mode/v1";
      api = "openai-completions";
      apiKey = {
        source = "file";
        provider = "openclaw";
        id = "/models/qwen-token-plan/apiKey";
      };
      timeoutSeconds = 240;
      models = [
        {
          id = "qwen3.8-max-preview";
          name = "Qwen3.8 Max Preview (Token Plan)";
          reasoning = true;
          input = [
            "text"
            "image"
          ];
          cost = {
            input = 0;
            output = 0;
            cacheRead = 0;
            cacheWrite = 0;
          };
          # contextWindow = 983616;
          contextWindow = 524288;
          maxTokens = 131072;
          thinkingLevelMap = {
            minimal = "low";
            low = "low";
            medium = "high";
            high = "xhigh";
            xhigh = "xhigh";
            max = "xhigh";
          };
          compat = {
            # qwen3.8-max-preview 始终思考，并使用 OpenAI 风格 reasoning_effort。
            thinkingFormat = "openai";
            supportsReasoningEffort = true;
            supportedReasoningEfforts = [
              "low"
              "high"
              "xhigh"
            ];
            supportsUsageInStreaming = true;
            maxTokensField = "max_tokens";
          };
        }
        {
          id = "qwen3.7-max";
          name = "Qwen3.7 Max (Token Plan)";
          reasoning = true;
          input = [ "text" ];
          cost = {
            input = 0;
            output = 0;
            cacheRead = 0;
            cacheWrite = 0;
          };
          contextWindow = 1000000;
          maxTokens = 65536;
          compat = {
            thinkingFormat = "qwen";
            supportsUsageInStreaming = true;
            maxTokensField = "max_tokens";
          };
        }
        {
          id = "qwen3.7-plus";
          name = "Qwen3.7 Plus (Token Plan)";
          reasoning = true;
          input = [
            "text"
            "image"
          ];
          cost = {
            input = 0;
            output = 0;
            cacheRead = 0;
            cacheWrite = 0;
          };
          contextWindow = 1000000;
          maxTokens = 65536;
          compat = {
            thinkingFormat = "qwen";
            supportsUsageInStreaming = true;
            maxTokensField = "max_tokens";
          };
        }
        {
          id = "qwen3.6-flash";
          name = "Qwen3.6 Flash (Token Plan)";
          reasoning = true;
          input = [
            "text"
            "image"
          ];
          cost = {
            input = 0;
            output = 0;
            cacheRead = 0;
            cacheWrite = 0;
          };
          contextWindow = 1000000;
          maxTokens = 65536;
          compat = {
            thinkingFormat = "qwen";
            supportsUsageInStreaming = true;
            maxTokensField = "max_tokens";
          };
        }
        {
          id = "deepseek-v4-flash-0731";
          name = "DeepSeek V4 Flash 0731 (Token Plan)";
          reasoning = true;
          input = [ "text" ];
          cost = {
            input = 0;
            output = 0;
            cacheRead = 0;
            cacheWrite = 0;
          };
          contextWindow = 1000000;
          maxTokens = 393216;
          thinkingLevelMap = {
            minimal = "high";
            low = "high";
            medium = "high";
            high = "high";
            xhigh = "max";
            max = "max";
          };
          compat = {
            # 由 2026.7.1 Qwen runtime backport 转成 Token Plan 的 DeepSeek 字段。
            thinkingFormat = "qwen";
            requiresReasoningContentOnAssistantMessages = true;
            supportsUsageInStreaming = true;
            maxTokensField = "max_tokens";
          };
        }
        {
          id = "deepseek-v4-pro";
          name = "DeepSeek V4 Pro (Token Plan)";
          reasoning = true;
          input = [ "text" ];
          cost = {
            input = 0;
            output = 0;
            cacheRead = 0;
            cacheWrite = 0;
          };
          contextWindow = 1000000;
          maxTokens = 393216;
          thinkingLevelMap = {
            minimal = "high";
            low = "high";
            medium = "high";
            high = "high";
            xhigh = "max";
            max = "max";
          };
          compat = {
            # 显式 qwen 格式避免 2026.7.1 核心发送 DeepSeek 原生 thinking 对象。
            thinkingFormat = "qwen";
            requiresReasoningContentOnAssistantMessages = true;
            supportsUsageInStreaming = true;
            maxTokensField = "max_tokens";
          };
        }
        {
          id = "glm-5.2";
          name = "GLM-5.2 (Token Plan)";
          reasoning = true;
          input = [ "text" ];
          cost = {
            input = 0;
            output = 0;
            cacheRead = 0;
            cacheWrite = 0;
          };
          contextWindow = 1000000;
          maxTokens = 131072;
          compat = {
            thinkingFormat = "qwen";
            supportedReasoningEfforts = [
              "minimal"
              "low"
              "medium"
              "high"
              "xhigh"
              "max"
            ];
            supportsUsageInStreaming = true;
            maxTokensField = "max_tokens";
          };
        }
      ];
    };

    # SJTU OpenAI-compatible provider。
    sjtu = {
      baseUrl = "https://llm.mmm.fan/v1";
      api = "openai-completions";
      # SJTU API key，从 agenix SecretRef 获取。
      apiKey = {
        source = "file";
        provider = "openclaw";
        id = "/models/sjtu/apiKey";
      };
      # 长上下文请求耗时较长，沿用同端点 RHCG provider 的超时配置。
      timeoutSeconds = 240;
      models = [
        {
          id = "glm-5.2";
          name = "GLM-5.2 (SJTU)";
          reasoning = true;
          input = [ "text" ];
          # llm.mmm.fan 当前部署实测总上下文上限为 262144 tokens。
          contextWindow = 500000;
          maxTokens = 128000;
          api = "openai-completions";
          # OpenClaw 内部会把 max 规范化为 xhigh；SJTU GLM-5.2 的上游强档值是 max。
          # 两层映射分别覆盖 simple-completion/model clamp 与 agent transport effort 解析。
          thinkingLevelMap = {
            xhigh = "max";
            max = "max";
          };
          compat = {
            # 用 openai 格式走顶层 reasoning_effort 路径（high/max），
            # 避免 qwen-chat-template 路径与 reasoning_effort 互斥导致强度参数不发送。
            thinkingFormat = "openai";
            supportsReasoningEffort = true;
            reasoningEffortMap = {
              xhigh = "max";
              max = "max";
            };
            supportedReasoningEfforts = [
              "high"
              "max"
            ];
            maxTokensField = "max_tokens";
            supportsUsageInStreaming = true;
          };
        }
      ];
    };

    # RHCG provider
    rhcg = {
      # RHCG OpenAI-compatible endpoint。
      baseUrl = myvars.openclaw.models.rhcg.baseUrl;
      api = "openai-completions";
      # RHCG API key，从 agenix SecretRef 获取。
      apiKey = {
        source = "file";
        provider = "openclaw";
        id = "/models/rhcg/apiKey";
      };
      # Provider 请求超时时间。
      timeoutSeconds = 240;
      models = [
        {
          id = "gpt-5.6-luna";
          name = "GPT-5.6 Luna";
          reasoning = true;
          input = [
            "text"
            "image"
          ];
          contextWindow = 372000;
          maxTokens = 128000;
          thinkingLevelMap = {
            xhigh = "xhigh";
            max = "max";
          };
          compat.supportsReasoningEffort = true;
          compat.supportedReasoningEfforts = [
            "low"
            "medium"
            "high"
            "xhigh"
            "max"
          ];
          api = "openai-completions";
        }
        {
          id = "gpt-5.6-sol";
          name = "GPT-5.6 Sol";
          reasoning = true;
          input = [
            "text"
            "image"
          ];
          contextWindow = 372000;
          maxTokens = 128000;
          thinkingLevelMap = {
            xhigh = "xhigh";
            max = "max";
          };
          compat.supportsReasoningEffort = true;
          compat.supportedReasoningEfforts = [
            "low"
            "medium"
            "high"
            "xhigh"
            "max"
          ];
          api = "openai-completions";
        }
        {
          id = "gpt-5.6-terra";
          name = "GPT-5.6 Terra";
          reasoning = true;
          input = [
            "text"
            "image"
          ];
          contextWindow = 372000;
          maxTokens = 128000;
          thinkingLevelMap = {
            xhigh = "xhigh";
            max = "max";
          };
          compat.supportsReasoningEffort = true;
          compat.supportedReasoningEfforts = [
            "low"
            "medium"
            "high"
            "xhigh"
            "max"
          ];
          api = "openai-completions";
        }
        {
          id = "gpt-5.5";
          name = "GPT-5.5";
          reasoning = true;
          input = [
            "text"
            "image"
          ];
          contextWindow = 272000;
          maxTokens = 128000;
          thinkingLevelMap = {
            xhigh = "xhigh";
            max = "xhigh";
          };
          compat.supportsReasoningEffort = true;
          compat.supportedReasoningEfforts = [
            "low"
            "medium"
            "high"
            "xhigh"
          ];
          api = "openai-completions";
        }
        {
          id = "gpt-5.4";
          name = "GPT-5.4";
          reasoning = true;
          input = [
            "text"
            "image"
          ];
          contextWindow = 272000;
          maxTokens = 128000;
          thinkingLevelMap = {
            xhigh = "xhigh";
            max = "xhigh";
          };
          compat.supportsReasoningEffort = true;
          compat.supportedReasoningEfforts = [
            "low"
            "medium"
            "high"
            "xhigh"
          ];
          api = "openai-completions";
        }
        {
          id = "gpt-5.4-mini";
          name = "GPT-5.4 Mini";
          reasoning = true;
          input = [
            "text"
            "image"
          ];
          contextWindow = 272000;
          maxTokens = 128000;
          thinkingLevelMap = {
            xhigh = "xhigh";
            max = "xhigh";
          };
          compat.supportsReasoningEffort = true;
          compat.supportedReasoningEfforts = [
            "low"
            "medium"
            "high"
            "xhigh"
          ];
          api = "openai-completions";
        }
      ];
    };
  };
}
