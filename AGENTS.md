# AGENTS.md — LTrump's NixOS 配置仓库

> 给在本仓库工作的 AI agent 的上手手册：仓库结构、配置约定、改动路径、验证方式、已知坑。
> 建议阅读顺序：§0 红线 → §1 心智模型 → §2 目录地图；干活时查 §5 子系统 / §6 配方 / §7 验证。

---

## 0. 红线与开工清单

### 0.1 必须先获得用户明确确认

| 类别 | 例子 | 说明 |
| --- | --- | --- |
| 系统级操作 | `just switch`、`nixos-rebuild`、`colmena apply`、`just col <tag>` | 会改动真实机器；用户在本机有 NOPASSWD sudo，任何 `sudo` 命令同样谨慎 |
| 清理/破坏性 | `just gc` / `gcall` / `gc7d` / `just clean`、`rm`、`trash` 之外的重命名 | |
| 跨仓库提交 | 在 `nixos-secrets/` 里 `commit` / `push`、`just upp mysecrets`（动 flake.lock）、`agenix -r`（重写全部密文） | 私密仓库 + 锁文件，rekey 影响所有主机 |
| git 危险动作 | `git add -A`（见 §8.1）、`reset --hard`、`push --force` | |
| 外部动作 | 发消息/邮件、发布、联系他人 | 用户全局规则 |

### 0.2 可以直接做

- 读文件、搜索、`nix eval`、`nix build --dry-run`、`just preview`（本机构建，不切换）。
- 在本仓库内新增/编辑文件（不删除、不覆盖用户未要求改动的内容）。
- **不要**顺手 `git add` / commit，除非用户要求。

### 0.3 开工三件事

```bash
git status -sb && git log --oneline -10   # 常有在途半成品，不要 revert 别人的修改
hostname                                   # 本机 = rog-ga502；很多命令以当前 hostname 为目标
nix eval .#nixosConfigurations --apply builtins.attrNames --json   # 确认所有主机名（与文件名不一定一致）
```

### 0.4 术语表

| 术语 | 含义 |
| --- | --- |
| `myvars` | 合并后的全局值：`vars/*.nix` + `nixos-secrets/vars/*.nix`（私密仓库优先）。含 username、sshAuthorizedKeys、networking、containers、nixpkgs-config |
| `mymodules` / `config.mymodules` | NixOS 侧开关。前者是 host 文件里传入的**原始** attrs，后者是 `modules/options.nix` 声明、经 module system 合并后的值 |
| `myhome` / `config.myhome` | Home-Manager 侧开关，同上（`home/options.nix`） |
| preset | `outputs/config-presets/{bare,server,daily}.nix`，被 host 文件 `recursiveUpdate` 覆盖 |
| 总装单 | `outputs/x86_64-linux/hosts/<host>.nix`（或 `microvms/`），一台机器的完整定义 |
| ltnet | 基于 easytier 的 SDWAN 网段 `10.144.144.0/24`，主机名 `<host>.ltnet` |

---

## 1. 心智模型

四层"值 → 模块 → 单机差异 → 开关"，加两个外部私密仓库：

```
数据/值      vars/{default,networking,nixpkgs-config,containers}.nix   +   nixos-secrets/vars/*
通用行为     modules/base（全平台） modules/nixos/{base,desktop,server,containers}   +   home/{core,tui,gui}
单机差异     hosts/<host>/{modules,home}/      outputs/x86_64-linux/hosts/<host>.nix（preset + 开关覆盖）
外部仓库     mysecrets（secrets/配置）、myfonts、mywallpapers —— 都是 flake input，不是本仓库内容
```

设计原则（改动时请遵守）：

1. **通用行为进 `modules/`，单机差异进 `hosts/<host>/`**，不要为某一台机器在通用模块里写 `if hostname == ...`。
2. **功能用开关表达**：新增能力 = `options.nix` 加开关 + 模块读开关 + host 总装单开开关（§4.5）。
3. **能自动导入就不手写 imports**：`mylib.scanPaths` 扫目录（§4.1）。
4. **密钥/私密配置不进公开仓库**，只留引用（§5.6）。

---

## 2. 目录地图

