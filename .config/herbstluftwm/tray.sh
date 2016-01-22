#!/bin/bash
hc() { "${herbstclient_command[@]:-herbstclient}" "$@" ;}

source ~/.config/init/vars

run=""
while [ -z "$run" ]; do
	sleep .5
	run=$(ps -e | grep bar)
	echo "$run"
done

trayer --edge top --align right --heighttype pixel --height $bheight --widthtype pixel --width $bheight --distancefrom right --distance 4
