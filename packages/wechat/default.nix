# 入口适配层：上游 nixpkgs PR #560225 用的是 by-name 布局，入口文件叫 package.nix，
# 而本仓库的 `pkgs.callPackage ./wechat` 约定目录里有 default.nix。
# 直接 `import ./package.nix`（不包装成新 lambda），这样 callPackage 仍能读到
# package.nix 的完整形参列表并自动注入依赖。
# 其余文件（package.nix / linux.nix / darwin.nix / sources.json / update.py）
# 均从 PR head 原样 vendor，未作改动，方便日后与上游 diff。
import ./package.nix
