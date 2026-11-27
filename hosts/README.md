# Hosts

1. `matebook-gt14`: My main laptop, Huawei Matebook GT14 2024, for daily use.
1. `rog-ga502`: My old laptop, ASUS ROG Zephyrus G15 2020 (GA502IV).
1. `n100`: N100 NUC in home, as homelab.
1. `aliyun-vm-sh`: Virtual machine on Aliyun, located in Shanghai, China.
1. `aliyun-vm-sh-qi`: Lightweight VM on Aliyun, located in Shanghai, China.
1. `aliyun-vm-hk`: Virtual machine on Aliyun, located in HongKong, China.
1. `llyun-vm-jp`: Virtual machine on Langlangyun, located in Tokyo, Japan.
1. `gx-vm-js`: Virtual machine on guanxingyun, located in Suqian, Jiangsu, China.
1. `jcloud`: Virtual machine on jCloud, located in Shanghai, China.
1. `iso`: For install/live image generation.
1. `microvms/microvm-umy`: MicroVM machine with daily use configs
<!-- 1. `tencent-vm-jp`: Virtual machine on Tencent Cloud, located in Japan. -->
<!-- 1. `chick-vm-cd`: Virtual machine on bigchick.xyz, located in Chengdu, Sichuan, China. -->
<!-- 1. `qfynat`: A NAT vps hosted by qfyidc, located in Hubei, China. -->

## How to add a new host

1. `hosts/<name>/`
   1. `modules/` (required, with `default.nix`): hardware configuration and machine-specific NixOS modules.
   1. `home/` (optional): machine-specific Home-Manager overrides (niri/DMS settings, lan-mouse, ...).
1. `outputs/x86_64-linux/hosts/<name>.nix` — the host's assembly file
   1. `name` must equal the hostname; the filename does not have to (e.g. `laptop-mbgt14.nix` -> `matebook-gt14`).
   1. `tags` decides the colmena batch target (`all` / `vps` / `home` / ...). Deprecating a host means
      commenting out its `all`/`vps` tags here instead of deleting the file.
   1. `preset` picks `mypresets.{bare,server,daily}`; override it with `myconfigs.mymodules` / `myconfigs.myhome`.
1. `vars/networking.nix`
   1. Add the host's easytier IP under `hostsAddr.easytier` (`/etc/hosts` records and ssh aliases derive from it).
   1. Add its physical IP too if the host is on the local network.
1. `nixos-secrets/` (the private repo)
   1. Add the host public key to the right group in `secrets.nix` (`all-hosts` / `server-hosts` / ...) and rekey.
   1. Add the easytier config (`ltnet-<host>.nix` or `ltnet-<host>.conf.age`); see `secrets/README.md`.
1. Verify: `nix build "path:$PWD#nixosConfigurations.<host>.config.system.build.toplevel" --dry-run --no-link`
1. Deploy: `colmena apply --on <host>` — build locally and push the closure; never use `--build-on-target`
   on the public VPS hosts.
