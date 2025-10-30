{
  config,
  myvars,
  pkgs,
  ...
}:
let
  pinentry-auto = pkgs.writeShellApplication {
    name = "pinentry-auto";
    runtimeInputs = with pkgs; [
      pinentry-qt
      pinentry-curses
    ];
    text = ''
      set -eu
      # Configuration -- adjust these to your liking
      PINENTRY_TERMINAL='${pkgs.pinentry-curses}/bin/pinentry'
      PINENTRY_X11='${pkgs.pinentry-qt}/bin/pinentry'
      # Action happens below!
      if [ -n "''${DISPLAY-}" ]; then
          exec "$PINENTRY_X11" "$@"
      else
          exec "$PINENTRY_TERMINAL" "$@"
      fi
    '';
  };
in
{
  # security with polkit
  security.polkit.enable = true;
  # security with gnome-kering
  services.gnome.gnome-keyring.enable = true;
  services.gnome.gcr-ssh-agent.enable = false;

  environment.systemPackages = with pkgs; [
    lxqt.lxqt-policykit
    bitwarden-desktop
  ];

  # gpg agent with pinentry
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pinentry-auto;
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