| 路径 | 放什么 | 我想改 X → 来这里 |
| --- | --- | --- |
| `flake.nix` | inputs 声明（nixpkgs/unstable/stable、home-manager、agenix、haumea、microvm、mysecrets、pi、openviking、nix-openclaw…） | 加新依赖/输入 |
| `Justfile` | 所有运维命令（**fish 语法** shell） | 加命令（用 fish 写） |
| `lib/` | `nixosSystem.nix`、`colmenaSystem.nix`、`microvmInfra.nix`、`toKDL.nix`、`relativeToRoot`、`scanPaths` | 改各主机的组装方式 |
| `outputs/default.nix` | 汇总所有输出、`genSpecialArgs`、`myvars` 合并 | 改全局注入 |
| `outputs/config-presets/` | `bare`（全关）/ `server`（服务器默认）/ `daily`（桌面默认） | 改一类机器的默认开关 |
| `outputs/x86_64-linux/hosts/*.nix` | **每台机器的总装单** | 开/关某台机器的功能、tags、ssh-user |
| `outputs/x86_64-linux/microvms/*.nix` | microvm guest 总装单（额外有 `microvm-infras`、`packages.<name>`） | microvm |
| `modules/options.nix` | **NixOS 开关总表** `mymodules.*` | 新增 NixOS 功能开关 |
| `modules/base/` | 全主机：nix settings(GitHub 缓存/GC/registry/comma)、overlays、系统包、用户与 polkit | 系统包、nix 配置、authorizedKeys |
| `modules/nixos/base/` | core(grub/power)、environments(系统 CLI 包)、i18n(时区/中文)、log、network(avahi/ntp/firewall)、security(sudo/u2f/CA)、ssh、ttyd、user-group、virtualization(docker/qemu/microvm)、zram | 基础系统行为 |
| `modules/nixos/desktop/` | wayland(niri/hyprland/uwsm)、hardware(pipewire/打印/蓝牙)、fonts、fhs、i3(xorg，已弃用)、network(clash-verge)、remote-desktop(sunshine)、security(pinentry)、game、makima(数位板)、animeboot(grub+plymouth)、vpn(SJTU ipsec/forti) | 桌面系统层 |
| `modules/nixos/server/` | 各服务模块；**端口表见 `server/README.md`** | 服务端服务 |
| `modules/nixos/containers/` | OCI(docker) 容器服务 + `oci_net` 网络与 `docker-compose-oci-root.target` | 容器化服务 |
| `home/options.nix` | **HM 开关总表** `myhome.*` | 新增 HM 开关 |
| `home/core/` | 全主机 HM：editors、git、nix-settings、packages、security(gpg)、shells(fish/starship/zellij/…)、nnn、yazi、pip、dev 工具 | 所有机器都有的用户配置 |
| `home/tui/` | `tuiExtra.enable` 下的终端向配置：`mail/`、`openclaw/`、`pi/`、`editors/{neovim,lsp}`、`dev-tools.nix` | 远程/终端工作流 |
| `home/gui/` | `desktop.enable` 下的图形配置：`wayland/{niri,hyprland,waybar,swaylock}`、`fcitx5/`、`dunst/`、`terminal/`、`appearance/`、`daily/`、`scripts/bin/`（自定义脚本）、`xdg-portals/` | 桌面用户层 |
| `hosts/<host>/modules/` | 该机专属 NixOS 模块（impermanence、nvidia、fingerprint、proxmox、touch-screen…） | 单机系统差异 |
| `hosts/<host>/home/` | 该机专属 HM 模块（niri/hyprland 覆盖、lan-mouse、syncthing…） | 单机用户差异 |
| `hosts/microvms/<name>/` | microvm guest 的单机配置 | |
| `vars/` | `networking.nix`（**easytier IP 真源**、ssh 别名、/etc/hosts）、`containers.nix`（镜像 digest）、`nixpkgs-config.nix`、`default.nix` | IP、镜像版本、unfree 白名单 |
| `secrets/` | agenix 接线：`modules/`（NixOS 侧 `age.secrets`）、`home/`（HM 侧） | 新增/修改密钥引用 |
| `nixos-secrets/` | 私密仓库的**本地 clone**（.gitignore），编辑用；构建读的是 flake input | 改密钥/私密配置 |
| `packages/` | 自定义包与补丁后的上游包，经 overlay 注入 → 全局 `pkgs.<name>` | 打包 |
| `overlays/` | `packages.nix`(注入)、`tools.nix`(`mkScriptsPackage` 等)、`nurs.nix` | 覆盖 nixpkgs |
| `scripts/update_containers.sh` | 用 skopeo 刷新 `vars/containers.nix` 的 digest | 更新容器镜像 |
| `_img/`、`README.md`、`hosts/README.md`、`outputs/README.md`、`secrets/README.md` | 文档 | 先读再改相关区域 |

---

## 3. flake 组装与输出

### 3.1 数据流

```text
flake.nix
└── outputs/default.nix
    ├── vars        = import ../vars
    ├── secret-vars = import ${mysecrets}/vars
    ├── myvars      = recursiveUpdate vars secret-vars        # 私密仓库的键覆盖本地
    ├── mypresets   = import ./config-presets
    ├── mylib       = import ../lib
    ├── genSpecialArgs system = inputs // { mylib, myvars, inputs, genSpecialArgs, pkgs-unstable, pkgs-stable }
    └── outputs/x86_64-linux/default.nix        # haumea.lib.load ./hosts ./microvms
            └── hosts/<file>.nix ∋
                  name / tags / ssh-user            → colmena deployment
                  preset                            → mypresets.{bare,server,daily}
                  myconfigs.mymodules / .myhome     → 该机开关（recursiveUpdate 覆盖 preset）
                  modules.nixos-modules             = [ "secrets/modules" "modules/nixos/default.nix" "hosts/<name>/modules" ]
                  modules.home-modules              = [ "home/default.nix" "secrets/home"（可选 "hosts/<name>/home"） ]
                  systemArgs = modules // args // myconfigs
                    ├── mylib.nixosSystem   → nixosConfigurations.<name>
                    ├── mylib.colmenaSystem → colmena.<name>  （+ colmenaMeta.nodeNixpkgs/nodeSpecialArgs）
                    └── mylib.microvmInfra  → microvm-infras.<name>（仅 microvm 总装单）
```

### 3.2 模块里能直接接住的参数

`specialArgs` 展开后（`outputs/default.nix:genSpecialArgs` + `lib/nixosSystem.nix`）：

