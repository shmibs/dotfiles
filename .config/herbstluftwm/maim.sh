#!/usr/bin/env zsh

local mpat='^(send|clipboard|normal)$'

local mode='normal'
local selection

local args
zparseopts -D -E -M -A args \
	m:	-mode=m \
	s	-selection=s

local optarg
for opt in ${(@k)args}; do
	unset optarg
	[[ -z $args[$opt] ]] || optarg=$args[$opt]
	case $opt in
		-m)
			[[ ! $(echo $optarg | grep -oE "$mpat") ]] \
				&& echo "err: bad mode" && exit
			mode=$optarg
			;;

		-s) selection=s ;;
	esac
done

[[ ${#@} -gt 0 ]] && echo "err: unrecognised arguments" && exit

local year
local stamp
date +%Y | read year
date +%s | read stamp

local fname="$HOME/images/scrot/$year/${year}-${stamp}.png"

mkdir -p $HOME/images/scrot/$year

if [[ $mode == clipboard ]]; then
	maim -u${selection} | xclip -selection clipboard -t image/png
	exit
fi

maim -u${selection} $fname && optipng $fname

if [[ $mode == send ]]; then
	[[ -f $fname ]] \
		&& send $fname \
		&& notify-send "maim: sent ${fname:t} to /tmp/" \
		|| notify-send "maim: send to /tmp/ failed"
fi
