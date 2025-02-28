#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash curl coreutils jq common-updater-scripts
# 切换到脚本所在目录
cd "${0%/*}" || exit
# 固定的 PR URL
PR_URL="https://github.com/hyprwm/Hyprland/pull/6446"
# 从 PR URL 中提取 owner, repo 和 pr_number
OWNER=$(echo $PR_URL | cut -d'/' -f4)
REPO=$(echo $PR_URL | cut -d'/' -f5)
PR_NUMBER=$(echo $PR_URL | cut -d'/' -f7)
# GitHub API URL 获取 PR 的 commits
API_URL="https://api.github.com/repos/$OWNER/$REPO/pulls/$PR_NUMBER/commits"
# 获取 commits 并提取第一个 commit 的 SHA
FIRST_COMMIT=$(curl -s $API_URL | jq -r '.[0].sha')
# 检查是否成功获取到 commit SHA
if [ -z "$FIRST_COMMIT" ]; then
  echo "Failed to retrieve the first commit for PR #$PR_NUMBER."
  exit 1
fi
# 生成 commit 对应的 patch GitHub URL
PATCH_URL="https://github.com/$OWNER/$REPO/commit/$FIRST_COMMIT.patch"
# 使用 nix-prefetch-url 获取 patch 的 hash
patch_prefetch=$(nix-prefetch-url "$PATCH_URL")
patch_hash=$(nix-hash --type sha256 --to-sri "$patch_prefetch")
# 检查是否成功获取到 hash
if [ -z "$patch_hash" ]; then
  echo "Failed to calculate the hash for the patch."
  exit 1
fi
# 替换 ../package/default.nix 文件中的 url 和 hash 字段
sed -i -E "/xwayland-xprop-hidpi/,/}/ {
  s|(url = \")[^\"]+|\1$PATCH_URL|
  s|(hash = \")[^\"]+|\1$patch_hash|
}" ../packages/default.nix
# 输出结果
echo "Patch URL updated to: $PATCH_URL"
echo "Patch hash updated to: $patch_hash"
