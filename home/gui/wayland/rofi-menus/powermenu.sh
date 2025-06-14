#!/usr/bin/env bash

## Author  : Aditya Shakya
## Mail    : adi1090x@gmail.com
## Github  : @adi1090x
## Twitter : @adi1090x

dir="~/.config/waybar/rofi-menus/rofi"
uptime=$(uptime -p | sed -e 's/up //g')
DESKTOP_SESSION=${DESKTOP_SESSION:-"Hyprland"}
rofi_command="rofi -dpi 144 -theme $dir/powermenu.rasi"

# Options
shutdown=" Shutdown"
reboot=" Restart"
lock=" Lock"
suspend=" Sleep"
logout=" Logout"
displayoff=" DisplayOff"

# Confirmation
confirm_exit() {
	rofi -dpi 144 -dmenu\
		-i\
		-no-fixed-num-lines\
		-p "Are You Sure? : "\
		-theme $dir/confirm.rasi
}

# Message
msg() {
	rofi -dpi 144 -theme "$dir/message.rasi" -e "Available Options  -  yes / y / no / n"
}

# Variable passed to rofi
options="$lock\n$displayoff\n$suspend\n$logout\n$reboot\n$shutdown"

chosen="$(echo -e "$options" | $rofi_command -p "Uptime: $uptime" -dmenu -l 6 -selected-row 0)"
case $chosen in
    $shutdown)
		ans=$(confirm_exit &)
		if [[ $ans == "yes" || $ans == "YES" || $ans == "y" || $ans == "Y" ]]; then
			systemctl poweroff
		elif [[ $ans == "no" || $ans == "NO" || $ans == "n" || $ans == "N" ]]; then
			exit 0
        else
			msg
        fi
        ;;
    $reboot)
		ans=$(confirm_exit &)
		if [[ $ans == "yes" || $ans == "YES" || $ans == "y" || $ans == "Y" ]]; then
			systemctl reboot
		elif [[ $ans == "no" || $ans == "NO" || $ans == "n" || $ans == "N" ]]; then
			exit 0
        else
			msg
        fi
        ;;
    $lock)
		if command -v swaylock >/dev/null 2>&1; then
			loginctl lock-session
		fi
        ;;
    $displayoff)
		loginctl lock-session
		sleep 5
		if [[ "$DESKTOP_SESSION" == "niri" ]]; then
			niri msg action power-off-monitors
		else
			hyprctl dispatch dpms off
		fi
        ;;
    $suspend)
		ans=$(confirm_exit &)
		if [[ $ans == "yes" || $ans == "YES" || $ans == "y" || $ans == "Y" ]]; then
			mpc -q pause
			amixer set Master mute
			systemctl suspend
		elif [[ $ans == "no" || $ans == "NO" || $ans == "n" || $ans == "N" ]]; then
			exit 0
        else
			msg
        fi
        ;;
    $logout)
		ans=$(confirm_exit &)
		if [[ $ans == "yes" || $ans == "YES" || $ans == "y" || $ans == "Y" ]]; then
			if [[ "$DESKTOP_SESSION" == "Openbox" ]]; then
				openbox --exit
			elif [[ "$DESKTOP_SESSION" == "bspwm" ]]; then
				bspc quit
			elif [[ "$DESKTOP_SESSION" == "i3" ]]; then
				i3-msg exit
			elif [[ "$DESKTOP_SESSION" == "sway" ]]; then
				swaymsg exit
			elif [[ "$DESKTOP_SESSION" == "Hyprland" ]]; then
				hyprctl dispatch exit
			elif [[ "$DESKTOP_SESSION" == "niri" ]]; then
				niri msg action quit -s
			fi
		elif [[ $ans == "no" || $ans == "NO" || $ans == "n" || $ans == "N" ]]; then
			exit 0
        else
			msg
        fi
        ;;
esac
