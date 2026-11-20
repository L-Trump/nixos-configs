{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mymodules.desktop.remote-desktop;
  rustdesk = pkgs.rustdesk-unattended-wayland;

  # deb 打包时算好的 GStreamer 插件路径；换包时允许没有，不能因此炸掉 eval
  gstPluginPath = rustdesk.passthru.gstPluginPath or "";
in
{
  services.sunshine = lib.mkIf cfg.sunshine.enable {
    enable = true;
    openFirewall = true;
    capSysAdmin = true;
  };

  environment.systemPackages = lib.mkIf cfg.rustdesk.enable [ rustdesk ];

  systemd.tmpfiles.rules = lib.mkIf cfg.rustdesk.enable [
    "d /usr/lib/rustdesk 0755 root root -"
    "L+ /usr/lib/rustdesk/libdrmtap.so.0 - - - - ${pkgs.libdrmtap}/lib/libdrmtap.so.0"
  ];

  systemd.services.rustdesk = lib.mkIf cfg.rustdesk.enable {
    description = "RustDesk remote desktop service";
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    after = [
      "network-online.target"
      "systemd-user-sessions.service"
      "display-manager.service"
    ];

    path = [
      "/run/wrappers"
      pkgs.procps
    ];

    environment = {
      PULSE_LATENCY_MSEC = "60";
      PIPEWIRE_LATENCY = "1024/48000";
    }
    // lib.optionalAttrs (gstPluginPath != "") {
      GST_PLUGIN_SYSTEM_PATH_1_0 = gstPluginPath;
    };

    serviceConfig = {
      ExecStart = "${rustdesk}/bin/rustdesk --service";
      Restart = "always";
      RestartSec = 2;
      KillMode = "mixed";
      TimeoutStopSec = 30;
      LimitNOFILE = 100000;
    };
  };
}
