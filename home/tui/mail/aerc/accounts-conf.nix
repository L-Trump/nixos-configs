# Local override: fix Home Manager's aerc account generation for aerc 0.22.
#
# Background:
#   aerc 0.22 deprecated notmuch's `maildir-store` option (the mail root is
#   discovered automatically through enable-maildir) and explicit database
#   paths in the source URL.
#   However, the upstream Home Manager module
#   (modules/programs/aerc/accounts.nix, mkConfig.notmuch) still generates:
#       source        = notmuch://<maildirBasePath>   # explicit path deprecated
#       maildir-store = <maildirBasePath>             # deprecated; warns at startup
#   Upstream issues:
#     https://github.com/nix-community/home-manager/issues/9751
#     https://github.com/nix-community/home-manager/issues/9747
#
# TODO: GitHub issues #9751 and #9747 — remove this override after the upstream
# fixes are available.
#
# This file:
#   Reproduces the upstream aerc/accounts.nix account-section generation
#   logic (basicCfg + sourceCfg + outgoingCfg + gpgCfg + aerc.extraAccounts),
#   reuses the fields already defined in accounts.email.accounts, changes only
#   the notmuch branch to the aerc 0.22 form (no maildir-store and no explicit
#   source path), and uses mkForce to override the generated
#   $XDG_CONFIG_HOME/aerc/accounts.conf.
#
# Restore upstream behavior: once upstream is fixed, delete this file and
# remove it from the imports in mail/default.nix.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    attrsets
    generators
    mapAttrs
    mkForce
    mkIf
    ;

  cfg = config.programs.aerc;

  configDir = "${config.xdg.configHome}/aerc";

  # Process only accounts with aerc integration enabled (same as the upstream
  # aerc-accounts filter).
  aercAccounts = attrsets.filterAttrs (
    _: v: v.enable && v.aerc.enable
  ) config.accounts.email.accounts;

  # ---------- Reproduce the upstream aerc/accounts.nix generation logic ----------

  optPort = port: if port != null then ":${toString port}" else "";

  optAttr = k: v: if v != null && v != [ ] && v != "" then { ${k} = v; } else { };

  optPwCmd = k: p: optAttr "${k}-cred-cmd" (if p != null then lib.concatStringsSep " " p else null);

  useOauth =
    auth:
    builtins.elem auth [
      "oauthbearer"
      "xoauth2"
    ];

  oauthParams =
    { auth, params }:
    if useOauth auth && params != null && params != { } then
      "?"
      + builtins.concatStringsSep "&" (
        attrsets.mapAttrsToList (k: v: k + "=" + lib.strings.escapeURL v) (
          attrsets.filterAttrs (_k: v: v != null) params
        )
      )
    else
      "";

  mkConfig = {
    # The only branch that differs from upstream: the correct notmuch format
    # for aerc 0.22.
    notmuch = account: {
      source = "notmuch://";
      maildir-account-path = "${account.maildir.path}";
    };

    maildir = account: {
      source = "maildir://${config.accounts.email.maildirBasePath}/${account.maildir.path}";
    };

    maildirpp = account: {
      source = "maildirpp://${config.accounts.email.maildirBasePath}/${account.maildir.path}/Inbox";
    };

    imap =
      account:
      let
        loginMethod' = if account.aerc.imapAuth != null then "+${account.aerc.imapAuth}" else "";

        oauthParams' = oauthParams {
          auth = account.aerc.imapAuth;
          params = account.aerc.imapOauth2Params;
        };

        protocol =
          if account.imap.tls.enable then
            if account.imap.tls.useStartTls then "imap" else "imaps${loginMethod'}"
          else
            "imap+insecure";

        userName' = lib.strings.escapeURL account.userName;
        port' = optPort account.imap.port;
      in
      {
        source = "${protocol}://${userName'}@${account.imap.host}${port'}${oauthParams'}";
      }
      // optPwCmd "source" account.passwordCommand;

    smtp =
      account:
      let
        loginMethod' = if account.aerc.smtpAuth != null then "+${account.aerc.smtpAuth}" else "";

        oauthParams' = oauthParams {
          auth = account.aerc.smtpAuth;
          params = account.aerc.smtpOauth2Params;
        };

        protocol =
          if account.smtp.tls.enable then
            if account.smtp.tls.useStartTls then "smtp${loginMethod'}" else "smtps${loginMethod'}"
          else
            "smtp+insecure${loginMethod'}";

        userName' = lib.strings.escapeURL account.userName;
        port' = optPort account.smtp.port;
      in
      {
        outgoing = "${protocol}://${userName'}@${account.smtp.host}${port'}${oauthParams'}";
      }
      // optPwCmd "outgoing" account.passwordCommand;

    msmtp = _account: {
      outgoing = "msmtpq --read-envelope-from --read-recipients";
    };
  };

  basicCfg =
    account:
    {
      from = "${account.realName} <${account.address}>";
    }
    // (optAttr "copy-to" account.folders.sent)
    // (optAttr "default" account.folders.inbox)
    // (optAttr "postpone" account.folders.drafts)
    // (optAttr "aliases" account.aliases);

  sourceCfg =
    account:
    if account.notmuch.enable then
      mkConfig.notmuch account
    else if
      account.mbsync.enable && account.mbsync.flatten == null && account.mbsync.subFolders == "Maildir++"
    then
      mkConfig.maildirpp account
    else if account.mbsync.enable || account.offlineimap.enable then
      mkConfig.maildir account
    else if account.imap != null then
      mkConfig.imap account
    else
      { };

  outgoingCfg =
    account:
    if account.msmtp.enable then
      mkConfig.msmtp account
    else if account.smtp != null then
      mkConfig.smtp account
    else
      { };

  gpgCfg =
    account:
    if account.gpg != null then
      {
        pgp-key-id = account.gpg.key;
        pgp-auto-sign = account.gpg.signByDefault;
        pgp-opportunistic-encrypt = account.gpg.encryptByDefault;
      }
    else
      { };

  mkAccount =
    _name: account:
    (basicCfg account)
    // (sourceCfg account)
    // (outgoingCfg account)
    // (gpgCfg account)
    // account.aerc.extraAccounts;

  # ---------- INI serialization (matching the upstream default.nix mkINI style) ----------

  mkValueString =
    v:
    if builtins.isList v then
      lib.concatStringsSep "," (map (generators.mkValueStringDefault { }) v)
    else
      generators.mkValueStringDefault { } v;

  mkKeyValue = generators.mkKeyValueDefault { inherit mkValueString; } " = ";

  sectionToINI =
    name: section:
    let
      content =
        if builtins.isString section then
          section
        else
          generators.toKeyValue { inherit mkKeyValue; } section;
    in
    if builtins.stringLength content > 0 then "[${lib.escape [ "[" "]" ] name}]\n${content}" else "";

  mkINI =
    conf: lib.concatStringsSep "\n" (lib.filter (v: v != "") (lib.mapAttrsToList sectionToINI conf));

  accountsINI = mkINI (mapAttrs mkAccount aercAccounts);
in
{
  config = mkIf cfg.enable {
    home.file."${configDir}/accounts.conf" = mkForce {
      text = ''
        # Generated by Home Manager (accounts.conf overridden locally:
        # home/tui/mail/aerc/accounts-conf.nix, adapts aerc 0.22 notmuch options).

      ''
      + accountsINI;
    };
  };
}
