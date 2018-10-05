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

mpc status >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
	notify-send "mpd disconnected"
	exit
fi

if [[ -z "$(mpc status | grep -E '\[(playing|paused)\]')" ]]; then
	notify-send "mpd stopped"
	exit
fi

cd ~/music/
dir=$(dirname "$(mpc current -f %file%)")
# linking is necessary because notify-send can't into icon paths containing commas
cd /tmp/
ln -sf "$HOME/music/$dir/cover-small.png" mpd-icon.png

message="$(mpc current -f '##%track% %title% (%date%)\n%artist% - %album%')

$(mpc status | tail -n -2 | sed -re 's/volume.*repeat/\nrepeat/' -e 's/( ){3,4}/\n/g' -e '/volume:  /d')"

notify-send -t 4000 -a closeme --icon=/tmp/mpd-icon.png "$message"
