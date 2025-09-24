let
  mkargs = args: {
    _args = args;
  };
  settings = {
    environment = {
      NIXOS_OZONE_WL = "1";
      XMODIFIERS = "@im=fcitx";
      QT_IM_MODULE = "fcitx";
      QT_IM_MODULES = "wayland;fcitx;ibus";
      # GUI Toolkit backend
      GDK_BACKEND = "wayland,x11,*";
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      # Session Type env
      XDG_SESSION_TYPE = "wayland";
      XDG_CURRENT_DESKTOP = "niri";
      XDG_SESSION_DESKTOP = "niri";
      DESKTOP_SESSION = "niri";
      # Locale
      LANG = "en_GB.UTF-8";
      LANGUAGE = "zh_CN.UTF-8";
      # DISPLAY = ":0";
    };

    input = {
      keyboard = {
        xkb = { };
        numlock = { };
      };
      touchpad = {
        tap = { };
        drag-lock = { };
        natural-scroll = { };
        scroll-factor = 0.7;
        click-method = "clickfinger";
      };
      mouse = { };
      focus-follows-mouse = {
        _props = {
          max-scroll-amount = "10%";
        };
      };
    };

    # output = {
    #   _args = ["eDP-1"];
    #   scale = 2;
    # };

    layout = {
      gaps = 16;
      center-focused-column = "on-overflow";
      always-center-single-column = { };
      preset-column-widths = {
        proportion = [
          (mkargs [ 0.33333 ])
          0.5
          0.66667
        ];
      };
      default-column-width = {
        proportion = 0.5;
      };
      focus-ring = {
        width = 3;
        active-color = "#7fc8ff";
        inactive-color = "#505050";
        urgent-color = "#9b0000";
        active-gradient = {
          _props = {
            from = "#1c71d8";
            to = "#8ff0a4";
            angle = -45;
          };
        };
        inactive-gradient = {
          _props = {
            from = "#505050";
            to = "#808080";
            angle = 45;
            relative-to = "workspace-view";
          };
        };
      };
      border = {
        off = { };
      };
      shadow = {
        softness = 30;
        spread = 5;
        offset = {
          _props = {
            x = 0;
            y = 5;
          };
        };
        color = "#0007";
      };
      struts = {
        left = 20;
        right = 20;
      };
    };
    spawn-at-startup = [
      [
        "fish"
        "-c"
        "xrdb -merge ~/.Xresources"
      ]
      [ "swaylock" ]
      [
        "systemctl"
        "--user"
        "restart"
        "waybar.service"
      ]
      [ "lxqt-policykit-agent" ]
      [ "nm-applet" ]
      [
        "systemctl"
        "--user"
        "restart"
        "fcitx5-daemon.service"
      ]
      [
        "systemctl"
        "--user"
        "restart"
        "hyprpaper.service"
      ]
      [
        "systemctl"
        "--user"
        "restart"
        "hypridle.service"
      ]
      [
        "copyq"
        "--start-server"
      ]
      [
        "fish"
        "-c"
        "sleep 3; dex -a -s ~/.config/autostart"
      ]
      # ["fish" "-c" "xwayland-satellite :0"]
      [
        "fish"
        "-c"
        "pkill nnn-dbus; nnn-dbus"
      ]
      [
        "fish"
        "-c"
        "sleep 10 && my-mail-sync"
      ]
      [
        "systemctl"
        "--user"
        "restart"
        "xdg-desktop-portal.service"
      ]
      # ["fish" "-c" "uwsm finalize"]
    ];
    prefer-no-csd = { };
    screenshot-path = "~/Pictures/Screenshots/Niri_%Y-%m-%d_%H-%M-%S.png";
    animations = {
      slowdown = 0.9;
    };
    hotkey-overlay = {
      skip-at-startup = { };
    };
    window-rule = [
      {
        geometry-corner-radius = 10;
        clip-to-geometry = true;
      }
      {
        match = [
          {
            _props = {
              app-id = "firefox$";
              title = "^Picture-in-Picture$";
            };
          }
          {
            _props = {
              app-id = "^Rofi|QQ|wechat$";
            };
          }
          {
            _props = {
              app-id = "^Zotero$";
              title = "^Progress|进度$";
            };
          }
          {
            _props = {
              title = "^Authentication Required$";
            };
          }
          {
            _props = {
              app-id = "^wps|wpp|et$";
              title = "^wps|wpp|et$";
            };
          }
        ];
        open-floating = true;
      }
      {
        match = {
          _props = {
            app-id = "^picker|NNN$";
          };
        };
        open-floating = true;
        default-column-width.fixed = 715;
        default-window-height.fixed = 520;
      }
      {
        match = {
          _props = {
            app-id = "^com.github.hluk.copyq$";
          };
        };
        open-floating = true;
        default-column-width.fixed = 622;
        default-window-height.fixed = 652;
      }
    ];
    binds = {
      # shows a list of important hotkeys.
      "Mod+Shift+Slash" = {
        show-hotkey-overlay = { };
      };
      # Suggested binds for running programs: terminal, app launcher, screen locker.
      "Mod+Return" = {
        _props = {
          hotkey-overlay-title = "Open a Terminal: kitty";
        };
        spawn = [
          "kitty"
          "-1"
        ];
      };
      "Mod+Shift+Return" = {
        spawn = [
          "kitty"
          "-e"
          "fish"
          "-ilc"
          "zj"
        ];
      };
      # Mod+D hotkey-overlay-title="Run an Application: fuzzel" { spawn "fuzzel"; }
      "Mod+D" = {
        _props = {
          hotkey-overlay-title = "Run an Application: rofi";
        };
        spawn = "~/.config/waybar/rofi-menus/launcher.sh";
      };
      "Mod+E" = {
        _props = {
          hotkey-overlay-title = "Power Menu";
        };
        spawn = "~/.config/waybar/rofi-menus/powermenu.sh";
      };
      "Super+Alt+L" = {
        _props = {
          hotkey-overlay-title = "Lock the Screen: swaylock";
        };
        spawn = "swaylock";
      };

      "Mod+Shift+S" = {
        screenshot = { };
      };
      "Print" = {
        screenshot = { };
      };
      "Ctrl+Print" = {
        screenshot-screen = { };
      };
      "Alt+Print" = {
        screenshot-window = { };
      };

      "Mod+N" = {
        spawn = [ "term-nnn" ];
      };
      "Mod+Alt+V" = {
        spawn = [ "rofi-rbw" ];
      };
      "Mod+Shift+V" = {
        spawn = [
          "copyq"
          "toggle"
        ];
      };
      "Mod+P" = {
        spawn = [
          "fish"
          "-c"
          "wl-paste | swappy -f -"
        ];
      };
      "Mod+B" = {
        spawn = [
          "fish"
          "-c"
          "animebg"
        ];
      };
      "Mod+Shift+B" = {
        spawn = [
          "fish"
          "-c"
          "animebg stop"
        ];
      };

      # Example volume keys mappings for PipeWire & WirePlumber.
      # The allow-when-locked=true property makes them work even when the session is locked.
      "XF86AudioRaiseVolume" = {
        _props = {
          allow-when-locked = true;
        };
        spawn = [
          "wpctl"
          "set-volume"
          "@DEFAULT_AUDIO_SINK@"
          "0.05+"
        ];
      };
      "XF86AudioLowerVolume" = {
        _props = {
          allow-when-locked = true;
        };
        spawn = [
          "wpctl"
          "set-volume"
          "@DEFAULT_AUDIO_SINK@"
          "0.05-"
        ];
      };
      "XF86AudioMute" = {
        _props = {
          allow-when-locked = true;
        };
        spawn = [
          "wpctl"
          "set-mute"
          "@DEFAULT_AUDIO_SINK@"
          "toggle"
        ];
      };
      "XF86AudioMicMute" = {
        _props = {
          allow-when-locked = true;
        };
        spawn = [
          "wpctl"
          "set-mute"
          "@DEFAULT_AUDIO_SOURCE@"
          "toggle"
        ];
      };
      # Audio keys
      "XF86AudioPlay" = {
        spawn = [
          "playerctl"
          "play-pause"
        ];
      };
      "XF86AudioPause" = {
        spawn = [
          "playerctl"
          "pause"
        ];
      };
      "XF86AudioNext" = {
        spawn = [
          "playerctl"
          "next"
        ];
      };
      "XF86AudioPrev" = {
        spawn = [
          "playerctl"
          "previous"
        ];
      };
      "XF86MonBrightnessUp" = {
        spawn = [
          "brightnessctl"
          "s"
          "3%+"
        ];
      };
      "XF86MonBrightnessDown" = {
        spawn = [
          "brightnessctl"
          "s"
          "3%-"
        ];
      };

      # Open/close the Overview: a zoomed-out view of workspaces and windows.
      # You can also move the mouse into the top-left hot corner,
      # or do a four-finger swipe up on a touchpad.
      "Mod+grave" = {
        _props = {
          repeat = false;
        };
        toggle-overview = { };
      };

      "Mod+Shift+Q" = {
        close-window = { };
      };

      "Mod+Left" = {
        focus-column-left = { };
      };
      "Mod+Down" = {
        focus-window-down = { };
      };
      "Mod+Up" = {
        focus-window-up = { };
      };
      "Mod+Right" = {
        focus-column-right = { };
      };
      "Mod+H" = {
        focus-column-left = { };
      };
      "Mod+J" = {
        focus-window-down = { };
      };
      "Mod+K" = {
        focus-window-up = { };
      };
      "Mod+L" = {
        focus-column-right = { };
      };

      "Mod+Shift+Left" = {
        move-column-left = { };
      };
      "Mod+Shift+Down" = {
        move-window-down = { };
      };
      "Mod+Shift+Up" = {
        move-window-up = { };
      };
      "Mod+Shift+Right" = {
        move-column-right = { };
      };
      "Mod+Shift+H" = {
        move-column-left = { };
      };
      "Mod+Shift+J" = {
        move-window-down = { };
      };
      "Mod+Shift+K" = {
        move-window-up = { };
      };
      "Mod+Shift+L" = {
        move-column-right = { };
      };

      "Mod+Home" = {
        focus-column-first = { };
      };
      "Mod+End" = {
        focus-column-last = { };
      };
      "Mod+Shift+Home" = {
        move-column-to-first = { };
      };
      "Mod+Shift+End" = {
        move-column-to-last = { };
      };

      "Mod+Ctrl+Left" = {
        focus-monitor-left = { };
      };
      "Mod+Ctrl+Down" = {
        focus-monitor-down = { };
      };
      "Mod+Ctrl+Up" = {
        focus-monitor-up = { };
      };
      "Mod+Ctrl+Right" = {
        focus-monitor-right = { };
      };
      "Mod+Ctrl+H" = {
        focus-monitor-left = { };
      };
      "Mod+Ctrl+J" = {
        focus-monitor-down = { };
      };
      "Mod+Ctrl+K" = {
        focus-monitor-up = { };
      };
      "Mod+Ctrl+L" = {
        focus-monitor-right = { };
      };

      "Mod+Shift+Ctrl+Left" = {
        move-column-to-monitor-left = { };
      };
      "Mod+Shift+Ctrl+Down" = {
        move-column-to-monitor-down = { };
      };
      "Mod+Shift+Ctrl+Up" = {
        move-column-to-monitor-up = { };
      };
      "Mod+Shift+Ctrl+Right" = {
        move-column-to-monitor-right = { };
      };
      "Mod+Shift+Ctrl+H" = {
        move-column-to-monitor-left = { };
      };
      "Mod+Shift+Ctrl+J" = {
        move-column-to-monitor-down = { };
      };
      "Mod+Shift+Ctrl+K" = {
        move-column-to-monitor-up = { };
      };
      "Mod+Shift+Ctrl+L" = {
        move-column-to-monitor-right = { };
      };

      "Mod+Page_Down" = {
        focus-workspace-down = { };
      };
      "Mod+Page_Up" = {
        focus-workspace-up = { };
      };
      "Mod+U" = {
        focus-workspace-down = { };
      };
      "Mod+I" = {
        focus-workspace-up = { };
      };
      "Mod+Shift+Page_Down" = {
        move-column-to-workspace-down = { };
      };
      "Mod+Shift+Page_Up" = {
        move-column-to-workspace-up = { };
      };
      "Mod+Shift+U" = {
        move-column-to-workspace-down = { };
      };
      "Mod+Shift+I" = {
        move-column-to-workspace-up = { };
      };
      "Mod+Shift+O" = {
        move-column-to-monitor-right = { };
      };
      "Mod+Shift+Y" = {
        move-column-to-monitor-left = { };
      };

      "Mod+Ctrl+Page_Down" = {
        move-workspace-down = { };
      };
      "Mod+Ctrl+Page_Up" = {
        move-workspace-up = { };
      };
      "Mod+Ctrl+U" = {
        move-workspace-down = { };
      };
      "Mod+Ctrl+I" = {
        move-workspace-up = { };
      };
      "Mod+Shift+Ctrl+U" = {
        move-workspace-down = { };
      };
      "Mod+Shift+Ctrl+I" = {
        move-workspace-up = { };
      };
      "Mod+Shift+Ctrl+O" = {
        move-workspace-to-monitor-right = { };
      };
      "Mod+Shift+Ctrl+Y" = {
        move-workspace-to-monitor-left = { };
      };

      "Mod+WheelScrollDown" = {
        _props = {
          cooldown-ms = 150;
        };
        focus-workspace-down = { };
      };
      "Mod+WheelScrollUp" = {
        _props = {
          cooldown-ms = 150;
        };
        focus-workspace-up = { };
      };
      "Mod+Ctrl+WheelScrollDown" = {
        _props = {
          cooldown-ms = 150;
        };
        move-column-to-workspace-down = { };
      };
      "Mod+Ctrl+WheelScrollUp" = {
        _props = {
          cooldown-ms = 150;
        };
        move-column-to-workspace-up = { };
      };

      "Mod+WheelScrollRight" = {
        focus-column-right = { };
      };
      "Mod+WheelScrollLeft" = {
        focus-column-left = { };
      };
      "Mod+Ctrl+WheelScrollRight" = {
        move-column-right = { };
      };
      "Mod+Ctrl+WheelScrollLeft" = {
        move-column-left = { };
      };

      "Mod+Shift+WheelScrollDown" = {
        focus-column-right = { };
      };
      "Mod+Shift+WheelScrollUp" = {
        focus-column-left = { };
      };
      "Mod+Ctrl+Shift+WheelScrollDown" = {
        move-column-right = { };
      };
      "Mod+Ctrl+Shift+WheelScrollUp" = {
        move-column-left = { };
      };

      "Mod+1" = {
        focus-workspace = 1;
      };
      "Mod+2" = {
        focus-workspace = 2;
      };
      "Mod+3" = {
        focus-workspace = 3;
      };
      "Mod+4" = {
        focus-workspace = 4;
      };
      "Mod+5" = {
        focus-workspace = 5;
      };
      "Mod+6" = {
        focus-workspace = 6;
      };
      "Mod+7" = {
        focus-workspace = 7;
      };
      "Mod+8" = {
        focus-workspace = 8;
      };
      "Mod+9" = {
        focus-workspace = 9;
      };
      "Mod+Shift+1" = {
        move-column-to-workspace = 1;
      };
      "Mod+Shift+2" = {
        move-column-to-workspace = 2;
      };
      "Mod+Shift+3" = {
        move-column-to-workspace = 3;
      };
      "Mod+Shift+4" = {
        move-column-to-workspace = 4;
      };
      "Mod+Shift+5" = {
        move-column-to-workspace = 5;
      };
      "Mod+Shift+6" = {
        move-column-to-workspace = 6;
      };
      "Mod+Shift+7" = {
        move-column-to-workspace = 7;
      };
      "Mod+Shift+8" = {
        move-column-to-workspace = 8;
      };
      "Mod+Shift+9" = {
        move-column-to-workspace = 9;
      };

      # The following binds move the focused window in and out of a column.
      # If the window is alone, they will consume it into the nearby column to the side.
      # If the window is already in a column, they will expel it out.
      "Mod+BracketLeft" = {
        consume-or-expel-window-left = { };
      };
      "Mod+BracketRight" = {
        consume-or-expel-window-right = { };
      };

      # Consume one window from the right to the bottom of the focused column.
      "Mod+Comma" = {
        consume-window-into-column = { };
      };
      # Expel the bottom window from the focused column to the right.
      "Mod+Period" = {
        expel-window-from-column = { };
      };

      "Mod+R" = {
        switch-preset-column-width = { };
      };
      "Mod+Shift+R" = {
        switch-preset-window-height = { };
      };
      "Mod+Ctrl+R" = {
        reset-window-height = { };
      };
      "Mod+F" = {
        maximize-column = { };
      };
      "Mod+Shift+F" = {
        fullscreen-window = { };
      };
      "Mod+Ctrl+Shift+F" = {
        toggle-windowed-fullscreen = { };
      };

      # Expand the focused column to space not taken up by other fully visible columns.
      # Makes the column "fill the rest of the space".
      "Mod+Ctrl+F" = {
        expand-column-to-available-width = { };
      };

      "Mod+C" = {
        center-column = { };
      };

      # Center all fully visible columns on screen.
      "Mod+Ctrl+C" = {
        center-visible-columns = { };
      };

      # Finer width adjustments.
      # This command can also:
      # * set width in pixels: "1000"
      # * adjust width in pixels: "-5" or "+5"
      # * set width as a percentage of screen width: "25%"
      # * adjust width as a percentage of screen width: "-10%" or "+10%"
      # Pixel sizes use logical, or scaled, pixels. I.e. on an output with scale 2.0,
      # set-column-width "100" will make the column occupy 200 physical screen pixels.
      "Mod+Minus" = {
        set-column-width = "-10%";
      };
      "Mod+Equal" = {
        set-column-width = "+10%";
      };
      # Finer height adjustments when in column with other windows.
      "Mod+Shift+Minus" = {
        set-window-height = "-10%";
      };
      "Mod+Shift+Equal" = {
        set-window-height = "+10%";
      };
      # Move the focused window between the floating and the tiling layout.
      "Mod+Shift+Space" = {
        toggle-window-floating = { };
      };
      "Mod+Space" = {
        switch-focus-between-floating-and-tiling = { };
      };
      # Toggle tabbed column display mode.
      "Mod+W" = {
        toggle-column-tabbed-display = { };
      };

      "Mod+Escape" = {
        _props = {
          allow-inhibiting = false;
        };
        toggle-keyboard-shortcuts-inhibit = { };
      };

      # The quit action will show a confirmation dialog to avoid accidental exits.
      "Mod+Shift+E" = {
        quit = { };
      };
      # Ctrl+Alt+Delete { quit; }

      # Powers off the monitors. To turn them back on, do any input like
      # moving the mouse or pressing any other key.
      "Mod+Shift+P" = {
        power-off-monitors = { };
      };
    };
  };
in
settings
