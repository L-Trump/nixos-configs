{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeWrapper,
  libsecret,
  nodejs_22,
}:

buildNpmPackage rec {
  pname = "grok-bot-cli";
  version = "0.12.4";

  # Build from the git tag: only the git tree ships `package-lock.json`.
  src = fetchFromGitHub {
    owner = "ScriptedAlchemy";
    repo = "grok-bot-cli";
    rev = "v${version}";
    hash = "sha256-gdG3oEVI1v6MKHRZsV4ZmXnbfGYeYKOTWmjs7st38sE=";
  };

  npmDepsHash = "sha256-0cKl12Aj+ar/YXBTESMsB88XLc/zr4attAzIRHygAhI=";
  npmDepsFetcherVersion = 2;

  patches = [
    # TODO wait upstream merge https://github.com/ScriptedAlchemy/grok-bot-cli/pull/145
    # (supersedes #143). Accepts the desktop app's v3 gateway-descriptor.json and,
    # when the descriptor/route is missing, reconnects via the active account in
    # sand-secrets.json (Safe Storage decrypt + EnsureSandBox). Vendored src/ +
    # README part only (artifact/, .changeset/, test/ dropped: `agent-bundle
    # build` regenerates dist/ from src here). Applies cleanly on v0.12.4.
    ./gateway-route-fallback-pr145.patch
    # Local: the PR only auto-detects the app version (x-cursor-client-version
    # for EnsureSandBox) on macOS; Linux would send 0.20.0, which the backend
    # rejects. Read appVersion from <XDG_CONFIG_HOME>/Grok Bot/desktop-status.json
    # instead. SAND_CLIENT_VERSION still overrides.
    ./linux-app-version.patch
    # Local: preserve optional live runtime state in JSON agent summaries.
    ./runtime-state.patch
  ];

  # `npm run build` (agent-bundle build) compiles TS into dist/.
  npmBuildScript = "build";

  # engines.node >= 22.19.0
  nodejs = nodejs_22;

  nativeBuildInputs = [ makeWrapper ];

  # gbot decrypts the desktop app's keyring-backed gateway descriptor on Linux
  # by exec'ing `secret-tool` from PATH at runtime. buildInputs /
  # nativeBuildInputs only affect the build environment, so the installed bins
  # are wrapped to put libsecret's bin dir on PATH instead.
  postInstall = ''
    root="$out/lib/node_modules/grok-bot-cli/dist"
    for bin in gbot grok-bot gbot-install; do
      wrapProgram "$out/bin/$bin" --prefix PATH : ${lib.makeBinPath [ libsecret ]}
    done

    # Expose the bundled `grok-bot` stdio MCP server (dist/mcp.json) as a bin.
    # Its filename carries a content hash, so resolve it from mcp.json.
    mcpEntry=$(${lib.getExe' nodejs_22 "node"} -e \
      'const m=require(process.argv[1]);const a=m.mcpServers["grok-bot"].args;if(a.length!==1)process.exit(1);console.log(a[0])' \
      "$root/mcp.json")
    test -f "$root/$mcpEntry"
    makeWrapper ${lib.getExe' nodejs_22 "node"} "$out/bin/gbot-mcp" \
      --add-flags "$root/$mcpEntry" \
      --set AGENT_BUNDLE_PLUGIN_ROOT "$root" \
      --chdir "$root" \
      --prefix PATH : ${lib.makeBinPath [ libsecret ]}
  '';

  meta = {
    description = "CLI for Grok Bot agents and groups";
    homepage = "https://github.com/ScriptedAlchemy/grok-bot-cli";
    license = lib.licenses.mit;
    mainProgram = "gbot";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
