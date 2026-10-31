{ lib }:
{
  allowUnfree = true;
  permittedInsecurePackages = [
    "openclaw-2026.4.22"
    "electron-39.8.10"
  ];
  # TODO delete after zotero 11 依赖 nixpkgs 里那份 EOL 的 Firefox 140 ESR 预构建包
  # （上游 PR #572466 的修法：zotero 只支持 GECKO 140.15esr，而当前 ESR 已到 153）。
  # 用 predicate 而不是往 permittedInsecurePackages 里加精确名字，否则 ESR
  # 每次小版本升级（firefox-esr-140-bin-unwrapped-140.17.0esr → …）都要改这里。
  #
  # 坑：check-meta 传给 predicate 的是 derivation 的 attrs，其中还没有 `name`
  # （只有 `pname` / `version`）——匹配 `pkg.name` 会恒为 false，表现为“明明配了
  # predicate 却仍然 Refusing to evaluate package”。必须匹配 `pname`。
  allowInsecurePredicate =
    pkg: (pkg ? pname) && builtins.match "firefox-esr-140-bin.*" pkg.pname != null;
}
