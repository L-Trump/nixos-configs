#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash curl coreutils jq common-updater-scripts
BASEDIR="$(dirname "$0")/.."

latestTag=$(curl -sSfL ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} https://api.github.com/repos/lejianwen/rustdesk-server/releases/latest | jq -r ".tag_name")
latestVersion="$(expr "$latestTag" : 'v\(.*\)')"
currentVersion=$(nix-instantiate --eval -E "with import ${BASEDIR} {}; rustdesk-server-pro.version" | tr -d '"')

echo "latest  version: $latestVersion"
echo "current version: $currentVersion"

if [[ "$latestVersion" == "$currentVersion" ]]; then
    echo "package is up-to-date"
    exit 0
fi
for i in \
    "x86_64-linux amd64" \
    "aarch64-linux arm64v8" ; do
    set -- $i
    prefetch=$(nix-prefetch-url "https://github.com/lejianwen/rustdesk-server/releases/download/v$latestVersion/rustdesk-server-linux-$2.zip")
    hash=$(nix-hash --type sha256 --to-sri "$prefetch")

    (cd "${BASEDIR}" && update-source-version rustdesk-server-pro "$latestVersion" "$hash" --system="$1" --ignore-same-version)
done
