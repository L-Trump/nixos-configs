{lib}: rec {
  nameservers = [
    "223.5.5.5" # alidns
    "119.29.29.29" # dnspod
    "8.8.8.8" # googledns
  ];

  hostsAddr.easytier = {
    matebook-gt14.ipv4 = "10.144.144.250";
    n100.ipv4 = "10.144.144.111";
  };

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
    extraConfig =
      lib.attrsets.foldlAttrs
      (acc: host: val:
        acc
        + ''
          Host ${host}
            HostName ${val.ipv4}
            Port 22
        '')
      ""
      hostsAddr.easytier;
  };
}
