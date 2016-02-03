#!/bin/zsh

source ~/.config/init/vars

typeset -i choice
nums=()
lines=""
while read -rA line; do
	nums=( "${nums[@]}" "${line[1]}" )
	if [[ -z "$lines" ]]; then
		lines="${line[@]:3}"
	else
		lines="${lines}\n${line[@]:3}"
	fi
done < <(wmctrl -l)

echo -e "$lines" | nl -w 2 -s ") " | dmenu -fn $efont -i -h $bheight \
		-nb $bg_normal -nf $fg_normal -sb $bg_focus -sf $fg_focus \
		-p "Select:" -l 40 | cut -d ')' -f 1 | {read choice}

herbstclient jumpto "${nums[$choice]}"
