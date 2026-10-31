{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  fetchNpmDeps,
  fetchurl,
  nodejs_22,
}:

# Up to 0.10.0 this needed a `bundledIntegrityPatch` postPatch that injected
# registry integrity hashes for the nested `@earendil-works/{chord,pi-codemode,
# pi-mcp}` entries `package-lock.json` recorded with a `resolved` URL but no
# `integrity` (they ship inside the pi-coding-agent tarball, and nixpkgs'
# `prefetch-npm-deps` panics with "non-git dependencies should have associated
# integrity"). pi-web 0.12.1 removed the problem upstream by pinning every pi
# package in the tree to an exact version as a direct dependency, so the lockfile
# no longer has integrity-less nested entries and no patch (nor `jq`) is needed.
# If a future version reintroduces them, the build fails in `npmDepsHash` with
# that exact message.
buildNpmPackage rec {
  pname = "pi-web";
  version = "0.13.0";

  # Build from the git tag rather than the npm tarball: only the git tree ships
  # `package-lock.json`, which `npmDepsHash` needs to pin the dependency
  # closure reproducibly.
  src = fetchFromGitHub {
    owner = "agegr";
    repo = "pi-web";
    rev = "v${version}";
    hash = "sha256-XJm2SKqG6T6mGmKDw3eKkPP+iywXA8ehBu5Y1W/dFNw=";
  };

  # The published npm release ships a prebuilt Next.js server bundle (735 files,
  # ~35 MB under `.next`). We install that bundle instead of running
  # `next build`, which would have to download the Next.js SWC binaries into
  # the sandbox. `bin/pi-web.js` hard fails at startup when `.next` is missing,
  # so the bundle is mandatory.
  dist = fetchurl {
    url = "registry.npmjs.org/@agegr/pi-web/-/pi-web-${version}.tgz";
    hash = "sha256-3ucPpk7VL7MgUd/EurrCh678ikr1TD0ZAMUeY03t6T0=";
  };

  npmDepsHash = "sha256-C8UW58gchTRoKMn1cEC2w3hLz/iriHzRuPflDNscDZI=";
  npmDepsFetcherVersion = 2;

  npmDeps = fetchNpmDeps {
    inherit src;
    name = "${pname}-${version}-npm-deps";
    hash = npmDepsHash;
    fetcherVersion = npmDepsFetcherVersion;
  };

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
