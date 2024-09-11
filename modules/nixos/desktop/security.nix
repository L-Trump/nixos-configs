{ config
, myvars
, pkgs
, ...
}: {
  # security with polkit
  security.polkit.enable = true;
  # security with gnome-kering
  services.gnome.gnome-keyring.enable = true;

  environment.systemPackages = with pkgs; [ lxqt.lxqt-policykit ];

  # gpg agent with pinentry
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-qt;
    enableSSHSupport = false;
    settings.default-cache-ttl = 4 * 60 * 60; # 4 hours
  };

  # autologin
  systemd.services."getty@tty1" = {
    overrideStrategy = "asDropin";
    serviceConfig.ExecStart = [
      ""
      "@${pkgs.util-linux}/sbin/agetty agetty --login-program ${config.services.getty.loginProgram} --autologin ${myvars.username} --noclear --keep-baud %I 115200,38400,9600 $TERM"
    ];
  };
}
