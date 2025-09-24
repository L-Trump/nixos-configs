{
  config,
  lib,
  myvars,
  pkgs,
  ...
}:
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."${myvars.username}" = {
    description = myvars.userfullname;
    openssh.authorizedKeys.keys = myvars.sshAuthorizedKeys;
  };

  security.polkit.enable = true;
}
