{
  myvars,
  mysecrets,
  pkgs,
  lib,
  ...
}:
let
  u2fAuthFile = "${mysecrets}/canokey/u2f_keys";
  ltnetCAFile = "${mysecrets}/ssl/ltnet-ca.crt";
in
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

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
    settings.default-cache-ttl = 4 * 60 * 60; # 4 hours
  };

  security.pki.certificateFiles = [
    ltnetCAFile
  ];

  # Canokeys related
  environment.systemPackages = with pkgs; [ ccid ];
  programs.yubikey-manager.enable = true;
  services.udev.extraRules = ''
    # GnuPG/pcsclite
    SUBSYSTEM!="usb", GOTO="canokeys_rules_end"
    ACTION!="add|change", GOTO="canokeys_rules_end"
    ATTRS{idVendor}=="20a0", ATTRS{idProduct}=="42d4", ENV{ID_SMARTCARD_READER}="1"
    LABEL="canokeys_rules_end"

    # FIDO2
    # note that if you find this line in 70-fido.rules, you can ignore it
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="20a0", ATTRS{idProduct}=="42d4", TAG+="uaccess", GROUP="plugdev", MODE="0660"

    # make this usb device accessible for users, used in WebUSB
    # change the mode so unprivileged users can access it, insecure rule, though
    SUBSYSTEMS=="usb", ATTR{idVendor}=="20a0", ATTR{idProduct}=="42d4", MODE:="0666"
    # if the above works for WebUSB (web console), you may change into a more secure way
    # choose one of the following rules
    # note if you use "plugdev", make sure you have this group and the wanted user is in that group
    #SUBSYSTEMS=="usb", ATTR{idVendor}=="20a0", ATTR{idProduct}=="42d4", GROUP="plugdev", MODE="0660"
    #SUBSYSTEMS=="usb", ATTR{idVendor}=="20a0", ATTR{idProduct}=="42d4", TAG+="uaccess"
  '';
  security.pam.u2f = {
    enable = true;
    settings = {
      origin = "pam://ltrumpcanokey";
      appid = "pam://ltrumpcanokey";
      cue = true;
      authfile = lib.mkIf (builtins.pathExists u2fAuthFile) u2fAuthFile;
    };
  };
  security.pam.services = {
    login.u2fAuth = true;
  };
}
