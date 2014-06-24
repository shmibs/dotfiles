#!/bin/bash

acc=0
in="first"
prompt="calc:"
pi="3.1415926535897932384626433832795028841971694"
e="2.7182818284590452353602874713526624977572471"

# check first word for special commands
command_check() {
	case "$(echo $1 | cut -d ' ' -f 1)" in
	"y")
		echo "$2" | tr -d '~' | xclip -selection clipboard
		return 1
	;;
	"yank")
		echo "$2" | tr -d '~' | xclip -selection clipboard
		return 1
	;;

	*)
		return 0
	;;
	esac
}

while [ "$in" != "" ]; do
	in=$(echo "" | dmenu -q -h 18 -nb $1 -nf $2 -sb $3 -sf $4 -p "$prompt")
	if [[ $(command_check "$in" "$acc") -eq 1 ]]; then
		break
	fi

	# replace "ans" with the previous value
	in=$(echo $in | sed -e "s/ans/$acc/g")

	out=$(echo "pi=$pi; e=$e; $acc $in" | calc -p 2>&1)
	
	if [ "${?#0}" != "" ]; then
		out=$(echo "$out" | tr -d "\n")
		if [ "$out" = "Missing operator" ]; then
			out=$(echo "pi=$pi; e=$e; $in" | calc -p 2>&1)
			if [ "${?#0}" != "" ]; then
				out=$(echo "$out" | tr -d "\n")
				prompt="calc: ($acc) err: $out"
			else
				acc=$out
				prompt="calc: ($acc)"
			fi
		else
			out=$(echo "$out" | tr -d "\n")
			prompt="calc: ($acc) err: $out"
		fi
	fi
done

