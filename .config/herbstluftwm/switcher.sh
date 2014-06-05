#!/bin/zsh

IFS=$'\r\n'  clients=($(wmctrl -l | cut -c -10))
number=$(wmctrl -l | cut -c 20- | nl -w 2 -s ") " | dmenu -i -h 18 -nb $1 -nf $2 -sb $3 -sf $4 -p "Select:" -l 40 | grep -oE '[0-9]' | head -1)
if [ $number ]; then
	herbstclient jumpto ${clients[$(expr $number - 1)]}
fi
