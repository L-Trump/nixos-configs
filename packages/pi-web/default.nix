{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  fetchNpmDeps,
  fetchurl,
  jq,
  nodejs_22,
}:

let
  # pi 1.0 ships new nested workspace packages that pi-web's `package-lock.json`
  # records with a `resolved` URL but **no** `integrity`, because they are
  # bundled inside the `@earendil-works/pi-coding-agent` tarball.
  # nixpkgs' `prefetch-npm-deps` (fetcher version 2) dedups lockfile entries by
  # `resolved` and then `expect()`s an integrity on every survivor, so a bundled
  # entry whose URL is unique panics the whole build with
  # "non-git dependencies should have associated integrity".
  #
  # 0.9.3 only escaped this because each of its five bundled entries (`chord`,
  # `pi-agent-core`, `pi-ai`, `pi-telemetry`, `pi-tui`) also existed hoisted at
  # the lockfile top level, so the URL match deduped the integrity-less copy
  # away. pi 1.0 adds `chord`, `pi-codemode` and `pi-mcp` with no hoisted twin,
  # which is exactly what makes 0.10.0 fail to prefetch.
  #
  # Fix: inject the integrity hashes that the registry publishes for those three
  # tarballs, so the fetcher caches them like any other registry dependency.
  # These are upstream SRI hashes, not locally invented ones.
  #
  # No `runHook prePatch` / `runHook postPatch` here on purpose: stdenv's
  # `patchPhase` already runs both, and `_callImplicitHook` implements a string
  # hook as `eval "${!hookName}"`. A `runHook postPatch` *inside* the postPatch
  # string therefore re-enters itself forever and the build dies with a bare
  # "builder failed due to signal 11" after printing nothing but
  # "Running phase: patchPhase".
  bundledIntegrityPatch = ''
    declare -A bundled_integrities=(
      ["node_modules/@earendil-works/pi-coding-agent/node_modules/@earendil-works/chord"]="sha512-BIfWfrByM0pKq6tfKYXuwx0ed2CvaqIM3EDA7Dps+fP+d3CiPWdlHi1cDsJC05llqKJoRz5//G0hz0yQwwjISQ=="
      ["node_modules/@earendil-works/pi-coding-agent/node_modules/@earendil-works/pi-codemode"]="sha512-LPpFI4+T9NzDnhBDs15izWAolaoM8xnwqdziRd6Zx8BQeoEPvzefD2vMMzSyF0rOtq34TfQqkZ0ki16f6cGdMg=="
      ["node_modules/@earendil-works/pi-coding-agent/node_modules/@earendil-works/pi-mcp"]="sha512-rYra0aF5iPmJd+fsB+VBuqxWNABGJ3Iiyhg0CqIc/91ta2n7IvQmCp0Cac/YkUTNnvRsVZnjgAiBkRi6+ouWuw=="
    )

    for key in "''${!bundled_integrities[@]}"; do
      jq \
        --arg key "$key" \
        --arg integrity "''${bundled_integrities[$key]}" \
        'if (.packages[$key].resolved != null and .packages[$key].integrity == null)
         then .packages[$key].integrity = $integrity
         else . end' \
        package-lock.json > package-lock.json.tmp
      mv package-lock.json.tmp package-lock.json
    done
  '';
in
buildNpmPackage rec {
  pname = "pi-web";
  version = "0.10.0";

  # Build from the git tag rather than the npm tarball: only the git tree ships
  # `package-lock.json`, which `npmDepsHash` needs to pin the dependency
  # closure reproducibly.
  src = fetchFromGitHub {
    owner = "agegr";
    repo = "pi-web";
    rev = "v${version}";
    hash = "sha256-dDE+m6ZpiC4N2xWNMvhRshCjqFU5gr2+t7RpvC9dNUk=";
  };

  # The published npm release ships a prebuilt Next.js server bundle (735 files,
  # ~35 MB under `.next`). We install that bundle instead of running
  # `next build`, which would have to download the Next.js SWC binaries into
  # the sandbox. `bin/pi-web.js` hard fails at startup when `.next` is missing,
  # so the bundle is mandatory.
  dist = fetchurl {
    url = "registry.npmjs.org/@agegr/pi-web/-/pi-web-${version}.tgz";
    hash = "sha256-ywu7u2XVgrN4gWWgFR8RQ2eU/44ijictHkS8J+rbs/g=";
  };

  npmDepsHash = "sha256-ClAT7l0nre1bfmD1uKSH+XvKZPVr1K94+M5+FVqZ7TE=";
  npmDepsFetcherVersion = 2;

  # `buildNpmPackage` does not forward its own `nativeBuildInputs` to the
  # separate fixed-output derivation that prefetches the dependencies, and that
  # derivation is a bare `stdenvNoCC` one. Override `npmDeps` so that the
  # `postPatch` above also finds `jq` while the lockfile is being prefetched —
  # without this the build dies with "jq: command not found" in patchPhase.
  #
  # `lib.getBin jq` is not redundant: `mkDerivation` runs every
  # `nativeBuildInputs` entry through `getDev`, and jq is a multi-output package,
  # so a bare `jq` silently contributes `jq-1.8.2-dev` (headers only, no `bin/`)
  # and the build then dies with a bare segfault in patchPhase.
  nativeBuildInputs = [ (lib.getBin jq) ];

  npmDeps = fetchNpmDeps {
    inherit src;
    name = "${pname}-${version}-npm-deps";
    hash = npmDepsHash;
    fetcherVersion = npmDepsFetcherVersion;
    nativeBuildInputs = [ (lib.getBin jq) ];
    postPatch = bundledIntegrityPatch;
  };

  postPatch = bundledIntegrityPatch;

  # `next build` is intentionally skipped, see `dist` above.
  dontNpmBuild = true;

  # bin/node-version.js refuses to start on anything older than 22.19.0.
  nodejs = nodejs_22;

  # The prebuilt bundle is dropped straight into $out rather than into the
  # source tree, because the npm hooks pick the files to install from
  # `npm pack --dry-run` (the upstream `files` allowlist). Dropping it in
  # postUnpack does not survive: the working directory only becomes the source
  # root after unpackPhase returns, so a hook there writes outside the source.
  postInstall = ''
    packageRoot="$out/lib/node_modules/@agegr/pi-web"
    mkdir -p .dist "$packageRoot/.next"
    tar -xzf "$dist" -C .dist
    cp -a .dist/package/.next/. "$packageRoot/.next/"
    chmod -R u+w "$packageRoot/.next"
    rm -rf .dist
  '';

  # `node_modules/.bin/next` is not needed: bin/pi-web.js resolves
  # `next/dist/bin/next` through require.resolve, which finds the copy in the
  # standard `$out/lib/node_modules/<pkg>/node_modules` layout.
  # `node-pty` (the terminal backend) ships prebuilt binaries in `prebuilds/`
  # and resolves them through node-gyp-build, so the `npm ci --ignore-scripts`
  # used by the npm hooks is enough and nothing needs to be compiled.

  meta = {
    description = "Web UI for the pi coding agent";
    homepage = "https://github.com/agegr/pi-web";
    license = lib.licenses.mit;
    mainProgram = "pi-web";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
