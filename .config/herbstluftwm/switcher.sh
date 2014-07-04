#!/bin/zsh

source ~/.config/herbstluftwm/config_vars

IFS=$'\r\n'  clients=($(wmctrl -l | cut -c -10))
number=$(wmctrl -l | cut -c 20- | nl -w 2 -s ") " | \
	dmenu -fn $efont -i -h $bheight -nb $bg_normal -nf $fg_normal \
	-sb $bg_focus -sf $fg_focus -p "Select:" -l 40 | \
	grep -oE '[0-9]' | head -1)

echo ${clients[$number]}
if [ $number ]; then
	herbstclient jumpto ${clients[$number]}
fi
