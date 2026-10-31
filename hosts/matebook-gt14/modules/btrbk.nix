_: {
  services.btrbk.instances.persistent = {
    onCalendar = "*-*-* *:00,15,30,45:00"; # backup every 15min
    snapshotOnly = true;
    settings = {
      timestamp_format = "long-iso";
      snapshot_preserve_min = "4h";
      snapshot_preserve = "24h 14d";
      volume."/persistent" = {
        snapshot_dir = "/snapshots";
        subvolume."." = {
          snapshot_create = "onchange";
        };
      };
    };
  };
}
