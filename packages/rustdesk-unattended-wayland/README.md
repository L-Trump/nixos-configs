# rustdesk-unattended-wayland

RustDesk 官方 “unattended Wayland” 构建的 deb 重打包，**不编译**。
来源 `rustdesk-unattended-wayland-1.5.3-x86_64.deb`，sha256 `708f390c46c3…33e0d`。

上游 `build.py --drm` 打开两个 feature：`drm`（抓屏走 kernel DRM/KMS，deb 自带
`libdrmtap.so.0.5.12`，不经过 portal）+ `drm-wake`（屏幕休眠时由 root 服务注入指针
事件唤醒）→ 无授权弹窗、能抓登录界面。

## 坑

- `librustdesk.so` 里写死 `/usr/lib/rustdesk/libdrmtap.so.0`。模块
  `mymodules.desktop.remote-desktop.rustdesk` 用 tmpfiles 铺目录并软链到
  `pkgs.libdrmtap`，别在这里重复。
- 可执行文件是 `share/rustdesk/rustdesk`，`bin/rustdesk` 只是 wrapper；别改名或
  挪位置（`--service` 靠 `ps` 认自己的 per-session server）。
- 服务里 `PATH` 要带 `procps`，否则退回 RemoteDesktop portal（niri 的
  portal-gnome 没有该接口）。
- 用 RUNPATH，别用 `LD_LIBRARY_PATH`：`--service` 经 sudo 起会话 server，`LD_*` 会丢。
- GStreamer 插件路径见 `passthru.gstPluginPath`（wrapper 已设
  `GST_PLUGIN_SYSTEM_PATH_1_0`）；服务直接跑二进制时要在 unit 里再设一次。

## 用法

```nix
mymodules.desktop.remote-desktop.rustdesk.enable = true;   # daily preset 已开
```

## 升级

改 `version`，再 `nix store prefetch-file --json <deb url>` 换 `hash`。deb 布局
1.5.0 → 1.5.3 未变，`postFixup` 里 libdrmtap 用 `0.*` 通配。