| 参数 | 说明 |
| --- | --- |
| `inputs` / 各 input 名（`mysecrets`、`nixpkgs`、`agenix`、`hyprland`…） | `inputs` 被平铺，所以 `mysecrets` 可直接用 |
| `mylib` | `relativeToRoot`、`scanPaths`、`toKDL`、`nixosSystem`、`colmenaSystem`、`microvmInfra` |
| `myvars` | 见术语表 |
| `pkgs` / `nixpkgs` | 主 nixpkgs（含本仓库 overlay） |
| `pkgs-unstable` / `pkgs-stable` | `nixos-unstable-small` 与 `nixos-26.05` 的实例（`config = myvars.nixpkgs-config`） |
| `mymodules` / `myhome` | 原始开关 attrs；HM 侧在 nixosSystem 路径会额外注入 `systemConfig`，colmena 路径**没有** |
| `config` / `lib` / `pkgs` | 标准 module 参数 |

### 3.3 输出清单

| 输出 | 用途 |
| --- | --- |
| `nixosConfigurations.<host>` | 构建/切换目标（`--flake .#<host>`；省略 `#host` 时取当前 hostname） |
| `colmena.<host>` + `colmena.meta` | 远程部署（`colmena apply --on '@<tag>'`） |
| `microvm-infras.<name>` | 由宿主机的 `microvm.host.vms` 消费（来自 `virtualization.microvm.host.infras`） |
| `packages.x86_64-linux.{iso,microvm-umy,<pkgs>}` | 镜像与可交付产物 |
| `formatter` | `nix fmt` → nixfmt |
| `debugAttrs` | 调试：`myvars`、`allSystemNames` 等 |

> 注意：`mysecrets` / `nix-openclaw` 这两个 input 可能被 `flake.lock` override 到本机 clone（`file://`，见 §5.9）——排查"改了没生效"时先 `nix flake metadata | grep <input>` 看实际来源。

### 3.4 主机清单

| host (`nixosConfigurations`) | 总装单 | 角色 | colmena tags |
| --- | --- | --- | --- |
| `matebook-gt14` | `hosts/laptop-mbgt14.nix` ⚠️文件名≠hostname | 主笔电（daily preset + impermanence + nvidia/intel） | name |
| `rog-ga502` | `hosts/rog-ga502.nix` | **本机**，旧笔电（daily + impermanence + nvidia + openclaw/openviking/openlist） | name |
| `n100` | `hosts/n100.nix` | 家里 NUC / homelab（server preset + proxmox/qemu + docker + sub2api + xpipe-webtop + syncthing） | name, all, home |
| `microvm-umy` | `microvms/microvm-umy.nix` | 家庭 microvm guest（daily + `microvm.guest.enable`） | name |
| `aliyun-vm-sh` | `hosts/aliyun-vm-sh.nix` | 阿里云上海（服务最全：rustdesk/nezha-server/vaultwarden/homepage/siyuan/rustical/ncm-api…） | name, vm-sh, all, vps |
| `aliyun-vm-sh-qi` | `hosts/aliyun-vm-sh-qi.nix` | 阿里云上海轻量（siyuan/sub2api/novnc-websockify/juicefs + redis slave） | name, vm-sh-qi, all, vps |
| `aliyun-vm-hk` | `hosts/aliyun-vm-hk.nix` | 阿里云香港（backrest + hubproxy） | name, vm-hk, all, vps |
| `llyun-vm-jp` | `hosts/llyun-vm-jp.nix` | 浪浪云东京（backrest + hubproxy + openclaw） | name, vm-jp, all, vps |
| `iso` | `hosts/iso.nix` | 安装镜像（bare + niri）→ `nix build .#iso` | 无 |
| 弃用/备用 | `chick-vm-cd` `gx-vm-js` `jcloud` `qfynat` `tencent-vm-jp` | 保留输出，但 `all`/`vps` tag 被注释 → 不进批量部署 | name(+注释) |

**弃用一台机器 = 注释掉它的 `all`/`vps` tag**，不要删文件。

---

## 4. 代码约定与模板

### 4.1 通用约定

- **格式**：`nixfmt`（RFC style），`just fmt` / `nix fmt`。仓库基本已格式化（提交前跑一次）。
- **自动导入**：目录里的 `default.nix` 写 `imports = mylib.scanPaths ./.;` → 该目录下每个 `.nix`（除 `default.nix`）自动 import。新增文件**不需要**改 imports，但也意味着无法靠文件名控制加载顺序。
- **命名**：选项用小写-连字符（`openviking-server`、`novnc-websockify`）；模块文件与服务同名；host 目录名 = hostname。
- **写法**：服务模块通常 `let cfg = config.mymodules.<...>; in { config = lib.mkIf cfg.enable { ... }; }`；需要读未合并的原始开关时用 `rawcfg = mymodules.<...>`（例如 `lib.optionals rawcfg.enable [ ... ]` 决定 import）。
- **注释语言**：历史上是英文，近期 openclaw/mail 等子系统用中文；跟随所改文件的既有语言，不要整片翻译。
- **不要删总装单里的函数参数**（`inputs/lib/myvars/mypresets/mylib/system/genSpecialArgs`）：haumea 惰性求值 + `mylib.*` 会用到，文件头注释有说明。
- **commit message**：Conventional Commits 风格 + 范围，如 `feat(openclaw): ...`、`fix(containers): fix siyuan server entry`、`chore(packages): update siyuan to 3.8.1`、`refact(home/tui): mail workflow refact`。一次提交只做一件事。

### 4.2 NixOS 服务模块模板

```nix
{
  config,
  lib,
  pkgs,
  myvars,
  mymodules,      # 需要"原始开关"时才加
  ...
}:
let
  cfg = config.mymodules.server.<name>;
  inherit (config.networking) hostName;
in
{
  config = lib.mkIf cfg.enable {
    services.<svc>.enable = true;
    networking.firewall.allowedTCPPorts = [ <port> ];
  };
}
```

