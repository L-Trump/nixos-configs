{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_22,
}:

buildNpmPackage rec {
  pname = "openclaw-runtime-plugin-lossless-claw";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "Martian-Engineering";
    repo = "lossless-claw";
    rev = "v${version}";
    hash = "sha256-jnLUtka8r9uYaOMPzr8IxMYCY/hulhO9BjYV5GWel3I=";
  };

  npmDepsHash = "sha256-/6bO6p+0jZCDs6ICqSfzaKjBaySbTwvdefvtXxN9PCM=";

  npmBuildScript = "build";

  nativeBuildInputs = [ nodejs_22 ];

  postPatch = ''
    ${nodejs_22}/bin/node <<'EOF'
    const fs = require('fs');
    const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));
    pkg.openclaw = pkg.openclaw || {};
    pkg.openclaw.runtimeExtensions = pkg.openclaw.runtimeExtensions || pkg.openclaw.extensions || ['./dist/index.js'];
    fs.writeFileSync('package.json', `''${JSON.stringify(pkg, null, 2)}\n`);
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
