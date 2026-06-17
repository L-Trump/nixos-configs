{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_22,
}:

buildNpmPackage rec {
  pname = "openclaw-runtime-plugin-lossless-claw";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "Martian-Engineering";
    repo = "lossless-claw";
    rev = "v${version}";
    hash = "sha256-REx3duIZMrmToGq0U/dr0k+frjkfTM3BmrQzmnhaelg=";
  };

  npmDepsHash = "sha256-dPItQm/3wGgih1FCkHn3bh1nIukG4VK4fUvh1AXR3Ng=";
  npmDepsFetcherVersion = 2;

  npmBuildScript = "build";

  nativeBuildInputs = [ nodejs_22 ];

  postPatch = ''
    ${nodejs_22}/bin/node <<'EOF'
    const fs = require('fs');
    const lock = JSON.parse(fs.readFileSync('package-lock.json', 'utf8'));
    const integrityByPath = {
      'node_modules/@earendil-works/pi-coding-agent/node_modules/@earendil-works/pi-agent-core': 'sha512-PBPjBa2YBm9jauiLtHAKaSfVJ4Dvm3/nK/bR/oHebLjwBCS2tGx3aQDX7MSGAOXi6BejlhzbB/z82BkyAyNjjQ==',
      'node_modules/@earendil-works/pi-coding-agent/node_modules/@earendil-works/pi-ai': 'sha512-UnORwrcsTNLm4StEvoM8iEom0u87Te7BXEWxhec3iNXygWD6eEBosUoq9ddcveqtj/QpUZBMPWUu81cCtZxzkQ==',
      'node_modules/@earendil-works/pi-coding-agent/node_modules/@earendil-works/pi-tui': 'sha512-YvZCMfSE0YDSLNklAwMY6LC6SyEgnP0zMOoioTLNnXFNdexrCexMJdee7iDJsNcFlKt7+DVLccomuURtZS1C6g==',
    };
    for (const [path, integrity] of Object.entries(integrityByPath)) {
      if (lock.packages?.[path]) lock.packages[path].integrity = integrity;
    }
    fs.writeFileSync('package-lock.json', JSON.stringify(lock, null, 2) + '\n');

    const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));
    pkg.openclaw = pkg.openclaw || {};
    pkg.openclaw.runtimeExtensions = pkg.openclaw.runtimeExtensions || pkg.openclaw.extensions || ['./dist/index.js'];
    fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2) + '\n');
    EOF
  '';

  postInstall = ''
    packageRoot="$out/lib/node_modules/@martian-engineering/lossless-claw"
    if [ -d "$packageRoot" ]; then
      tmpRoot="$out/.package-root"
      mv "$packageRoot" "$tmpRoot"
      rm -rf "$out/lib"
      cp -R "$tmpRoot"/. "$out"/
      rm -rf "$tmpRoot"
    fi
  '';

  passthru.openclawRuntimePlugin = {
    id = "lossless-claw";
    source = "github";
    loadPath = placeholder "out";
  };

  meta = {
    description = "Lossless Context Management plugin for OpenClaw";
    homepage = "https://github.com/Martian-Engineering/lossless-claw";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