### 4.3 容器（OCI/docker）服务模板

参考 `modules/nixos/containers/nezha-server.nix`：

```nix
virtualisation.oci-containers.containers.${name} = {
  image = "${container.image}@${container.digest}";   # container = myvars.containers.${name}
  ports = [ "127.0.0.1:<port>:<port>/tcp" "${et-ip}:<port>:<port>/tcp" ];
  extraOptions = [ "--network-alias=${name}" "--network=oci_net" ];
  volumes = [ "/data/docker/${name}/data:/data:rw" ];
};
systemd.services."docker-${name}" = { after = [ "docker-network-oci_net.service" ]; requires = [ ... ]; partOf = [ "docker-compose-oci-root.target" ]; wantedBy = [ ... ]; };
```

数据固定落在 `/data/docker/<name>/`（宿主机需 `mymodules.virtualization.docker.enable`，`oci_net` 由 `containers/default.nix` 创建）。

### 4.4 Home-Manager 模块模板

```nix
{ config, lib, pkgs, myhome, ... }:
let
  cfg = config.myhome.desktop.<feature>;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = [ ... ];
    xdg.configFile."app/config".source = ./config;
  };
}
```

### 4.5 新增开关的完整链路（务必五处齐全）

1. `modules/options.nix`（或 `home/options.nix`）：声明 `mkEnableOption`/`mkOption`。
2. 模块文件：`modules/nixos/server/<name>.nix` / `home/{core,tui,gui}/...`（自动导入）。
3. `outputs/config-presets/bare.nix`：补 `enable = false;`（preset 显式列出所有开关；server/daily 由 bare 继承）。
4. 目标主机总装单：`myconfigs.mymodules = lib.recursiveUpdate preset.mymodules { server.<name>.enable = true; };`
5. 涉及端口 → 更新 `modules/nixos/server/README.md`；涉及密钥 → §5.6。

---

## 5. 子系统手册

### 5.1 基础系统（`modules/base` + `modules/nixos/base`）

- **用户**：唯一普通用户 `myvars.username`(`ltrump`)，`initialHashedPassword` 来自私密 vars；属于 `wheel/docker/video/input/uinput/networkmanager/...`；**sudo 免密全权限**（`security.sudo.extraRules`）；root 的 authorized_keys 与用户相同（用于 colmena）。
- **ssh**：`services.openssh` 允许 `PermitRootLogin = prohibit-password`；`programs.ssh = myvars.networking.ssh`（把 ltnet 主机的 Host 别名写进系统 ssh_config）。
- **网络**：NetworkManager（桌面/VM 自配）、avahi(mDNS)、阿里/腾讯 NTP、nftables；**`networking.firewall.enable` 默认 `false`（mkDefault）**，只有 5 台公网 VPS 在 `hosts/<host>/modules/core.nix` 里显式改 true。家用机靠路由器 + easytier 内网，服务端口默认只绑 `127.0.0.1` 或 easytier IP。
- **安全**：Canokeys(ccid/udev/pam-u2f)、`security.pki.certificateFiles` 加 ltnet 自签 CA、gnupg agent、fuse/userAllowOther。
- **ttyd**：只监听 `easytier.ltnet`（经 SDWAN 访问的 web 终端）。
- **zram**：zstd、50% 内存，优先于磁盘 swap。
- **virtualization**：`docker`（containerd-snapshotter、autoPrune、开机启动）、`qemu`（qemu_kvm + virt 工具）、`microvm`（host/guest/isInfra，见 §5.3）。
- **core**：grub timeout/`configurationLimit = 10`、power-profiles-daemon、upower、电源键挂起。
- **i18n**：`Asia/Shanghai` + `TZ` 环境变量、`en_GB.UTF-8` 默认。

### 5.2 桌面（`modules/nixos/desktop` + `home/gui`）

| 关注点 | 位置 |
| --- | --- |
| WM | `desktop/wayland.nix`（hyprland/niri/uwsm 系统层）+ `home/gui/wayland/{niri,hyprland,waybar,swaylock}` |
| niri 配置 | `myhome.desktop.niri.settings` → `lib/toKDL.nix` → `~/.config/niri/config.kdl`；内容 `home/gui/wayland/niri/niri-conf.nix`，单机覆盖 `hosts/<host>/home/niri.nix` |
| 音频/硬件 | `desktop/hardware.nix`（pipewire、蓝牙 blueman、打印、fwupd） |
| 字体 | `desktop/fonts.nix`（系统）+ `home/gui/fonts.nix`（用户）；字体文件来自 `myfonts` input |
| 输入法 | `home/gui/fcitx5/`（flypy 小鹤音形） |
| 主题/外观 | `home/gui/appearance/{gtk,dconf,darkman,xsettingsd,cursors,eye-protection}` |
| 终端 | `home/gui/terminal/{kitty,alacritty}`、`home/core/shells/{fish,zellij,starship,...}` |
| 自定义脚本 | `home/gui/scripts/bin/*` 由 `mkScriptsPackage` 打包（改脚本后要 `just switch` 生效） |
| 网盘/代理 | `desktop/network.nix`（clash-verge-rev，tun+serviceMode）、`home/gui/daily/sync.nix`（onedriver） |
| 远程桌面 | `desktop/remote-desktop.nix`（sunshine，`mymodules.desktop.remote-desktop.sunshine.enable`） |
| 校园 VPN | `desktop/vpn/`（strongswan/swanctl + fortivpn，脚本 `scripts/{sjtu-vpn,sjtu-vpn-ipsec,lab-vpn}`，密钥在私密仓库） |
| 开机动画 | `desktop/animeboot/`（GRUB 主题 + plymouth，`mymodules.desktop.animeboot.enable`） |
| 数位板 | `desktop/makima/`（配置在 `environment.etc."makima"`，服务默认 disabled） |
| Windows 应用 | `desktop/fhs.nix`（buildFHSEnv `fhs`）、flatpak/appimage 支持 |
| 会议/聊天 | `home/gui/daily/{wemeet,chats}.nix`（腾讯会议 xwayland+openbox 兼容层） |
| Xorg/i3 | `desktop/i3.nix` + `home/gui/i3/`（历史遗留，`xorg.enable` 默认 false） |

