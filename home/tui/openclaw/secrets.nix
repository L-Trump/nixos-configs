{ config, ... }:
{
  # OpenClaw SecretRef provider；openclaw.json 中 {source="file", provider="openclaw"} 会从这里取值。
  secrets.providers.openclaw = {
    # 使用文件型 SecretRef provider。
    source = "file";
    # agenix 解密后的 runtime JSON 路径；使用 age.secrets 的真实 runtime path，避免 symlink 问题。
    path = config.age.secrets.openclaw-secrets.path;
    # secret 文件格式为 JSON，id 使用 JSON Pointer 风格路径，如 /models/minimax/apiKey。
    mode = "json";
    # 允许读取 agenix runtime 路径；当前 path 是 regular file，不是自定义 symlink。
    allowInsecurePath = true;
  };
}
