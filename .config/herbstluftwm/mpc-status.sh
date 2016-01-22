#!/bin/bash

case "$1" in
	next)
		mpc next
		;;
	prev)
		mpc prev
		;;
	*)
		;;
esac

cd ~/music/
dir=$(dirname "$(mpc current -f %file%)")
# copying is necessary because notify-send can't into icon paths containing commas
cp "$dir/cover-small.png" /tmp/mpd-icon.png

message="$(mpc current -f '##%track% %title% (%date%)\n%artist% - %album%')

$(mpc status | tail -n -2 | sed -re 's/volume.*repeat/\nrepeat/' -e 's/( ){3,4}/\n/g' -e '/volume:  /d')"

# i patched dunst to clear all on SIGUSR1
killall -SIGUSR1 dunst

notify-send --icon=/tmp/mpd-icon.png "$message"
