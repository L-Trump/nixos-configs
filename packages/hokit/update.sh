#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash curl coreutils jq common-updater-scripts

latestTag=$(curl -sSfL https://api.github.com/repos/yabi-zzh/HoKit/releases/latest | jq -r ".tag_name")
latestVersion="$(expr "$latestTag" : 'v\(.*\)')"
currentVersion=$(nix-instantiate --eval -E "with import ./. {}; hokit.version" | tr -d '"')

echo "latest  version: $latestVersion"
echo "current version: $currentVersion"

if [[ "$latestVersion" == "$currentVersion" ]]; then
    echo "package is up-to-date"
    exit 0
fi

prefetch=$(nix-prefetch-url "https://github.com/yabi-zzh/HoKit/releases/download/v${latestVersion}/HoKit-linux-x86_64-${latestVersion}.AppImage")
hash=$(nix-hash --type sha256 --to-sri $prefetch)
update-source-version hokit $latestVersion $hash --ignore-same-version
