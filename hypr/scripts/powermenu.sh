#!/usr/bin/env bash

op=$( echo -e " Poweroff\n Reboot\n Suspend\n Lock\n Logout" | wofi -i --dmenu --height 135 --location=top -y 15 | awk '{print tolower($2)}' )

case $op in
        poweroff)
                ;&
        reboot)
                ;&
        suspend)
                systemctl $op
                ;;
        lock)
		hyprlock -c $HOME/.config/hypr/lock.conf
                ;;
        logout)
                hyprctl dispatch exit
                ;;
esac
