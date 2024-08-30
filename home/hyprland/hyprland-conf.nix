{ pkgs, ... }:

{
  enable = true;
  systemd.variables = [
    "DISPLAY"
    "HYPRLAND_INSTANCE_SIGNATURE"
    "WAYLAND_DISPLAY"
    "XDG_CURRENT_DESKTOP"
    "XDG_SESSION_DESKTOP"
    "XDG_SESSION_TYPE"
    "DESKTOP_SESSION"
  ];
  settings = {
    monitor = [
      "eDP-1,preferred,0x0,auto"
      ",preferred,auto-right,auto"
    ];
    env = [
      "XCURSOR_SIZE,24"
      "HYPRCURSOR_SIZE,24"
      # IME envs
      "XMODIFIERS,@im=fcitx"
      "QT_IM_MODULE,fcitx"
      "QT_IM_MODULES,wayland;fcitx;ibus"
      # GUI Toolkit backend
      "GDK_BACKEND,wayland,x11,*"
      "QT_QPA_PLATFORM,wayland;xcb"
      "QT_AUTO_SCREEN_SCALE_FACTOR,1"
      # Session Type env
      "XDG_SESSION_TYPE,wayland"
      "XDG_CURRENT_DESKTOP,Hyprland"
      "XDG_SESSION_DESKTOP,Hyprland"
      "DESKTOP_SESSION,Hyprland"

      # Locale
      "LANG,en_GB.UTF-8"
      "LANGUAGE,zh_CN.UTF-8"
    ];

    general = {
      gaps_in = 5;
      gaps_out = 15;
      border_size = 2;
      # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
      "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
      "col.inactive_border" = "rgba(595959aa)";
      # Set to true enable resizing windows by clicking and dragging on borders and gaps
      resize_on_border = false;
      # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
      allow_tearing = true;
      layout = "dwindle";
    };

    # https://wiki.hyprland.org/Configuring/Variables/#decoration
    decoration = {
      rounding = 10;
      # Change transparency of focused and unfocused windows
      active_opacity = 1.0;
      inactive_opacity = 0.8;
      drop_shadow = true;
      shadow_range = 4;
      shadow_render_power = 3;
      "col.shadow" = "rgba(1a1a1aee)";
      # https://wiki.hyprland.org/Configuring/Variables/#blur
      blur = {
        enabled = true;
        size = 4;
        passes = 1;
        vibrancy = 0.1696;
      };
    };

    # https://wiki.hyprland.org/Configuring/Variables/#animations
    animations = {
      enabled = true;
      # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
      bezier = "myBezier, 0.54, 0.81, 0.1, 1.10";
      animation = [
        "windows, 1, 3, myBezier, popin 50%"
        "windowsOut, 1, 3, default, popin 80%"
        "layers, 1, 3, default, fade"
        "border, 1, 8, default"
        "borderangle, 1, 8, default"
        "fade, 1, 4, default"
        "workspaces, 1, 3, myBezier, slide"
        "specialWorkspace, 1, 3, myBezier, slidefade 50%"
      ];
    };

    # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
    dwindle = {
      pseudotile = true; # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
      preserve_split = true; # You probably want this
      smart_split = true; # You probably want this
      force_split = 2;
    };

    # https://wiki.hyprland.org/Configuring/Variables/#input
    input = {
      kb_layout = "us";
      numlock_by_default = true;
      follow_mouse = 1;
      sensitivity = -0.3; # -1.0 - 1.0, 0 means no modification.
      touchpad = {
        natural_scroll = true;
        drag_lock = true;
        scroll_factor = 0.7;
      };
    };

    # https://wiki.hyprland.org/Configuring/Variables/#gestures
    gestures = {
      workspace_swipe = true;
    };

    # https://wiki.hyprland.org/Configuring/Variables/#misc
    misc = {
      force_default_wallpaper = -1; # Set to 0 or 1 to disable the anime mascot wallpapers
      disable_hyprland_logo = false; # If true disables the random hyprland logo / anime girl background. :(
      vrr = 2;
      key_press_enables_dpms = true;
      new_window_takes_over_fullscreen = 2;
      animate_manual_resizes = true;
      # enable_swallow = true
      # swallow_regex = ^(Alacritty|kitty|footclient)$
    };

    binds = {
      # workspace_back_and_forth = true
      allow_workspace_cycles = true;
    };
    cursor = {
      # no_warps = true;
      persistent_warps = true;
      warp_on_change_workspace = true;
      inactive_timeout = 30;
      # hide_on_key_press = true
      hide_on_touch = true;
    };
    xwayland = {
      force_zero_scaling = false;
    };

    exec = [
      "pkill nnn-dbus; nnn-dbus"
      "sleep 10 && my-mail-sync"
    ];
    exec-once = [
      "swaylock"
      "lxqt-policykit-agent"
      "nm-applet"
      "fcitx5"
      "waybar"
      "systemctl --user restart hypridle.service"
      "systemctl --user restart hyprpaper.service"
      "copyq --start-server"
      "dex -a -s ~/.config/autostart"
    ];

    "$mainMod" = "SUPER"; # Sets "Windows" key as main modifier
    bind = [
      # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
      "$mainMod SHIFT, Q, killactive,"
      "$mainMod, e, togglesplit, # dwindle"
      "$mainMod, v, layoutmsg, preselect d  # dwindle"
      "$mainMod, semicolon, layoutmsg, preselect r  # dwindle"
      "$mainMod, f, fullscreen, 1"
      "$mainMod SHIFT, f, fullscreen, 0"
      "$mainMod SHIFT, space, togglefloating,"
      "$mainMod, t, tagwindow, notrans"
      "$mainMod SHIFT, t, pin, "
      "$mainMod, g, togglegroup, "
      "$mainMod SHIFT, g, moveoutofgroup, "
      "$mainMod CTRL, l, changegroupactive, f"
      "$mainMod CTRL, h, changegroupactive, b"
      "$mainMod, P, pseudo, # dwindle"
      # Move focus with mainMod + arrow keys
      "$mainMod, h, movefocus, l"
      "$mainMod, l, movefocus, r"
      "$mainMod, k, movefocus, u"
      "$mainMod, j, movefocus, d"
      "$mainMod, left, movefocus, l"
      "$mainMod, right, movefocus, r"
      "$mainMod, up, movefocus, u"
      "$mainMod, down, movefocus, d"
      # Move window
      "$mainMod SHIFT, h, movewindow, l"
      "$mainMod SHIFT, l, movewindow, r"
      "$mainMod SHIFT, k, movewindow, u"
      "$mainMod SHIFT, j, movewindow, d"
      "$mainMod SHIFT, left, movewindow, l"
      "$mainMod SHIFT, right, movewindow, r"
      "$mainMod SHIFT, up, movewindow, u"
      "$mainMod SHIFT, down, movewindow, d"
      "$mainMod SHIFT, c, centerwindow, "
      # Move window
      "$mainMod SHIFT ALT, h, movecurrentworkspacetomonitor, l"
      "$mainMod SHIFT ALT, l, movecurrentworkspacetomonitor, r"
      "$mainMod SHIFT ALT, k, movecurrentworkspacetomonitor, u"
      "$mainMod SHIFT ALT, j, movecurrentworkspacetomonitor, d"
      "$mainMod SHIFT ALT, left, movecurrentworkspacetomonitor, l"
      "$mainMod SHIFT ALT, right, movecurrentworkspacetomonitor, r"
      "$mainMod SHIFT ALT, up, movecurrentworkspacetomonitor, u"
      "$mainMod SHIFT ALT, down, movecurrentworkspacetomonitor, d"
      # Switch workspaces with mainMod + [0-9]
      "$mainMod, 1, workspace, 1"
      "$mainMod, 2, workspace, 2"
      "$mainMod, 3, workspace, 3"
      "$mainMod, 4, workspace, 4"
      "$mainMod, 5, workspace, 5"
      "$mainMod, 6, workspace, 6"
      "$mainMod, 7, workspace, 7"
      "$mainMod, 8, workspace, 8"
      "$mainMod, 9, workspace, 9"
      "$mainMod, 0, workspace, 10"
      "$mainMod, tab, workspace, e+1"
      "$mainMod SHIFT, tab, workspace, e-1"
      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      "$mainMod SHIFT, 1, movetoworkspacesilent, 1"
      "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
      "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
      "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
      "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
      "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
      "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
      "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
      "$mainMod SHIFT, 9, movetoworkspacesilent, 9"
      "$mainMod SHIFT, 0, movetoworkspacesilent, 10"
      # Example special workspace (scratchpad)
      "$mainMod, minus, togglespecialworkspace, magic"
      "$mainMod SHIFT, minus, movetoworkspacesilent, special:magic"
      "$mainMod SHIFT, minus, movetoworkspacesilent, +0"
      # Scroll through existing workspaces with mainMod + scroll
      "$mainMod, mouse_down, workspace, e+1"
      "$mainMod, mouse_up, workspace, e-1"
      # Audio keys
      ", XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%"
      ", XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%"
      ", XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
      ", XF86AudioMicMute, exec, pactl set-source-mute @DEFAULT_SOURCE@ toggle"
      # Audio control
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPause, exec, playerctl pause"
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPrev, exec, playerctl previous"
      # Screen brightness controls
      ", XF86MonBrightnessUp, exec, brightnessctl s 3%+"
      ", XF86MonBrightnessDown, exec, brightnessctl s 3%-"

      # Add gamemode here!!!

      "$mainMod, d, exec, ~/.config/waybar/rofi-menus/launcher.sh"
      "$mainMod, c, exec, ~/.config/waybar/rofi-menus/powermenu.sh"
      "$mainMod, return, exec, alacritty msg create-window || alacritty"
      # ", Print, exec, snipaste snip"
      # "$mainMod SHIFT, s, exec, snipaste snip"
      ", Print, exec, grimblast --notify --cursor copysave area"
      "$mainMod SHIFT, s, exec, grimblast --notify --cursor copysave area"
      "$mainMod, n, exec, alacritty-nnn"
      "$mainMod ALT, v, exec, rofi-rbw"
      "$mainMod SHIFT, v, exec, copyq toggle"
    ];
    bindm = [
      # Move/resize windows with mainMod + LMB/RMB and dragging
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];

    windowrulev2 = [
      "suppressevent maximize, class:.* # You'll probably like this."
      "float, title:^(Authentication Required)$"
      "opacity 1.0 override, tag:notrans"
      # For rofi
      "float, class:^(Rofi)$"
      "center, class:^(Rofi)$"
      "pin, class:^(Rofi)$"
      "stayfocused, class:^(Rofi)$"
      # picker
      "float, class:^(picker|NNN)$"
      "float, class:^(QQ)$"
      # no blur
      "noblur, class:(Alacritty)"
      "float, class:(com.github.hluk.copyq)"
      "size 622 652, class:(com.github.hluk.copyq)"
    ];
  };

  extraConfig = ''
    # Resize submap
    bind = $mainMod, R, submap, resize
    submap = resize
    binde = , l, resizeactive, 10 0
    binde = , h, resizeactive, -10 0
    binde = , j, resizeactive, 0 10
    binde = , k, resizeactive, 0 -10
    binde = , right, resizeactive, 10 0
    binde = , left, resizeactive, -10 0
    binde = , up, resizeactive, 0 10
    binde = , down, resizeactive, 0 -10

    binde = SHIFT, l, resizeactive, 30 0
    binde = SHIFT, h, resizeactive, -30 0
    binde = SHIFT, j, resizeactive, 0 30
    binde = SHIFT, k, resizeactive, 0 -30
    binde = SHIFT, right, resizeactive, 30 0
    binde = SHIFT, left, resizeactive, -30 0
    binde = SHIFT, up, resizeactive, 0 30
    binde = SHIFT, down, resizeactive, 0 -30

    bind = , 2, splitratio, exact 1
    bind = , 2, submap,reset
    bind = , r, splitratio, exact 1
    bind = , r, submap,reset
    bind = , 3, splitratio, exact 0.666
    bind = , 3, submap,reset
    bind = , 4, splitratio, exact 0.5
    bind = , 4, submap,reset
    bind = SHIFT, 3, splitratio, exact 1.333
    bind = SHIFT, 3, submap,reset
    bind = SHIFT, 4, splitratio, exact 1.5
    bind = SHIFT, 4, submap,reset

    bind = $mainMod, R, submap, reset
    bind = , escape, submap, reset
    submap = reset
  '';
}
