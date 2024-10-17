#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts nix-prefetch jq

set -euo pipefail

ROOT="$(dirname "$(readlink -f "$0")")"
NIX_DRV="$ROOT/default.nix"
if [ ! -f "$NIX_DRV" ]; then
  echo "ERROR: cannot find urbit in $ROOT"
  exit 1
fi

fetch_arch() {
  VER="$1"; ARCH="$2"
  URL="https://github.com/cloud-fs/cloud-fs.github.io/releases/download/v${VER}/clouddrive-2-${ARCH}-${VER}.tgz";
  nix-prefetch "{ stdenv, fetchzip }:
stdenv.mkDerivation rec {
  pname = \"clouddrive2\"; version = \"${VER}\";
  src = fetchzip { url = \"$URL\"; };
}
"
}

replace_sha() {
  sed -i "s#$1 = \"sha256-.\{44\}\"#$1 = \"$2\"#" "$NIX_DRV"
}

LAT_RELEASE=$(curl -sSfL \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/repos/cloud-fs/cloud-fs.github.io/releases/latest")
LAT_VER=$(jq .tag_name -r <<< "$LAT_RELEASE" | cut -c2-)

LAT_LINUX_AARCH64_SHA256=$(fetch_arch "$LAT_VER" "linux-aarch64")
LAT_LINUX_X64_SHA256=$(fetch_arch "$LAT_VER" "linux-x86_64")
LAT_DARWIN_AARCH64_SHA256=$(fetch_arch "$LAT_VER" "macos-aarch64")
LAT_DARWIN_X64_SHA256=$(fetch_arch "$LAT_VER" "macos-x86_64")

sed -i "s/version = \".*\"/version = \"$LAT_VER\"/" "$NIX_DRV"

replace_sha "aarch64-linux" "$LAT_LINUX_AARCH64_SHA256"
replace_sha "x86_64-linux" "$LAT_LINUX_X64_SHA256"
replace_sha "aarch64-darwin" "$LAT_DARWIN_AARCH64_SHA256"
replace_sha "x86_64-darwin" "$LAT_DARWIN_X64_SHA256"
