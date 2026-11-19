{
  config,
  pkgs,
  lib,
  ...
}:
let
  # Same package as home/tui/mail/default.nix; the store path is deduplicated.
  mail-scripts = pkgs.mkScriptsPackage "mail-scripts" ./scripts;

  # Everything the sync + notification path may exec. notify-send/paplay are
  # not strictly required (mail-notify-all tolerates failures), but python3 is:
  # offlineimap-notify decodes mail headers with `python3 -c`.
  syncPath = lib.makeBinPath [
    mail-scripts
    pkgs.offlineimap
    pkgs.passage
    pkgs.notmuch
    pkgs.python3
    pkgs.procps
    pkgs.libnotify
  ];
in
{
  config = lib.mkIf config.myhome.tuiExtra.mail.enable {
    # Periodic full sync, the primary sync driver.
    systemd.user.services.mail-sync = {
      Unit = {
        Description = "Full offlineimap sync of all accounts + notmuch index";
        # A hung IMAP session must not wedge the schedule: the next tick retries.
        StartLimitIntervalSec = 0;
      };
      Service = {
        Type = "oneshot";
        Environment = "PATH=${syncPath}:/run/wrappers/bin:/run/current-system/sw/bin";
        ExecStart = "${mail-scripts}/bin/my-mail-sync quiet";
        # Event-free path: notify about whatever the timer just pulled in.
        ExecStartPost = "${mail-scripts}/bin/mail-notify-all";
        # Upper bound for the whole run; my-mail-sync's pgrep guard prevents two
        # runs from overlapping if this ever does time out mid-sync.
        TimeoutStartSec = "20min";
        Nice = 10;
        IOSchedulingClass = "idle";
      };
    };

    systemd.user.timers.mail-sync = {
      Unit.Description = "Periodic full mail sync (30 min)";
      Timer = {
        # Wall-clock ticks at :00/:30 rather than a monotonic 30 min, so that
        # Persistent=true can catch up ticks missed while suspended/off.
        OnBootSec = "5min";
        OnCalendar = "*:0/30";
        Persistent = true;
        AccuracySec = "1min";
        Unit = "mail-sync.service";
      };
      Install.WantedBy = [ "timers.target" ];
    };
  };
}
