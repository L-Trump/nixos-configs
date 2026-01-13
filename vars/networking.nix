{ lib }:
let
  sshDefault = {
    port = 22;
    user = "ltrump";
  };
in
rec {
  nameservers = [
    "223.5.5.5" # alidns
    "119.29.29.29" # dnspod
    "8.8.8.8" # googledns
  ];
  nameservers6 = [
    "2400:3200::1" # alidns
    "2402:4e00::" # dnspod
    "2001:4860:4860::8888" # googledns
  ];

  hostsAddr.easytier = {
    nas = {
      ipv4 = "10.144.144.110";
      ssh.port = 2233;
    };
    n100.ipv4 = "10.144.144.111";
    microvm-umy.ipv4 = "10.144.144.112";
    gs445.ipv4 = "10.144.144.195";
    gs445-2.ipv4 = "10.144.144.196";
    eo-deep = {
      ipv4 = "10.144.144.197";
      ssh.user = "caddy";
    };
    oneplus-ace.ipv4 = "10.144.144.239";
    homewin.ipv4 = "10.144.144.240";
    nucwin.ipv4 = "10.144.144.241";
    aliyun-vm-hk.ipv4 = "10.144.144.245";
    rhcg-dell.ipv4 = "10.144.144.246";
    rog-ga502.ipv4 = "10.144.144.247";
    matepad.ipv4 = "10.144.144.248";
    matebook-gt14.ipv4 = "10.144.144.250";
    aliyun-vm-sh = {
      ipv4 = "10.144.144.251";
      domainPrefix = [
        "backup"
        "alist"
        "olist"
      ];
    };
    gx-vm-js.ipv4 = "10.144.144.252";
    dice = {
      ipv4 = "10.144.144.254";
      ssh.port = 223;
    };
    # eo-acs = {
    #   ipv4 = "10.144.144.199";
    #   ssh.user = "caddy";
    # };
  };

  # Physical interfaces declaration
  # Home devices
  hostsAddr.physical = {
    n100 = {
      iface = "enp2s0";
      ipv4 = "192.168.2.111/24";
      gateway = "192.168.2.1";
    };
    microvm-umy = {
      iface = "enp*";
      ipv4 = "192.168.2.112/24";
      gateway = "192.168.2.1";
    };
    qfynat = {
      iface = "enp*";
      ipv4 = "172.16.0.18/12";
      gateway = "172.16.0.1";
    };
  };

  hostsRecord = lib.attrsets.foldlAttrs (
    acc: host: val:
    let
      prefix = if builtins.hasAttr "domainPrefix" val then val.domainPrefix else [ ];
    in
    acc
    // {
      "${val.ipv4}" = [ "${host}.ltnet" ] ++ (builtins.map (f: f + ".${host}.ltnet") prefix);
    }
  ) { } hostsAddr.easytier;

  ssh = {
    # define the host alias for remote builders
    # this config will be written to /etc/ssh/ssh_config
    # ''
    #   Host ruby
    #     HostName 192.168.5.102
    #     Port 22
    #
    #   Host kana
    #     HostName 192.168.5.103
    #     Port 22
    #   ...
    # '';
    extraConfig = lib.attrsets.foldlAttrs (
      acc: host: val:
      let
        ssh = sshDefault // (if builtins.hasAttr "ssh" val then val.ssh else { });
      in
      acc
      + ''
        Host ${host}
          HostName ${val.ipv4}
          Port ${toString ssh.port}
          User ${ssh.user}
        Host ${host}.ltnet
          HostName ${val.ipv4}
          Port ${toString ssh.port}
          User ${ssh.user}
      ''
    ) "" hostsAddr.easytier;
  };
}
