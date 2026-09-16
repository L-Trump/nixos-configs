#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash curl coreutils jq
# The repo-wide `update-source-version` helper cannot evaluate
# packages/default.nix (it requires the `inputs` argument), so patch the
# version and the source hash directly. The download URL interpolates
# ${version}, so it follows the version bump automatically.
set -euo pipefail

nixFile="$(cd "$(dirname "$0")" && pwd)/default.nix"
repoUrl=https://github.com/yabi-zzh/HoKit

authArgs=()
if [[ -n "${GITHUB_TOKEN:-}" ]]; then
    authArgs=(-u ":$GITHUB_TOKEN")
fi

if ! release=$(curl -sSfL "${authArgs[@]}" https://api.github.com/repos/yabi-zzh/HoKit/releases/latest); then
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

asset="HoKit-linux-x86_64-$latestVersion.AppImage"
if ! jq -e --arg name "$asset" 'any(.assets[]; .name == $name)' <<<"$release" >/dev/null; then
    echo "error: $tag has no asset named $asset" >&2
    echo "assets: $(jq -r '[.assets[].name] | join(", ")' <<<"$release")" >&2
    exit 1
fi

hash=$(nix-hash --type sha256 --to-sri "$(nix-prefetch-url "$repoUrl/releases/download/$tag/$asset")")
echo "$asset -> $hash"

sed -i -E "s/^  version = \"[^\"]+\";/  version = \"$latestVersion\";/" "$nixFile"
sed -i -E "s|(hash = )\"sha256-[^\"]+\";|\1\"$hash\";|" "$nixFile"

echo "updated $(basename "$nixFile") to $latestVersion"
