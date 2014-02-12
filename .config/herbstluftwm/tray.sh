#!/bin/bash
hc() { "${herbstclient_command[@]:-herbstclient}" "$@" ;}
bgcolor=$(hc get frame_border_normal_color)

run=""
while [ -z "$run" ]; do
	sleep .5
	run=$(ps -e | grep dzen2)
	echo "$run"
done

stalonetray -bg "$bgcolor" --window-layer top --geometry 1x1+1740+1 --max-geometry 1752x18 --grow-gravity E -i 16 --kludges force_icons_size
