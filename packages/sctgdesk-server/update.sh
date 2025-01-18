#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash curl coreutils jq common-updater-scripts

latestTag=$(curl -sSfL ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} https://api.github.com/repos/sctg-development/sctgdesk-server/releases/latest | jq -r ".tag_name")
latestVersion="$(expr "$latestTag" : '\(.*\)')"
currentVersion=$(nix-instantiate --eval -E "with import ./. {}; sctgdesk-server.version" | tr -d '"')

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
    prefetch=$(nix-prefetch-url "https://github.com/sctg-development/sctgdesk-server/releases/download/$latestVersion/linux_static_${latestVersion}_$2.zip")
    hash=$(nix-hash --type sha256 --to-sri "$prefetch")

    update-source-version sctgdesk-server "$latestVersion" "$hash" --system="$1" --ignore-same-version
done
