{ myvars }:
{
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

    # Volcano Engine Ark Coding Plan provider.
    # 文档要求 Coding Plan 使用 /api/coding/v3；不要改成普通 /api/v3，否则会按量额外计费。
    "volcengine-plan" = {
      baseUrl = "https://ark.cn-beijing.volces.com/api/coding/v3";
      api = "openai-completions";
      # Ark Coding Plan API key，从 agenix SecretRef 获取。
      apiKey = {
        source = "file";
        provider = "openclaw";
        id = "/models/volcengine-plan/apiKey";
      };
      # Provider 请求超时时间。
      timeoutSeconds = 120;
      # 模型列表按火山方舟 OpenClaw 文档 JSON 示例填写；api/compat 为本机 OpenClaw 适配字段。
      models = [
        {
          id = "ark-code-latest";
          name = "ark-code-latest";
          reasoning = true;
          contextWindow = 256000;
          maxTokens = 32000;
          input = [
            "text"
            "image"
          ];
          api = "openai-completions";
        }
        {
          id = "doubao-seed-code";
          name = "doubao-seed-code";
          reasoning = true;
          contextWindow = 256000;
          maxTokens = 32000;
          input = [
            "text"
            "image"
          ];
          api = "openai-completions";
        }
        {
          id = "glm-5.1";
          name = "glm-5.1";
          reasoning = true;
          contextWindow = 200000;
          maxTokens = 65536;
          input = [ "text" ];
          api = "openai-completions";
        }
        {
          id = "deepseek-v4-flash";
          name = "deepseek-v4-flash";
          reasoning = true;
          contextWindow = 1024000;
          maxTokens = 65536;
          input = [ "text" ];
          api = "openai-completions";
        }
        {
          id = "deepseek-v4-pro";
          name = "deepseek-v4-pro";
          reasoning = true;
          contextWindow = 1024000;
          maxTokens = 65536;
          input = [ "text" ];
          api = "openai-completions";
        }
        {
          id = "doubao-seed-2.0-code";
          name = "doubao-seed-2.0-code";
          reasoning = true;
          contextWindow = 256000;
          maxTokens = 65536;
          input = [
            "text"
            "image"
          ];
          api = "openai-completions";
        }
        {
          id = "doubao-seed-2.0-pro";
          name = "doubao-seed-2.0-pro";
          reasoning = true;
          contextWindow = 256000;
          maxTokens = 65536;
          input = [
            "text"
            "image"
          ];
          api = "openai-completions";
        }
        {
          id = "doubao-seed-2.0-lite";
          name = "doubao-seed-2.0-lite";
          reasoning = true;
          contextWindow = 256000;
          maxTokens = 65536;
          input = [
            "text"
            "image"
          ];
          api = "openai-completions";
        }
        {
          id = "minimax-m2.7";
          name = "minimax-m2.7";
          reasoning = true;
          contextWindow = 200000;
          maxTokens = 65536;
          input = [ "text" ];
          api = "openai-completions";
        }
        {
          id = "minimax-m3";
          name = "minimax-m3";
          reasoning = true;
          contextWindow = 512000;
          maxTokens = 65536;
          input = [
            "text"
            "image"
          ];
          api = "openai-completions";
        }
        {
          id = "kimi-k2.6";
          name = "kimi-k2.6";
          reasoning = true;
          contextWindow = 256000;
          maxTokens = 32000;
          input = [
            "text"
            "image"
          ];
          api = "openai-completions";
        }
      ];
    };

    # RHCG provider
    rhcg = {
      # RHCG OpenAI-compatible endpoint。
      baseUrl = myvars.openclaw.models.rhcg.baseUrl;
      api = "openai-responses";
      # RHCG API key，从 agenix SecretRef 获取。
      apiKey = {
        source = "file";
        provider = "openclaw";
        id = "/models/rhcg/apiKey";
      };
      # Provider 请求超时时间。
      timeoutSeconds = 60;
      models = [
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
          api = "openai-responses";
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
          api = "openai-responses";
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
          api = "openai-responses";
        }
      ];
    };
  };
}
