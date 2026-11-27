{
  lib,
  ...
}:
{
  # config version is required for future config migration
  "configVersion" = 47;
  "dockConfigs" = [
    {
      "id" = "dock";
      "name" = "Dock";
      "enabled" = false;
    }
  ];
  "dmsWindowsFloatingSeeded" = [ "niri" ];
  "currentThemeName" = "dynamic";
  "barConfigs" = [
    {
      "id" = "default";
      "name" = "Main Bar";
      "enabled" = true;
      "position" = 0;
      "screenPreferences" = [ "all" ];
      "showOnLastDisplay" = false;
      "leftWidgets" = [
        "launcherButton"
        {
          "id" = "workspaceSwitcher";
          "enabled" = true;
          "showSpecialWorkspaces" = false;
          "workspaceIndicatorStyle" = "pills";
          "showWorkspaceIndex" = false;
          "showWorkspacePadding" = false;
          "showOccupiedWorkspacesOnly" = false;
          "showWorkspaceApps" = false;
          "showWorkspaceName" = false;
          "workspaceIndicatorRoundness" = -1;
          "workspaceIndicatorCompact" = false;
        }
        {
          "id" = "intervalCommand:variant_1795622036430";
          "enabled" = true;
        }
        {
          "id" = "focusedWindow";
          "enabled" = true;
          "overflowPriority" = 0;
          "focusedWindowShowAppName" = true;
        }
      ];
      "centerWidgets" = [
        "music"
        "clock"
        "weather"
      ];
      "rightWidgets" = [
        {
          "id" = "systemTray";
          "enabled" = true;
        }
        {
          "id" = "clipboard";
          "enabled" = false;
        }
        "cpuUsage"
        "memUsage"
        {
          "id" = "notificationButton";
          "enabled" = false;
        }
        "battery"
        "controlCenterButton"
        {
          "id" = "network_speed_monitor";
          "enabled" = false;
          "compactMode" = false;
          "hideWhenIdle" = false;
          "overflowMode" = "section";
        }
      ];
      "spacing" = 4;
      "innerPadding" = 2;
      "barInsetPadding" = -1;
      "barLengthPadding" = 0;
      "barLengthMode" = "full";
      "barLengthPercent" = 80;
      "bottomGap" = 0;
      "attachToScreenEdge" = false;
      "followInterfaceStyle" = false;
      "transparency" = 0.65;
      "surfaceColor" = "default";
      "widgetFollowInterfaceStyle" = true;
      "widgetTransparency" = 1;
      "squareCorners" = false;
      "noBackground" = false;
      "widgetStyle" = "pills";
      "maximizeWidgetIcons" = false;
      "maximizeWidgetText" = false;
      "widgetPadding" = 8;
      "batteryColorMode" = "theme";
      "gothCornersEnabled" = false;
      "gothCornerRadiusOverride" = false;
      "gothCornerRadiusValue" = 12;
      "borderEnabled" = false;
      "borderColor" = "surfaceText";
      "borderOpacity" = 1;
      "borderThickness" = 1;
      "widgetOutlineEnabled" = false;
      "widgetOutlineColor" = "primary";
      "widgetOutlineOpacity" = 1;
      "widgetOutlineThickness" = 1;
      "fontScale" = 1;
      "iconScale" = 1;
      "autoHide" = false;
      "autoHideStrict" = false;
      "autoHideDelay" = 250;
      "showOnWindowsOpen" = false;
      "openOnOverview" = false;
      "visible" = true;
      "popupGapsAuto" = true;
      "popupGapsManual" = 4;
      "maximizeDetection" = true;
      "useOverlayLayer" = false;
      "hideOnFullscreen" = true;
      "scrollEnabled" = true;
      "scrollXBehavior" = "focusWindow";
      "scrollYBehavior" = "workspace";
      "middleClickAction" = "none";
      "rightClickAction" = "none";
      "clickActionFollowMouse" = false;
      "shadowIntensity" = 0;
      "shadowOpacity" = 60;
      "shadowColorMode" = "default";
      "shadowCustomColor" = "#000000";
      "shadowDirectionMode" = "inherit";
      "shadowDirection" = "top";
      "clickThrough" = false;
      "hoverPopouts" = false;
      "hoverPopoutDelay" = 150;
      "dot" = false;
      "island" = true;
      "islandNotch" = false;
      "islandFloating" = false;
      "islandPlacement" = "free";
      "islandRouteLauncher" = "follow";
      "islandRoutePowerMenu" = "follow";
      "islandSystemOsd" = true;
      "islandRouteControlCenter" = "follow";
      "islandInteractionMode" = "hybrid";
      "islandRouteNotificationCenter" = "follow";
      "islandDashTabs" = true;
      "islandMediaClockVisible" = true;
      "islandMediaLyrics" = true;
      "islandNotificationPopups" = true;
      "islandRouteClipboard" = "follow";
      "islandHighContrast" = false;
      "islandPalette" = "default";
      "islandHomeClockDisplay" = "both";
      "islandHomeCompactTight" = false;
      "islandCompactThickness" = 35;
      "islandSatellitesEnabled" = true;
      "islandSatellitePosition" = "edges";
      "islandSatelliteBackground" = false;
      "islandHomeLayout" = [
        {
          "id" = "workspaces";
          "enabled" = false;
        }
        {
          "id" = "media";
          "enabled" = true;
        }
        {
          "id" = "clock";
          "enabled" = true;
        }
        {
          "id" = "weather";
          "enabled" = false;
        }
        {
          "id" = "status";
          "enabled" = false;
        }
        {
          "id" = "volume";
          "enabled" = false;
        }
        {
          "id" = "brightness";
          "enabled" = false;
        }
        {
          "id" = "notifications";
          "enabled" = true;
        }
        {
          "id" = "privacy";
          "enabled" = true;
        }
        {
          "id" = "keyboardLayout";
          "enabled" = false;
        }
        {
          "id" = "tray";
          "enabled" = false;
        }
      ];
      "hideOnLastDisplay" = false;
      "islandRouteDash" = "island";
      "islandRouteMedia" = "island";
      "islandRouteWeather" = "island";
      "islandRouteWallpaper" = "island";
      "islandUseOverlayLayer" = true;
      "islandMediaAutoSwitch" = true;
    }
  ];
  "currentThemeCategory" = "dynamic";
  "appDrawerSectionViewModes" = {
    "apps" = "list";
  };
  "builtInPluginSettings" = {
    "dms_qr_generator" = {
      "trigger" = "qrg";
    };
    "dms_power" = {
      "trigger" = "pw";
    };
    "dms_clipboard_search" = {
      "trigger" = "cb";
    };
    "dms_settings_search" = {
      "trigger" = "?";
    };
  };
  "popupTransparency" = 0.75;
  "foregroundLayerTransparency" = 0.65;
  "blurLayerOutlineOpacity" = 0.1;
  "blurBorderEnabled" = true;
  "blurBorderSeeded" = true;
  "radiusStrength" = 40;
  "dashOptions" = {
    "clock" = {
      "seconds" = true;
    };
  };
  "acMonitorTimeout" = 1200;
  "acLockTimeout" = 600;
  "batteryMonitorTimeout" = 1200;
  "batteryLockTimeout" = 600;
  "lockBeforeSuspend" = true;
  "lockScreenWidgetInstances" = [
    {
      "id" = "lock_clock";
      "widgetType" = "desktopClock";
      "enabled" = true;
      "config" = {
        "displayPreferences" = [ "all" ];
        "syncPositionAcrossScreens" = true;
        "style" = "expressive";
        "transparency" = 0;
        "weight" = 0;
        "twoTone" = true;
        "showDate" = true;
        "showDigitalSeconds" = false;
        "showAnalogNumbers" = false;
        "showAnalogSeconds" = true;
        "autoPosition" = false;
        "colorMode" = "default";
        "customColor" = "#ffffff";
      };
    }
    {
      "id" = "lock_date";
      "widgetType" = "lockDate";
      "enabled" = false;
      "config" = {
        "displayPreferences" = [ "all" ];
        "syncPositionAcrossScreens" = true;
        "format" = "short";
        "colorMode" = "default";
        "customColor" = "#ffffff";
      };
    }
    {
      "id" = "lock_auth";
      "widgetType" = "lockAuth";
      "enabled" = true;
      "config" = {
        "displayPreferences" = [ "all" ];
        "syncPositionAcrossScreens" = true;
        "style" = "ring";
        "profileVisibility" = "typing";
        "passwordVisibility" = "typing";
      };
    }
    {
      "id" = "lock_notifications";
      "widgetType" = "lockNotifications";
      "enabled" = false;
      "config" = {
        "displayPreferences" = [ "all" ];
        "syncPositionAcrossScreens" = true;
        "mode" = 2;
      };
    }
    {
      "id" = "lock_status";
      "widgetType" = "lockStatus";
      "enabled" = true;
      "config" = {
        "displayPreferences" = [ "all" ];
        "syncPositionAcrossScreens" = true;
        "showMediaPlayer" = true;
        "showWeather" = true;
        "background" = false;
      };
    }
    {
      "id" = "lock_power";
      "widgetType" = "lockPower";
      "enabled" = false;
      "config" = {
        "displayPreferences" = [ "all" ];
        "syncPositionAcrossScreens" = true;
        "shape" = "round";
      };
    }
  ];
  "greeterWidgetInstances" = [
    {
      "id" = "lock_clock";
      "widgetType" = "desktopClock";
      "enabled" = true;
      "config" = {
        "displayPreferences" = [ "all" ];
        "syncPositionAcrossScreens" = true;
        "style" = "expressive";
        "transparency" = 0;
        "weight" = 0;
        "twoTone" = true;
        "showDate" = true;
        "showDigitalSeconds" = false;
        "showAnalogNumbers" = false;
        "showAnalogSeconds" = true;
        "autoPosition" = false;
        "colorMode" = "default";
        "customColor" = "#ffffff";
      };
    }
    {
      "id" = "lock_date";
      "widgetType" = "lockDate";
      "enabled" = false;
      "config" = {
        "displayPreferences" = [ "all" ];
        "syncPositionAcrossScreens" = true;
        "format" = "short";
        "colorMode" = "default";
        "customColor" = "#ffffff";
      };
    }
    {
      "id" = "lock_auth";
      "widgetType" = "lockAuth";
      "enabled" = true;
      "config" = {
        "displayPreferences" = [ "all" ];
        "syncPositionAcrossScreens" = true;
        "style" = "ring";
        "profileVisibility" = "typing";
        "passwordVisibility" = "typing";
      };
    }
    {
      "id" = "lock_status";
      "widgetType" = "lockStatus";
      "enabled" = true;
      "config" = {
        "displayPreferences" = [ "all" ];
        "syncPositionAcrossScreens" = true;
        "showMediaPlayer" = true;
        "showWeather" = true;
        "background" = false;
      };
    }
    {
      "id" = "lock_power";
      "widgetType" = "lockPower";
      "enabled" = false;
      "config" = {
        "displayPreferences" = [ "all" ];
        "syncPositionAcrossScreens" = true;
        "shape" = "round";
      };
    }
    {
      "id" = "greeter_session";
      "widgetType" = "greeterSession";
      "enabled" = true;
      "config" = {
        "displayPreferences" = [ "all" ];
        "syncPositionAcrossScreens" = true;
      };
    }
  ];
  "lockPamExternallyManaged" = true;
  "enableU2f" = true;
  "lockPamPath" = "/etc/pam.d/swaylock";
  "lockPamInlineU2f" = true;
  "dashTabs" = [
    {
      "id" = "overview";
      "enabled" = true;
    }
    {
      "id" = "media";
      "enabled" = true;
    }
    {
      "id" = "wallpaper";
      "enabled" = true;
    }
    {
      "id" = "weather";
      "enabled" = true;
    }
    {
      "id" = "wellbeing";
      "enabled" = true;
    }
    {
      "id" = "notifications";
      "enabled" = false;
    }
    {
      "id" = "settings";
      "enabled" = false;
    }
  ];
  "powerMenuDefaultAction" = "lock";
  "motionDuration" = 0;
  "customPowerButtons" = [
    {
      "icon" = "desktop_windows";
      "label" = "关闭显示器";
      "command" = "dms ipc call lock lockAndOutputsOff";
      "key" = "D";
      "noConfirm" = true;
    }
  ];
  "powerMenuActions" = [
    "reboot"
    "logout"
    "poweroff"
    "lock"
    "suspend"
  ];
  "osdKeyboardLayoutEnabled" = true;
  "controlCenterWidgets" = [
    {
      "id" = "user";
      "enabled" = true;
      "w" = 4;
      "h" = 1;
    }
    {
      "id" = "settings";
      "enabled" = true;
      "w" = 1;
      "h" = 1;
      "small" = true;
    }
    {
      "id" = "lock";
      "enabled" = true;
      "w" = 1;
      "h" = 1;
      "small" = true;
    }
    {
      "id" = "power";
      "enabled" = true;
      "w" = 1;
      "h" = 1;
      "small" = true;
    }
    {
      "id" = "brightnessSlider";
      "enabled" = true;
      "w" = 3.5;
      "h" = 1;
      "small" = true;
      "deviceName" = "backlight:amdgpu_bl2";
    }
    {
      "id" = "volumeSlider";
      "enabled" = true;
      "w" = 3.5;
      "h" = 1;
      "small" = true;
    }
    {
      "id" = "wifi";
      "enabled" = true;
      "w" = 3.5;
      "h" = 1;
    }
    {
      "id" = "bluetooth";
      "enabled" = true;
      "w" = 3.5;
      "h" = 1;
    }
    {
      "id" = "audioOutput";
      "enabled" = true;
      "w" = 3.5;
      "h" = 1;
    }
    {
      "id" = "audioInput";
      "enabled" = true;
      "w" = 3.5;
      "h" = 1;
    }
    {
      "id" = "airplaneMode";
      "enabled" = true;
      "w" = 3.5;
      "h" = 1;
    }
    {
      "id" = "diskUsage";
      "enabled" = true;
      "w" = 3.5;
      "h" = 1;
    }
    {
      "id" = "doNotDisturb";
      "enabled" = true;
      "w" = 3.5;
      "h" = 1;
    }
    {
      "id" = "idleInhibitor";
      "enabled" = true;
      "w" = 3.5;
      "h" = 1;
    }
    {
      "id" = "nightMode";
      "enabled" = true;
      "w" = 3.5;
      "h" = 1;
    }
    {
      "id" = "darkMode";
      "enabled" = true;
      "w" = 3.5;
      "h" = 1;
    }
    {
      "id" = "runningApps";
      "enabled" = true;
      "w" = 5;
      "h" = 1;
      "small" = true;
    }
    {
      "id" = "colorPicker";
      "enabled" = true;
      "w" = 1;
      "h" = 1;
      "small" = true;
    }
    {
      "id" = "edit";
      "enabled" = true;
      "w" = 1;
      "h" = 1;
      "small" = true;
    }
  ];
  "blurEnabled" = false;
  "blurStrength" = 0;
  "blurWallpaperOnOverview" = false;
  "frameEnabled" = false;
  "density" = "comfortable";
  "radiusMode" = "scale";
  "buttonColorMode" = "primary";
  "matugenScheme" = "scheme-tonal-spot";
  "matugenSourceMode" = "dominant";
  "matugenSpec" = "2021";
  "matugenContrast" = 0;
  "osdVolumeEnabled" = true;
  "osdInputMethodEnabled" = true;
  "osdWorkspaceEnabled" = false;
  "osdAlwaysShowValue" = false;
  "osdPositionOverrides" = { };
  "showSeconds" = false;
  "useAutoLocation" = false;
  "systemTrayIconTintMode" = "none";
  "tooltipSurfaceColor" = "default";
  "audioVisualizerEnabled" = true;
  "floatingWindowTitleBars" = true;
  "floatingWindowSyncGlobal" = true;
  "notepadDefaultMode" = "slideout";
  "notepadUseCompositorGap" = false;
  "niriLayoutRadiusOverride" = -1;
  "lockScreenSecurityKeyShortcutEnabled" = false;
  "dashCards" = [
    {
      "id" = "clock";
      "w" = 2;
      "h" = 1;
    }
    {
      "id" = "weather";
      "w" = 1;
      "h" = 1;
    }
    {
      "id" = "notifications";
      "w" = 3;
      "h" = 5;
    }
    {
      "id" = "calendar";
      "w" = 3;
      "h" = 3;
    }
    {
      "id" = "media";
      "w" = 3;
      "h" = 1;
    }
  ];
}
