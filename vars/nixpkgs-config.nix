{ lib }:
{
  allowUnfree = true;
  permittedInsecurePackages = [
    "openclaw-2026.4.22"
    "electron-39.8.10"
  ];
  # TODO delete after zotero 自己换 Gecko。
  # 2026-11-20 核对：zotero 10.0.9（上游最新 tag）的 app/config.sh 仍钉
  # GECKO_VERSION_LINUX="140.17.0esr"，nixpkgs 因此继续用 PR #572466 复活的
  # firefox-esr-140-bin 预构建包（这个包已 EOL 2026-10-13 → 带 knownVulnerabilities，
  # 所以需要下面的 predicate）。上游没有别的修法，只能等 Zotero 换 Gecko。
  # 用 predicate 而不是往 permittedInsecurePackages 里加精确名字，否则 ESR
  # 每次小版本升级（firefox-esr-140-bin-unwrapped-140.17.0esr → …）都要改这里。
  #
  # 坑：check-meta 传给 predicate 的是 derivation 的 attrs，其中还没有 `name`
  # （只有 `pname` / `version`）——匹配 `pkg.name` 会恒为 false，表现为“明明配了
  # predicate 却仍然 Refusing to evaluate package”。必须匹配 `pname`。
  allowInsecurePredicate =
    pkg: (pkg ? pname) && builtins.match "firefox-esr-140-bin.*" pkg.pname != null;
}
