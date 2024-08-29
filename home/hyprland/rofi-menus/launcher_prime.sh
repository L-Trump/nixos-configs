#!/usr/bin/env bash

FILE="$HOME/.config/waybar/rofi-menus/rofi/colors.rasi"

# random accent color
COLORS=('#EC7875' '#EC6798' '#BE78D1' '#75A4CD' '#00C7DF' '#00B19F' '#61C766' \
		'#B9C244' '#EBD369' '#EDB83F' '#E57C46' '#AC8476' '#6C77BB' '#6D8895')
AC="${COLORS[$(( $RANDOM % 14 ))]}"
sed -i -e "s/ac: .*/ac:   ${AC}FF;/g" $FILE
sed -i -e "s/se: .*/se:   ${AC}40;/g" $FILE

rofi -no-config -no-lazy-grab -dpi 144 -show drun -modi drun -theme ~/.config/waybar/rofi-menus/rofi/launcher.rasi -run-command "fish -c 'run-app-filter {cmd}'"
