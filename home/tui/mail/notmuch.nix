{
  config,
  pkgs,
  lib,
  ...
}:
{
  # Full-text index for mail.
  # Account identity (user.name/email) is generated automatically from
  # accounts.email.accounts.
  # The public account structure is in home/tui/mail/accounts.nix; sensitive
  # values are loaded from nixos-secrets/mail/account-data.nix.
  programs.notmuch = {
    enable = true;

    new = {
      tags = [ "new" ];
      ignore = [
        ".git"
        ".nix"
      ];
    };

    search.excludeTags = [
      "deleted"
      "spam"
    ];

    maildir.synchronizeFlags = true;
  };
}
