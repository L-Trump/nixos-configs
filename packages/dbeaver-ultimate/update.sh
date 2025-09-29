#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash curl coreutils jq common-updater-scripts
BASEDIR="$(dirname "$0")/.."

echo "$BASEDIR"

latestVersion=$(curl "https://api.github.com/repos/dbeaver/dbeaver/tags" | jq -r '.[0].name')
currentVersion=$(nix-instantiate --eval -E "with import ${BASEDIR} {}; dbeaver-ultimate.version" | tr -d '"')

echo "latest  version: $latestVersion"
echo "current version: $currentVersion"

if [[ "$latestVersion" == "$currentVersion" ]]; then
    echo "package is up-to-date"
    exit 0
fi

for i in \
    "x86_64-linux linux.gtk.x86_64-nojdk.tar.gz" \
    "aarch64-linux linux.gtk.aarch64-nojdk.tar.gz"
do
    set -- $i
    prefetch=$(nix-prefetch-url "https://dbeaver.com/downloads-ultimate/$latestVersion/dbeaver-ue-$latestVersion-$2")
    hash=$(nix-hash --type sha256 --to-sri $prefetch)

    (cd "${BASEDIR}" && update-source-version dbeaver-ultimate $latestVersion $hash --system=$1 --ignore-same-version)
done