### 5.3 服务端与容器（`modules/nixos/server` + `containers`）

- **端口/服务对照**：`modules/nixos/server/README.md`（改端口要同步更新）。
- **容器服务**（`containers/`）：nezha-server、immich-machine-learning、siyuan-server、cloudreve、rustdesk-api、xpipe-webtop、ncm-api、sub2api；镜像 `image@digest` 来自 `vars/containers.nix`；网络 `oci_net`；数据 `/data/docker/<name>`。
- **原生服务**（`server/`）：caddy(反向代理，密文 Caddyfile 或私密仓库明文二选一)、cf-tunnel、easytier+tailscale(sdwan)、juicefs(+redis meta +S3/webdav 网关)、minio、vaultwarden、rustdesk-server、rustical(caldav)、homepage-dashboard、openlist、syncthing、backrest/duplicati/kopia(备份)、code-server、sshwifty、authentik、hubproxy、novnc-websockify、openclaw(gateway)、openviking-server。
- **microvm**：`server/microvm.nix` 按 `rawcfg.microvm.{host,guest}.enable` 决定 import microvm 模块；宿主机 `virtualization.microvm.host.infras = [ "<guest>" ]` 消费 `microvm-infras.<guest>`；guest 的 `guest.isInfra` 控制走 infra 版（关闭 nixpkgs.config/auto-optimise-store）。**注意 `n100` 当前 host.enable = false，功能保留但未启用。**
- **openviking-server**：`modules/nixos/server/openviking-server/default.nix`，监听 `127.0.0.1:1933`，数据目录 `~/.openviking`，配置来自 `age.secrets.openviking-server-config`。

### 5.4 SDWAN / 网络

- `modules/nixos/server/sdwan.nix` = tailscale + easytier；easytier 实例 `ltnet`（配置可来自密文 `easytier-conf`，或由 `vars/networking.nix` 的 IP + 私密仓库 `easytier/ltnet*.nix` 生成），另有 `web` 控制台实例（rpc 15889）。
- `vars/networking.nix:hostsAddr.easytier` 是**内网 IP 的唯一真源**：派生 `/etc/hosts`（`hostsRecord`，`<host>.ltnet`）和 ssh Host 别名；服务模块用 `myvars.networking.hostsAddr.easytier.${hostName}.ipv4` 绑定监听地址。
- 新机器接入：加 IP → 在私密仓库配 `ltnet-<host>.nix`（或 `.conf.age`）→ 重训 secrets（§5.6）。
- 端口 11010-11020 在启用 easytier 的机器上放行；`easytier.ltnet` 是受信任接口。

### 5.5 Home-Manager 分层

`home/default.nix` → 总是 `options.nix + core/`；`myhome.tuiExtra.enable` → `tui/`；`myhome.desktop.enable` → `gui/`。

- `home/core/`：editors(helix 等)、git、nix-settings（含 nix-index/comma、GC）、packages、security(gpg/scdaemon)、shells(fish + starship + zellij + 各种 CLI)、yazi/nnn/pip。
- `home/tui/`：`mail/`（aerc + offlineimap + imapnotify + notmuch，账号数据来自 `mysecrets/mail/account-data.nix`，密码用 passage）、`editors/{neovim,lsp}`、`dev-tools.nix`、`pi/`（`programs.pi.coding-agent`）、`openclaw/`（见下）。
- `home/gui/`：见 §5.2。

**openclaw（HM 侧）**：`home/tui/openclaw/default.nix` 用 `inputs.nix-openclaw.homeManagerModules.openclaw`，把 `core/secrets/models/agents/ui/tools/channels/gateway/skills/plugins.nix` `mkMerge` 成 `programs.openclaw.config` → 渲染 `~/.openclaw/openclaw.json`；密钥经 `secrets/home/openclaw.nix` 的 `age.secrets.openclaw-secrets`（`mysecrets/openclaw/secrets.json.age`）注入 SecretRef provider。**home 侧是用户级配置；系统侧 `modules/nixos/server/openclaw.nix` 只负责 gateway 服务与 overlay（`mymodules.server.openclaw`）。**

### 5.6 Secrets（agenix）

- 机制：`secrets/modules/default.nix` 引入 `agenix.nixosModules.default`；`secrets/home/default.nix` 引入 HM 版；每个 `secrets/modules/<svc>.nix` 只声明 `age.secrets.<name> = lib.mkIf <条件> { file = "${mysecrets}/<path>.age"; owner/mode; };`
- 解密依赖 host key：`/etc/ssh/ssh_host_ed25519_key`（无 passphrase）；用 impermanence 的机器上从 `/persistent/etc/ssh/` 读（`age.identityPaths`）。
- 解密后的文件由 agenix 在 runtime 放置（默认目录 `/run/agenix`），模块用 `config.age.secrets.<name>.path` 引用。

