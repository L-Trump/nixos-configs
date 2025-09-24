{
  pkgs,
  myvars,
  ...
}:
let
  hostName = "microvm-umy";
  inherit (myvars) networking;
  inherit (networking.hostsAddr.physical.${hostName}) iface ipv4 gateway;
in
{
  networking.useDHCP = false;
  systemd.network = {
    enable = true;
    wait-online = {
      anyInterface = true;
      timeout = 30;
    };
    networks."20-lan" = {
      matchConfig.Name = [ iface ];
      networkConfig = {
        Address = [ ipv4 ];
        Gateway = gateway;
        DNS = networking.nameservers;
        IPv6AcceptRA = true;
      };
      linkConfig.RequiredForOnline = "routable";
    };
  };
}
