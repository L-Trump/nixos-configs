{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_22,
}:

buildNpmPackage rec {
  pname = "openclaw-runtime-plugin-lossless-claw";
  version = "0.13.2";

  src = fetchFromGitHub {
    owner = "Martian-Engineering";
    repo = "lossless-claw";
    rev = "v${version}";
    hash = "sha256-icpWV9upvivvdX9JMgkMx4RFdQRk/2eNNH5sbrPX2V0=";
  };

  npmDepsHash = "sha256-aS26/oTzAoncYANck1MbPbBCL/UQowiU02/Wn3L+5So=";
  npmDepsFetcherVersion = 2;

  npmBuildScript = "build";

  nativeBuildInputs = [ nodejs_22 ];

  postPatch = ''
    ${nodejs_22}/bin/node <<'EOF'
    const fs = require('fs');
    const lock = JSON.parse(fs.readFileSync('package-lock.json', 'utf8'));
    const integrityByPath = {
      'node_modules/@earendil-works/pi-coding-agent/node_modules/@earendil-works/pi-agent-core': 'sha512-8m5fcqRpoGpq3QY0I/tFXROSTmPwBb1dAuzYZO3XYgjsdCokkRMAGRjA9P8s/UD6Jy9yy69lyE4H6sz/5A1TmQ==',
      'node_modules/@earendil-works/pi-coding-agent/node_modules/@earendil-works/pi-ai': 'sha512-ZpSwaD7oNpsjn9vtEatZQNT9PSdDJXi6rFeY5Qv+OHQGFDKlmcrfJE4ypm4SAc/fBECPs4Rdi3l+YjVtXYrkKw==',
      'node_modules/@earendil-works/pi-coding-agent/node_modules/@earendil-works/pi-tui': 'sha512-QerB+0wUc6eEO8MwvzOQGtzcsbwo6y8VvdxYU6vGcakz6ofJZWhrmwrknp1dCGx3bEtCf+siUIxEzkqvFCzIsg==',
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
