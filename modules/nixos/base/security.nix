{ myvars, ... }:
{
  # Allow no password sudo
  security.sudo.keepTerminfo = true;
  security.sudo.extraRules = [
    {
      users = [ myvars.username ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  programs.fuse.userAllowOther = true;
}
