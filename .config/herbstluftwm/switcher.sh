#!/bin/zsh

source ~/.config/herbstluftwm/config_vars

list=$(wmctrl -l)
IFS=$'\r\n' nums=($(echo $list | cut -d ' ' -f 1))
choice=$(echo $list | cut -d ' ' -f 5- | nl -w 2 -s ") " | \
	dmenu -fn $efont -i -h $bheight -nb $bg_normal -nf $fg_normal \
	-sb $bg_focus -sf $fg_focus -p "Select:" -l 40 | \
	cut -d ')' -f 1)

if [ $choice ]; then
	herbstclient jumpto ${nums[$choice]}
fi