| 使用者 | `age.secrets` 名 | 密文（`nixos-secrets/` 下） |
| --- | --- | --- |
| easytier | `easytier-conf` / `et-ltnet-env` / `et-ltnet-env-host` | `easytier/ltnet-<host>.conf.age` / `ltnet-env.age` / `ltnet-env-<host>.age` |
| caddy | `caddyfile` | `caddy/caddyfile-<host>.age`（或私密仓库明文同名文件） |
| cloudflared | `cf-tunnel-conf` | `cloudflared/cf-<host>.json.age` |
| minio | `minio-env` / `jfs-s3-env` | `minio/minio-<host>.env.age` / `minio-juicefs.env.age` |
| sub2api | `sub2api-env` | `sub2api/sub2api.env.age` |
| siyuan-server | `siyuan-server-env` | `siyuan-server/siyuan-<host>.env.age` |
| vaultwarden | `vaultwarden-env` | `vaultwarden/vaultwarden.env.age` |
| rustdesk-server | `hbbs-conf` | `rustdesk-server/hbbs-conf.ini.age` |
| rustical | `rustical-env` | `rustical/rustical.env.age` |
| nezha-agent | `nezha-agent-secret` | `nezha/agent-secret.age` |
| kopia | `kopia-env` | `kopia/kopia.env.age` |
| homepage-dashboard | `homepage-dashboard-env` | `homepage-dashboard/secrets.env.age` |
| authentik | `authentik-env` / `authentik-proxy-env` | `authentik/*.env.age` |
| xpipe-webtop | `xpipe-webtop-env` | `xpipe-webtop/secrets.env.age` |
| openviking | `openviking-server-config` | `openviking/ov.conf.age` |
| openclaw (HM) | `openclaw-secrets` | `openclaw/secrets.json.age` |
| VPN (desktop) | `ipsec-conf` / `ipsec-secrets` / `swanctl-conf` / `fortivpnconf` | `vpn/*.age` |

- **私密仓库里同时存在明文文件**（构建期直接 `import`/读取，不经 agenix）：`easytier/ltnet*.nix`、`caddy/caddyfile-<host>`、`websockify/tokens`、`homepage-dashboard/`、`canokey/u2f_keys`、`ssl/ltnet-ca.crt`、`mail/account-data.nix`、`passage/Email`、`vars/*`（含 `initialHashedPassword`）。
- 完整清单：`grep -rn "age.secrets" secrets/` 与 `grep -rn "mysecrets" modules home`。
- **加/改密钥流程**：在 `nixos-secrets/` 编辑 `secrets.nix`（公钥列表）→ `sudo agenix -e ./xxx.age -i /etc/ssh/ssh_host_ed25519_key` → commit（是否 push 见下表）→ 本仓库 `nix flake update mysecrets`（或 `just upp mysecrets`）→ 构建。新主机接入/rekey 见 `secrets/README.md`。
- **改动如何生效**：取决于 `flake.lock` 里 `mysecrets` 的锁定方式，先 `nix flake metadata | grep mysecrets` 确认：

| locked url | 生效条件 |
| --- | --- |
| `ssh://git@github.com/L-Trump/nixos-secrets.git`（flake.nix 声明的规范态） | 本地 clone **commit + push** → `just upp mysecrets` |
| `file:///home/ltrump/nixos-configs/nixos-secrets`（本机开发态 override，见 §5.9） | 本地 clone **commit**（不必 push）→ `nix flake update mysecrets` |

两种模式共同点：**没 commit 的改动都不生效**（input 按 rev 取内容，工作区改动被忽略）。

#### 两个仓库的职责边界

| 改动 | 公开仓库 `nixos-configs` | 私密仓库 `nixos-secrets` |
| --- | --- | --- |
| 服务要新的密码/env | 写 `secrets/modules/<svc>.nix` 声明 `age.secrets`，模块里用 `.path` | 放 `<svc>/*.age`（或明文 env） |
| 新增/修改一个 secret 文件 | 通常不动 | 在 `secrets.nix` 加 `"<path>.age".publicKeys = ...`，再用 agenix 加密 |
| 新机器要能解密 | 总装单 + host key 入仓 | `secrets.nix` 加 host 公钥、归入 `all-hosts`/`admin-hosts`/`server-hosts` 分组，然后 rekey |
| 改敏感值（IP/账号/密码） | 改非敏感部分 | 覆盖在 `nixos-secrets/vars/*`（优先级高于公开 `vars/`） |

#### 私密仓库内部结构

- `secrets.nix` — **只给 agenix CLI 用，不参与构建**。结构：用户公钥（含 offline fallback key）+ `host-<name>` 公钥 → 分组 `all-hosts` / `admin-hosts` / `server-hosts` → 每条 `"<path>.age".publicKeys = users ++ <分组>`。
- 服务目录（`easytier/ caddy/ cloudflared/ minio/ openclaw/ openviking/ rustdesk-server/ siyuan-server/ sub2api/ vaultwarden/ xpipe-webtop/ kopia/ nezha/ rustical/ authentik/ homepage-dashboard/ vpn/ …`）、`passage/Email/`（mail 密码）、`vars/`（覆盖公开 vars）、`canokey/`、`ssl/`、`websockify/`、`hosts/`。
- 本地 `nixos-secrets/` 是**独立的 git 仓库**（有自己的 remote，非 submodule）→ 用 `git -C nixos-secrets ...` 操作，提交/推送单独进行。

