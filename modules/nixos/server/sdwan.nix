{
  config,
  myvars,
  lib,
  inputs,
  ...
}:
let
  inherit (lib) mkDefault;
  inherit (inputs) mysecrets;
  inherit (myvars.networking) hostsRecord;
  inherit (config.networking) hostName;
  inherit (builtins) hasAttr pathExists;
  cfg.et-ltnet.enable = cfg.et-ltnet.hasConf || cfg.et-ltnet.enableSetting;
  cfg.et-ltnet.hasConf = hasAttr "easytier-conf" config.age.secrets;
  cfg.et-ltnet.enableSetting = hasAttr "${hostName}" myvars.networking.hostsAddr.easytier;
  cfg.et-ltnet.envFiles =
    [ ]
    ++ lib.optional (hasAttr "et-ltnet-env" config.age.secrets) config.age.secrets.et-ltnet-env.path
    ++ lib.optional (hasAttr "et-ltnet-env-host" config.age.secrets) config.age.secrets.et-ltnet-env-host.path;
  cfg.et = config.mymodules.server.easytier;
  commonConf =
    if (pathExists "${mysecrets}/easytier/ltnet.nix") then
      (import "${mysecrets}/easytier/ltnet.nix" { inherit lib; })
    else
      { };
  hostConf =
    if (pathExists "${mysecrets}/easytier/ltnet-${hostName}.nix") then
      (import "${mysecrets}/easytier/ltnet-${hostName}.nix" { inherit lib; })
    else
      { };
  ltnetSettings = lib.mkMerge [
    {
      environmentFiles = cfg.et-ltnet.envFiles;
      settings = {
        instance_name = mkDefault "ltnet";
        ipv4 = mkDefault (myvars.networking.hostsAddr.easytier.${hostName}.ipv4 + "/24");
        dhcp = mkDefault false;
        listeners = [
          "tcp://0.0.0.0:11010"
          "udp://0.0.0.0:11010"
          "wg://0.0.0.0:11011"
          "ws://0.0.0.0:11011/"
          "wss://0.0.0.0:11012/"
        ];
      };
      extraSettings = {
        exit_nodes = [ ];
        rpc_portal = mkDefault "127.0.0.1:15888";
        flags = {
          default_protocol = mkDefault "tcp";
          dev_name = mkDefault "easytier.ltnet";
          enable_encryption = mkDefault true;
          enable_ipv6 = mkDefault true;
          mtu = mkDefault 1200;
          latency_first = mkDefault false;
          enable_exit_node = mkDefault true;
          no_tun = mkDefault false;
          use_smoltcp = mkDefault false;
          disable_p2p = mkDefault false;
          disable_udp_hole_punching = mkDefault false;
          relay_all_peer_rpc = mkDefault false;
          relay_network_whitelist = mkDefault "ltnet ltnet*";
          multi_thread = mkDefault true;
          bind_device = mkDefault true;
          enable_kcp_proxy = mkDefault false;
          disable_kcp_input = mkDefault false;
          enable_quic_proxy = mkDefault false;
          disable_quic_input = mkDefault false;
        };
      };
    }
    commonConf
    hostConf
  ];
in
{
  services.tailscale = {
    enable = true;
    openFirewall = true;
  };

  services.easytier = {
    enable = cfg.et.enable;
    allowSystemForward = true;
    instances.web = {
      configServer = cfg.et.config-server;
      extraArgs = [
        "-r"
        "15889"
      ];
    };
    instances.ltnet = lib.mkMerge [
      (lib.mkIf (cfg.et-ltnet.hasConf) {
        configFile = config.age.secrets.easytier-conf.path;
      })
      (lib.mkIf (!cfg.et-ltnet.hasConf && cfg.et-ltnet.enableSetting) ltnetSettings)
    ];
  };

  networking = lib.mkIf (cfg.et.enable && cfg.et-ltnet.enable) {
    hosts = lib.mkIf cfg.et-ltnet.enable hostsRecord;
    firewall = {
      trustedInterfaces = [ "easytier.ltnet" ];
      allowedTCPPortRanges = [
        {
          from = 11010;
          to = 11020;
        }
      ];
      allowedUDPPortRanges = [
        {
          from = 11010;
          to = 11020;
        }
      ];
    };
  };
}
