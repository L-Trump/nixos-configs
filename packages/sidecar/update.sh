#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash coreutils git
# The repo-wide `update-source-version` helper cannot evaluate
# packages/default.nix (it requires the `inputs` argument), so patch the
# version, the source hash and the Go vendor hash directly.
# `nix`, `sed` and `grep` are taken from PATH (they are on every NixOS host);
# the nix-shell only guarantees bash/git/coreutils for the script itself.
set -euo pipefail

nixFile="$(cd "$(dirname "$0")" && pwd)/default.nix"
pkgDir="$(dirname "$nixFile")"
repoRoot="$(cd "$pkgDir/../.." && pwd)"
repoUrl=https://github.com/marcus/sidecar
system="$(nix eval --impure --raw --expr 'builtins.currentSystem')"

# `git ls-remote` instead of the releases API: the API is rate limited on
# unauthenticated machines, and a tag is all this package needs from it.
# awk reads the whole stream on purpose — `head` would SIGPIPE git, which
# `pipefail` turns into a script failure.
tag=$(git ls-remote --tags --refs --sort=-v:refname "$repoUrl" | awk 'NR == 1 { sub(/^refs\/tags\//, "", $2); print $2 }')
if [[ -z "$tag" ]]; then
    echo "error: could not determine the latest release tag" >&2
    exit 1
fi
latestVersion="${tag#v}"
currentVersion=$(grep --only-matching --perl-regexp --max-count=1 '^  version = "\K[^"]+' "$nixFile")
if [[ -z "$currentVersion" ]]; then
    echo "error: could not parse the current version from $nixFile" >&2
    exit 1
fi

echo "latest  version: $latestVersion"
echo "current version: $currentVersion"

if [[ "$latestVersion" == "$currentVersion" ]]; then
    echo "package is up-to-date"
    exit 0
fi

srcHash=$(nix store prefetch-file --json --unpack --hash-type sha256 "$repoUrl/archive/refs/tags/$tag.tar.gz" | grep --only-matching --perl-regexp '"hash":"\K[^"]+')
echo "src        $tag -> $srcHash"

sed -i -E "s/^  version = \"[^\"]+\";/  version = \"$latestVersion\";/" "$nixFile"
sed -i -E "s|(^    hash = )\"sha256-[^\"]+\";|\1\"$srcHash\";|" "$nixFile"

# The vendor hash only depends on go.mod/go.sum, so ask Nix for the one the new
# sources expect: build with a bogus hash and read the real one out of the error.
sed -i -E "s|^  vendorHash = \"[^\"]+\";|  vendorHash = lib.fakeHash;|" "$nixFile"
buildExpr="let p = (builtins.getFlake \"git+file://$repoRoot\").inputs.nixpkgs.legacyPackages.$system; in p.callPackage $pkgDir {}"
if buildLog=$(nix build --impure --no-link --expr "$buildExpr" 2>&1); then
    echo "error: the build unexpectedly succeeded with a fake vendorHash" >&2
    exit 1
fi
vendorHash=$(grep --only-matching --perl-regexp 'got:\s+\Ksha256-[A-Za-z0-9+/=]+' <<<"$buildLog" | tr '\n' ' ' | awk '{print $1}')
if [[ -z "$vendorHash" ]]; then
    echo "error: could not derive the vendor hash from the build output:" >&2
    echo "$buildLog" >&2
    exit 1
fi
sed -i -E "s|^  vendorHash = .*;|  vendorHash = \"$vendorHash\";|" "$nixFile"
echo "vendorHash $tag -> $vendorHash"

echo "updated $(basename "$nixFile") to $latestVersion"