#### 常用命令（agenix/age/passage 已在系统包里；`sudo` 是为了读 host key）

```bash
cd nixos-secrets
sudo agenix -e ./<path>.age -i /etc/ssh/ssh_host_ed25519_key   # 新建/编辑
sudo agenix -d ./<path>.age -i /etc/ssh/ssh_host_ed25519_key   # 解密查看
sudo agenix -r -i /etc/ssh/ssh_host_ed25519_key                # 改完 secrets.nix 后批量 rekey（高影响，需用户确认）
# 本机没有 agenix 时：nix shell github:ryantm/agenix#agenix
cd .. && just upp mysecrets                                    # 让本仓库锁定新 rev（需确认）
```

#### 排错

- `no identity matched any of the recipients` → 当前 host key 不在该 secret 的 `publicKeys` 里：把它加进 `secrets.nix` 对应分组并 `agenix -r`。
- impermanence 机器重启后解密失败 → `/persistent/etc/ssh/` 下的 host key 丢了（`age.identityPaths` 指向那里）。
- 改了私密仓库但系统没变化 → 没 push，或没 `just upp mysecrets`；用 `nix flake metadata | grep -A3 mysecrets` 看当前锁定的 rev。

### 5.7 持久化（impermanence）—— 只影响两台笔电

`hosts/{rog-ga502,matebook-gt14}/modules/impermanence.nix`：`environment.persistence."/persistent"`，`/` 每次启动清空。

- 落盘白名单：`/etc/{NetworkManager/system-connections,ssh,nix/inputs,agenix,rancher,asusd,rclone}`、`/var/{log,lib,jfsCache,cache}`、`/data`、`/etc/machine-id`。
- 家目录白名单 `users.ltrump.{directories,files}`：`nixos-configs`、`Codes/Documents/Downloads/...`、`Mail`、`.ssh/.gnupg/.passage`、`.local/{share,state,bin}`、各种 `.config/*`、`.pi/.claude/.agents/.openclaw/...`、工具缓存等。
- **新增的"需要落盘"的状态目录必须登记进白名单**，否则重启即丢（例如新 agent 的 `.foo` 目录、新的应用配置目录）。加目录时注意 `mode`（私钥类 0700）。
- 新装机器若要 impermanence：从这两台拷模板，并把已存在数据先搬到 `/persistent`。

### 5.8 包、overlay 与 nixpkgs 分支

- `packages/*/default.nix` + 在 `packages/default.nix` 注册 → `overlays/packages.nix` 生成 overlay → 所有机器 `pkgs.<name>` 可用，同时 `packages.x86_64-linux.<name>` 可单独 `nix build`。
- 常用 patch 位点也在 `packages/default.nix`（如 `niri` 打 shm patch、`onnxruntime` 取 unstable、`siyuan/mcporter/wiliwili` 等 `# TODO wait upstream merge`）。
- nixpkgs 分支：默认 `nixpkgs`(unstable) → `pkgs`；需要更新的包用 `pkgs-unstable`（unstable-small）；需要稳的/兼容用 `pkgs-stable`（26.05）。
- `vars/nixpkgs-config.nix`：`allowUnfree = true`、`permittedInsecurePackages`（`openclaw-*`、`electron-*`）。新增 insecure 包报错时来这里加。
- substituters 在 `modules/base/nix-settings.nix`（USTC 镜像、nix-community、nixpkgs-update-cache、pi.cachix）与 `modules/nixos/desktop/wayland.nix`（hyprland cachix）。

### 5.9 本地 input override（开发态）

`flake.lock` 里出现 `file:///home/ltrump/...` 的 locked url 时，说明该 input 被指向了本机 clone（`nix flake update <input> --override-input <input> git+file:///path` 产生，`original` 仍是 flake.nix 声明的远端）：

| input | 本机路径（git 分支） | 用途 |
| --- | --- | --- |
| `mysecrets` | `/home/ltrump/nixos-configs/nixos-secrets`（master） | 改密钥/私密配置，见 §5.6 |
| `nix-openclaw` | `/home/ltrump/Codes/nix-openclaw`（custom） | 开发自己的 fork（flake.nix 里声明的是 `github:L-Trump/nix-openclaw`） |

- 生效方式：在本地 clone **commit** → `nix flake update <input>`（不必 push）。
- ⚠️ **这是机器本地状态，不要提交、不要同步到其他机器**（别的机器没有 `/home/ltrump/...`，eval 会直接失败）。要提交 flake.lock 前先问用户。
- 恢复远端源：`nix flake update mysecrets nix-openclaw`。注意 `nix-openclaw` 的本地分支是 `custom`，而 flake.nix 未指定 `ref`（取默认分支）—— 恢复前确认 fork 的默认分支是否已包含本地所做修改。

---

## 6. 任务配方

