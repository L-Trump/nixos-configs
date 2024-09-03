let
  user-ltrump = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIy+DeKN/Lzov2h8cDsOjOwtRAA6c5WcTlQCwUpv9zB0";
  users = [ user-ltrump ];

  host-matebook-gt14 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM4EX2pnEnMWLxi5Es3sGtrF11xi7vPv+DS3A5nFWlQ2";
  hosts = [ host-matebook-gt14 ];
in
{
  "mail/aerc-accounts.conf.age".publicKeys = users ++ hosts;
  "mail/offlineimaprc.age".publicKeys = users ++ hosts;
  "mail/goimapnotify-config.yaml.age".publicKeys = users ++ hosts;
  "vpn/ipsec.conf.age".publicKeys = users ++ hosts;
  "vpn/ipsec.secrets.age".publicKeys = users ++ hosts;
  "vpn/strongswan.conf.age".publicKeys = users ++ hosts;
  "passage/Email/h-sjtu.age".publicKeys = users ++ hosts;
  "passage/Email/l-swjtu.age".publicKeys = users ++ hosts;
  "passage/Email/l-qq.age".publicKeys = users ++ hosts;
  "passage/Email/l-163.age".publicKeys = users ++ hosts;
  "passage/Email/y-163.age".publicKeys = users ++ hosts;
  "hosts/matebook-gt14/easytier-ltnet.conf.age".publicKeys = users ++ hosts;
}
