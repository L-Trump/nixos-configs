{ config, lib, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ltrump = {
    isNormalUser = true;
    description = "ltrump";
    extraGroups = [ "wheel" "networkmanager" "video" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "zaC1lZDI1NTE5AAAAIIy+DeKN/Lzov2h8cDsOjOwtRAA6c5WcTlQCwUpv9zB0 ltrump@ltrumpArch-2021-05-28-LTrump"
    ];
  };

  security.polkit.enable = true;
  security.sudo.extraRules = [
    {
      users = [ "ltrump" ];
      commands = [ 
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      PermitRootLogin = "no";
      # PasswordAuthentication = false;
    };
  };
}

