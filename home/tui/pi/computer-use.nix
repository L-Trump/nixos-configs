{
  config,
  lib,
  pkgs,
  ...
}:
# @agent-sh/computer-use-linux（pi 的 computer use 扩展）在用户侧需要的东西。
#
# 系统侧的另一半在 modules/nixos/desktop/computer-use.nix：
# services.gnome.at-spi2-core 是 NixOS 选项，Home Manager 设不了，只能分开放；
# 两个文件同名，看到这边就知道那边也有一份，不用满仓库找。
#
# 背景与实测结论见 td-489f42 / td-0953ad。
let
  cfg = config.myhome.tuiExtra.pi;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      glib # doctor 用 gdbus/gsettings 探测 AT-SPI 与 toolkit-accessibility
      wtype # Wayland 虚拟键盘：niri 暴露 zwp_virtual_keyboard_manager_v1，type_text 走它
      ydotool # press_key / 组合键走它（wtype 只负责字面文本），需要下面那个 daemon
      gsettings-desktop-schemas # 下面 dconf 那条要它才能读/写；doctor 的 toolkit-accessibility 探测也靠它
    ];

    # Qt 的无障碍桥默认不挂（实测：带这个变量 → 语义树 169 个节点；不带 → 空），
    # GTK 靠 at-spi2-core 自动挂桥，不需要。
    # 走 systemd.user.sessionVariables 而不是 home.sessionVariables：前者写进
    # ~/.config/environment.d/，由 systemd --user 注入，这样 niri（systemd user
    # service）和它启动的所有 GUI 应用都拿得到；后者只对交互式 shell 生效。
    # 注意：environment.d 只在 user manager 启动时读，所以下次登录才生效。
    systemd.user.sessionVariables.QT_LINUX_ACCESSIBILITY_ALWAYS_ON = "1";

    # Chromium / Electron 系（QQ、Chrome、VSCode…）能不能暴露语义树的总开关：
    # 它们不看 GTK，只盯 session bus 上的 org.a11y.Status.IsEnabled，
    # 而这个属性由 at-spi-bus-launcher 从下面这个 gsettings key 镜像过来。
    # 默认 false ⇒ Electron 应用连 a11y bus 都不连（--force-renderer-accessibility
    # 也救不回来），表现为 `computer-use-linux apps` 里根本没有它。实测：置 true 后
    # QQ 立刻出树（frame/button/check box 带中文名字），不传任何 flag 即可。
    dconf.settings."org/gnome/desktop/interface".toolkit-accessibility = true;

    # home-manager 没有 ydotool 模块（2026-10 查过 6000+ 个模块，无 ydotool/wtype），
    # 只能手写用户级 daemon。socket 固定成 $XDG_RUNTIME_DIR/.ydotool_socket，
    # 正是 computer-use-linux doctor 探测的默认路径，所以不需要再设 YDOTOOL_SOCKET。
    # 前提：当前用户可读写 /dev/uinput（本机已在 uinput 组）。
    systemd.user.services.ydotoold = {
      Unit = {
        Description = "ydotoold - backend for ydotool (computer use 按键注入)";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${lib.getExe' pkgs.ydotool "ydotoold"} --socket-path=%t/.ydotool_socket --socket-perm=0600";
        Restart = "always";
        RestartSec = 2;
      };
      Install.WantedBy = [ "default.target" ];
    };
  };
}