| 任务 | 步骤 |
| --- | --- |
| **加一个服务开关** | §4.5 五步；容器型参考 §4.3 + 在 `vars/containers.nix` 加镜像 |
| **改某台机器的功能** | 只动 `outputs/x86_64-linux/hosts/<host>.nix` 的 `mymodules`/`myhome`；不要动通用模块 |
| **加新主机** | `hosts/README.md` 全流程；补充：`hosts/<n>/modules/default.nix` 必需、`home/` 可选；`vars/networking.nix` 加 IP；host key 加入 `nixos-secrets/secrets.nix` 并 rekey；总装单 `name` 必须等于 hostname |
| **弃用主机** | 注释总装单 `tags` 里的 `"all"`/`"vps"`（保留文件可单独构建） |
| **加自定义包** | `packages/<name>/default.nix` + 在 `packages/default.nix` 注册；临时包直接 `pkgs.callPackage` |
| **更新容器镜像** | `./scripts/update_containers.sh`（skopeo 写回 digest）→ 对应主机 `just preview` → `just switch`/colmena |
| **升级 flake inputs** | 需要用户确认：`just up`(全部) / `just upp <input>`；先 `just preview` 看 diff |
| **改密钥** | §5.6 流程：在 `nixos-secrets/` 改并 commit（push 与否取决于 §5.9 的锁定模式）→ `nix flake update mysecrets` → 构建 |
| **改 niri/waybar/kitty…** | §5.2 表格定位；niri 改 `niri-conf.nix`（单机改 `hosts/<host>/home/niri.nix`） |
| **加 HM 应用/配置** | 判断层级（core/tui/gui）→ 新建文件即生效 → 需要开关时 §4.5 |
| **改自定义脚本** | `home/gui/scripts/bin/<name>`（或 host 级 `hosts/<host>/home/`），`mkScriptsPackage` 打包 |
| **让新数据重启后还在** | §5.7 白名单登记（仅两台笔电） |

---

## 7. 验证矩阵

```bash
# —— 只读 / 便宜 ——
nix eval .#nixosConfigurations --apply builtins.attrNames --json      # 列出主机（秒级，走 eval 缓存）
nix eval --raw .#nixosConfigurations.<host>.config.networking.hostName # 单独 attr（首次 ~40s）
nix fmt                                                               # 格式化（提交前）
nix build .#nixosConfigurations.<host>.config.system.build.toplevel --dry-run --no-link  # 只 eval+instantiate

# —— 本机构建（不切换）——
just preview            # nixos-rebuild build + nvd diff /run/current-system（分钟级，最常用）
nix build .#iso         # 安装镜像
nix build .#microvm-umy # microvm runner
nix build .#packages.x86_64-linux.<pkg>

# —— 需要用户确认 ——
just switch             # 本机切换（目标 = 当前 hostname）
just col <tag>          # 远程：colmena apply --on '@<tag>'（tag = all/vps/home/<hostname>）
colmena apply --on <host> --verbose
```

- 没有 CI、没有 pre-commit hook、没有测试套件：**验证 = 你自己跑上面的命令**。
- `warning: Git tree '...' is dirty` 是正常的。
- `just test`（`nix eval .#evalTests`）**当前损坏**：`outputs/x86_64-linux/default.nix` 的 `evalTests` 被注释，而 `outputs/default.nix` 仍在读 `it.evalTests`。不要用它当验证。

---

## 8. 陷阱与已知问题

1. **`git add -A` 危险**：`nixos-secrets/`（已 gitignore，安全）、`certs/`（已于本次加入 .gitignore）之外，仍可能有私钥/临时产物。提交前用 `git status` 逐项确认。
2. **`outputs/x86_64-linux/hosts/<file>.nix` 文件名 ≠ hostname**（`laptop-mbgt14.nix` → `matebook-gt14`）；`name` 属性才是真名。
3. **总装单参数不能删**（haumea 惰性 + `mylib.*` 依赖）。
4. **`just test` 已损坏**（见 §7）。
5. **弃用主机靠 tags**，不是删文件。
6. **Justfile 是 fish**：新增 recipe 用 fish 语法（`$argv`、`$"..."`），不要写 `$@`/`${var}`。
7. **`systemConfig` 只在 nixosSystem 路径注入**，`colmenaSystem` 没有；HM 模块里引用它会导致 colmena eval 失败。
8. **firewall 默认关闭**（`lib.mkDefault false`）；新公网服务要么显式 `networking.firewall.allowedTCPPorts`，要么绑 `127.0.0.1`/easytier IP。
9. **impermanence**：只有 `rog-ga502` / `matebook-gt14`；新增状态目录不登记白名单会重启丢失。
10. **`nixos-secrets/` 改了没生效** → 先确认锁定模式（`nix flake metadata | grep mysecrets`）：① `ssh://` 远端态：必须 commit+push+`just upp mysecrets`；② `file://` 本地态：commit 后 `nix flake update mysecrets` 即可（§5.6/§5.9）。两种模式下未 commit 的改动都不生效。
11. **`flake.lock` 里的 `file:///home/ltrump/...`（mysecrets、nix-openclaw）是本地开发态 override**（§5.9），提交或复制到其他机器会直接坏掉。
12. **`n100` 的 microvm host 当前关闭**；`iso`/弃用主机不在 colmena `@all`。
13. **`pkgs-unstable`/`pkgs-stable` 与主 nixpkgs 版本不同**，混用时注意依赖版本冲突（尤其 CUDA/onnxruntime 有专门处理）。
14. 本机 = `rog-ga502`：`just switch` 只影响它；给别的机器"构建"与"部署"是两回事（见 §7）。

---

## 9. 参考

- `README.md` — 组件总览与设计理念
- `hosts/README.md` — 新主机接入步骤
- `outputs/README.md` — flake 输出分层设计
- `secrets/README.md` — agenix 使用、host key 分发、rekey
- `modules/nixos/server/README.md` — 服务端口映射表
