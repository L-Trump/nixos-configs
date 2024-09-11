#!/bin/bash
export LANG=en_GB.UTF-8
export LANGUAGE=zh_CN:en_US
session=${1:-i3}
lang=${2:-cn}
export QT_AUTO_SCREEN_SCALE_FACTOR=0
export QT_FONT_DPI=192
# export GDK_SCALE=1.35
# export GDK_DPI_SCALE=0.7407
export GTK_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export QT_IM_MODULE=fcitx
export SDL_IM_MODULE=fcitx
export GLFW_IM_MODULE=ibus
# exec mpd ~/.config/mpd/mpd.conf
numlockx &
xrdb -merge ~/.Xresources
# xrandr --setprovideroutputsource 0 1
# xrandr --output eDP --scale 1.35x1.35
# xrandr --output HDMI-A-0 --scale 1.30x1.30
# xrandr --output HDMI-A-0 --primary --pos 2592x0 --scale 0.9999x0.9999 --auto
# xrandr --output HDMI-A-0 --primary --pos 2592x0 --scale 1.35x1.35 --auto
# xrandr --output HDMI-A-0 --primary --pos 2592x0 --auto
# xrandr --output HDMI-A-0 --primary --scale 1.2x1.2 --pos 2592x0 --auto
# xrandr --output eDP --auto --output HDMI-A-0 --auto --primary --scale 0.75x0.75 --right-of eDP
xrandr --output eDP --pos 0x0 --auto
xrandr --output HDMI-1 --primary --pos 2880x0 --scale 2x2 --auto
case $lang in
en) export LANG=en_GB.UTF-8 ;;
cn) export LANG=zh_CN.UTF-8 ;;
esac

# killall lxpolkit
pkill lxqt-policykit-agent
lxqt-policykit-agent &
# /usr/bin/lxpolkit &

case $session in
kde) exec startplasma-x11 ;;
    #   i3       ) exec i3-session && i3 -V >> ~/.logs/i3/$(date +'%F-%k-%M-%S').log 2>&1;;
# i3       ) exec i3-session > ~/.logs/i3/$(date +'%F-%k-%M-%S').log 2>&1;;
i3) exec i3-session ;;
gnome) exec gnome-session ;;
awesome) exec awesome ;;
*) exec $1 ;;
esac
