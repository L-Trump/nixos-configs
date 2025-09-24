{
  config,
  pkgs,
  lib,
  ...
}:
let
  renderSettings = settings: lib.concatStrings (lib.mapAttrsToList renderSetting settings);

  renderSetting = key: value: ''
    ${key} ${renderValue value}
  '';

  renderValue =
    value:
    {
      int = toString value;
      bool = if value then "1" else "0";
      string = ''"${value}"'';
    }
    .${builtins.typeOf value};

  settings = {
    "Gtk/CursorThemeName" = config.home.pointerCursor.name;
    "Gtk/CursorThemeSize" = config.home.pointerCursor.size;
    "Gtk/FontName" = "${config.gtk.font.name}, ${toString config.gtk.font.size}";
    "Net/IconThemeName" = config.gtk.iconTheme.name;
    "Net/ThemeName" = config.gtk.theme.name;
    # "Xft/DPI" = 196608;
  };
in
{
  services.xsettingsd.enable = true;

  xdg.configFile."xsettingsd/xsettingsd.fix.conf" = {
    text = renderSettings settings;
    onChange = ''
      ${pkgs.rsync}/bin/rsync --chmod 644 $VERBOSE_ARG \
          ${
            config.xdg.configFile."xsettingsd/xsettingsd.fix.conf".source
          } ${config.xdg.configHome}/xsettingsd/xsettingsd.conf
    '';
  };

  services.darkman.lightModeScripts.xsettingsd = ''
    XFILE=${config.xdg.configHome}/xsettingsd/xsettingsd.conf
    if [ -n "$(${pkgs.gnugrep}/bin/grep -E '^Net/ThemeName *".*-Dark"$' $XFILE)" ]; then
      ${pkgs.gnused}/bin/sed -i 's/^\(Net\/ThemeName[[:blank:]]*\)"\(.*\)-Dark"$/\1"\2-Light"/;' $XFILE
      ${pkgs.procps}/bin/pkill -HUP xsettingsd
    fi
  '';

  services.darkman.darkModeScripts.xsettingsd = ''
    XFILE=${config.xdg.configHome}/xsettingsd/xsettingsd.conf
    if [ -n "$(${pkgs.gnugrep}/bin/grep -E '^Net/ThemeName *".*-Light"$' $XFILE)" ]; then
      ${pkgs.gnused}/bin/sed -i 's/^\(Net\/ThemeName[[:blank:]]*\)"\(.*\)-Light"$/\1"\2-Dark"/;' $XFILE
      ${pkgs.procps}/bin/pkill -HUP xsettingsd
    fi
  '';
}
