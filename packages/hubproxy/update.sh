#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash curl coreutils jq common-updater-scripts
BASEDIR="$(dirname "$0")/.."

latestTag=$(curl -sSfL ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} https://api.github.com/repos/sky22333/hubproxy/releases/latest | jq -r ".tag_name")
latestVersion="$(expr "$latestTag" : 'v\(.*\)')"
currentVersion=$(nix-instantiate --eval -E "with import ${BASEDIR} {}; hubproxy.version" | tr -d '"')

echo "latest  version: $latestVersion"
echo "current version: $currentVersion"

if [[ "$latestVersion" == "$currentVersion" ]]; then
    echo "package is up-to-date"
    exit 0
fi
for i in \
    "x86_64-linux amd64" \
    "aarch64-linux arm64" ; do
    set -- $i
    prefetch=$(nix-prefetch-url "https://github.com/sky22333/hubproxy/releases/download/v$latestVersion/hubproxy-v${latestVersion}-linux-$2.tar.gz")
    hash=$(nix-hash --type sha256 --to-sri "$prefetch")

    (cd "${BASEDIR}" && update-source-version hubproxy "$latestVersion" "$hash" --system="$1" --ignore-same-version)
done
