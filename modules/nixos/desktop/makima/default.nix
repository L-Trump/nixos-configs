{
  pkgs,
  myvars,
  ...
}:
{
  environment.systemPackages = [ pkgs.makima ];
  environment.etc."makima".source = ./config;
  systemd.services."makima" = {
    enable = false;
    description = "Makima remappinig daemon";
    path = with pkgs; [
      makima
      bash
      coreutils-full
      "/run/wrappers/bin"
      "/run/current-system/sw/bin"
      "/etc/profiles/per-user/${myvars.username}/bin"
    ];
    restartIfChanged = true;
    restartTriggers = [ "/etc/makima" ];
    environment = {
      MAKIMA_CONFIG = "/etc/makima";
    };
    serviceConfig = {
      Type = "simple";
      Restart = "always";
      RestartSec = 3;
      ExecStart = "${pkgs.makima}/bin/makima";
      User = myvars.username;
      Group = "input";
    };
    wantedBy = [ "default.target" ];
  };
}
