# Email account configuration structure (this file belongs to the public repository)
#
# This file defines the complete structure for all accounts: enabled integrations
# (aerc / offlineimap / imapnotify), folder mappings, sync parameters, and
# connection overrides. Privacy-sensitive values (email addresses, usernames,
# IMAP/SMTP servers, and passage entry names) are not defined here; they are
# provided by mail/account-data.nix from the nixos-secrets repository through
# the mysecrets input. This file only injects those values into the structure.
#
# Passwords are never stored on disk: passwordCommand retrieves them through
# passage at runtime.
{
  config,
  lib,
  mysecrets,
  ...
}:
let
  # Privacy data: account name -> { address, userName, realName, imap, smtp,
  # passage, folders }; primary marks the primary account.
  accountData = import "${mysecrets}/mail/account-data.nix";

  # Common account structure: all non-sensitive options are defined here.
  # Data-driven: every account uses the same structure, with sensitive values
  # injected from accountData.<name>.
  mkAccount = name: data: {
    primary = data.primary or false;
    realName = data.realName;
    address = data.address;
    userName = data.userName;
    passwordCommand = [
      "passage"
      data.passage
    ];

    imap = {
      inherit (data.imap) host port;
      # TLS defaults: enabled with no STARTTLS; an account can override these
      # values through data.imap.tls in accountData.
      tls = {
        enable = true;
        useStartTls = false;
      }
      // (data.imap.tls or { });
    };
    smtp = {
      inherit (data.smtp) host port;
      # TLS defaults: enabled with no STARTTLS; an account can override these
      # values through data.smtp.tls in accountData.
      tls = {
        enable = true;
        useStartTls = false;
      }
      // (data.smtp.tls or { });
    };

    # Special folder mappings (aerc: default=inbox, postpone=drafts,
    # copy-to=sent).
    # Defaults use English folder names; providers with different names (such
    # as the Chinese 163 folders) override them through folders in accountData.
    folders = {
      inbox = "INBOX";
      drafts = "Drafts";
      trash = "Trash";
      sent = null; # Do not automatically copy sent mail by default.
    }
    // (data.folders or { });

    # aerc: notmuch backend (full-text indexing and fast search), with periodic
    # checks and a synchronization command.
    # With notmuch.enable=true, Home Manager generates a notmuch source;
    # enable-maildir defaults to true, so the folder list is discovered from
    # the notmuch database's mail root. No query-map is needed, and
    # maildir-account-path is generated per account for the shared database.
    # multi-file-strategy: operate on the current directory when one message
    # has multiple files (the default refuse would make move/delete fail).
    aerc = {
      enable = true;
      extraAccounts = {
        "check-mail" = "5m";
        "check-mail-cmd" = "my-mail-sync ${name} quiet";
        "multi-file-strategy" = "act-dir";
        # aerc 0.22+: explicit paths in a notmuch source are deprecated; the
        # database path is discovered through $NOTMUCH_CONFIG.
        source = "notmuch://";
      };
    };

    # notmuch integration:
    # - Makes the aerc source notmuch:// (see above).
    # - Makes the imapnotify systemd unit set NOTMUCH_CONFIG automatically.
    #   The services.imapnotify module injects it, so no manual export is needed.
    notmuch.enable = true;

    # offlineimap: synchronize all folders, then run notmuch new.
    offlineimap = {
      enable = true;
      extraConfig.account.utf8foldernames = "yes";
      extraConfig.remote = {
        ssl_version = "tls1_2";
        maxconnections = 5;
        createfolders = false;
        retrycount = 5;
      };
      postSyncHookCommand = ''
        notmuch new
      '';
    };

    # goimapnotify: trigger synchronization and notification for new mail.
    # Connection parameters match the authoritative IMAP settings: all use
    # port 993 with TLS and no STARTTLS.
    imapnotify = {
      enable = true;
      onNotify = "my-mail-sync ${name} quiet";
      onNotifyPost = "offlineimap-notify ${name}";
      boxes = [ "INBOX" ];
      # goimapnotify 2.5.7: wait is not a configuration-file field; it is only
      # supported as the -wait command-line argument. Do not put wait in the
      # generated configuration; pass it through extraArgs below instead.
      extraArgs = [
        "-wait"
        "20"
      ];
      extraConfig = {
        enableIDCommand = true;
        xoAuth2 = false;
        tlsOptions.rejectUnauthorized = false;
        passwordCMD = "passage ${data.passage}";
      };
    };
  };
in
{
  accounts.email.maildirBasePath = "Mail";

  accounts.email.accounts = lib.mapAttrs mkAccount accountData.accounts;
}
