#!/bin/bash
hc() { "${herbstclient_command[@]:-herbstclient}" "$@" ;}
bgcolor=$(hc get frame_border_normal_color)

run=""
while [ -z "$run" ]; do
	sleep .5
	run=$(ps -e | grep dzen2)
	echo "$run"
done

trayer --edge top --align right --heighttype pixel --height 18 --widthtype pixel --width 18 --distancefrom right --distance 4
