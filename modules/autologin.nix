{ pkgs, config, ... }:


{
  systemd.services."getty@tty1" = {
    overrideStrategy = "asDropin";
    serviceConfig.ExecStart = [ "" "@${pkgs.util-linux}/sbin/agetty agetty --login-program ${config.services.getty.loginProgram} --autologin ${config.users.users.ltrump.name} --noclear --keep-baud %I 115200,38400,9600 $TERM" ];
  };
}
