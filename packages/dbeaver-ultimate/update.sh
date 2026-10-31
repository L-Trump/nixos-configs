#!/usr/bin/env nix-shell
# shellcheck shell=bash
#!nix-shell -i bash -p bash curl coreutils gnused jq

set -euo pipefail

nixFile="$(cd "$(dirname "$0")" && pwd)/default.nix"
baseUrl="https://downloads.dbeaver.net/ultimate"

currentVersion=$(sed --regexp-extended -n 's/^  version = "([^"]+)";/\1/p' "$nixFile" | head -1)
if [ -z "$currentVersion" ]; then
    echo "error: could not parse the current version from $nixFile" >&2
    exit 1
fi

mapfile -t candidates < <(
    curl -fsSL "https://api.github.com/repos/dbeaver/dbeaver/tags?per_page=60" | jq -r '.[].name'
)

latestVersion=""
for version in "${candidates[@]}"; do
    code=$(curl -s -o /dev/null -w '%{http_code}' "$baseUrl/$version/")
    if [ "$code" = "403" ]; then
        latestVersion="$version"
        break
    fi
done
if [ -z "$latestVersion" ]; then
    echo "error: no existing Ultimate release directory found among the CE tags" >&2
    exit 1
fi

echo "latest  version: $latestVersion"
echo "current version: $currentVersion"

if [ "$latestVersion" = "$currentVersion" ]; then
    echo "package is up-to-date"
    exit 0
fi

for arch in x86_64 aarch64; do
    url="$baseUrl/$latestVersion/dbeaver-ue-$latestVersion-linux-$arch.tar.gz"
    hash=$(nix store prefetch-file --json --hash-type sha256 "$url" | jq -r '.hash')
    if [ -z "$hash" ] || [ "$hash" = "null" ]; then
        echo "error: could not prefetch $url" >&2
        exit 1
    fi
    echo "$arch-linux  $hash"
    sed --regexp-extended -i \
        "s|(^        ${arch}-linux = )\"sha256-[^\"]+\";|\1\"$hash\";|" "$nixFile"
done

sed --regexp-extended -i "s/^  version = \"[^\"]+\";/  version = \"$latestVersion\";/" "$nixFile"

echo "updated $(basename "$nixFile") to $latestVersion"
echo "note: dbeaver-agent (gitee ltrump/dbeaver-agent) 是独立版本号，需要手动确认是否有配套 tag"
