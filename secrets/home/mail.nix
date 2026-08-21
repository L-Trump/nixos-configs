{
  lib,
  config,
  inputs,
  ...
}:
let
  inherit (inputs) mysecrets;
  cfg = config.myhome.tuiExtra.mail;
in
{
  config = lib.mkIf cfg.enable {
    # The email account configuration structure is in the public repository:
    # home/tui/mail/accounts.nix.
    # Sensitive values (addresses/usernames/servers/passage entry names) come
    # from nixos-secrets/mail/account-data.nix.
    # Passwords are never stored on disk; offlineimap, aerc, and goimapnotify
    # retrieve them through passage at runtime.

    # Sync the passage password store (all mailbox passwords).
    home.file.".passage/store/Email" = {
      source = "${mysecrets}/passage/Email";
      recursive = true;
    };
  };
}
