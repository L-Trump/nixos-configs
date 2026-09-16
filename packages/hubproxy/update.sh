#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash curl coreutils jq
# The repo-wide `update-source-version` helper cannot evaluate
# packages/default.nix (it requires the `inputs` argument), so patch the
# version, the asset name and the per-system hashes directly.
set -euo pipefail

nixFile="$(cd "$(dirname "$0")" && pwd)/default.nix"
repoUrl=https://github.com/sky22333/hubproxy
releaseUrl=$repoUrl/releases/download

authArgs=()
if [[ -n "${GITHUB_TOKEN:-}" ]]; then
    authArgs=(-u ":$GITHUB_TOKEN")
fi

if ! release=$(curl -sSfL "${authArgs[@]}" https://api.github.com/repos/sky22333/hubproxy/releases/latest); then
    echo "error: failed to query the GitHub API (rate limited? export GITHUB_TOKEN=...)" >&2
    exit 1
fi

tag=$(jq -r ".tag_name" <<<"$release")
if [[ -z "$tag" || "$tag" == "null" ]]; then
    echo "error: could not determine the latest release tag" >&2
    exit 1
fi
latestVersion="${tag#v}"
currentVersion=$(grep --only-matching --perl-regexp '^  version = "\K[^"]+' "$nixFile" | head -n 1)
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

# v1.2.5 dropped the version from the asset names: hubproxy-linux-<arch>.tar.gz
if jq -e 'any(.assets[]; .name == "hubproxy-linux-amd64.tar.gz")' <<<"$release" >/dev/null; then
    versionedAssets=false
else
    versionedAssets=true
fi

for i in \
    "x86_64-linux amd64" \
    "aarch64-linux arm64"; do
    set -- $i
    system="$1"
    asset="hubproxy-linux-$2.tar.gz"
    if [[ "$versionedAssets" == true ]]; then
        asset="hubproxy-v$latestVersion-linux-$2.tar.gz"
    fi

    url="$releaseUrl/$tag/$asset"
    hash=$(nix-hash --type sha256 --to-sri "$(nix-prefetch-url "$url")")
    echo "$system: $asset -> $hash"

    sed -i -E "/^ +$system = /s|= \".*\";|= \"$hash\";|" "$nixFile"
done

sed -i -E "s/^  version = \"[^\"]+\";/  version = \"$latestVersion\";/" "$nixFile"
if [[ "$versionedAssets" == false ]]; then
    sed -i "s|hubproxy-v\${version}-linux-|hubproxy-linux-|" "$nixFile"
fi

echo "updated $(basename "$nixFile") to $latestVersion"
