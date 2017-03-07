#!/bin/zsh

source ~/.config/init/vars

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

while [[ "$in" != "" ]]; do
	in=$(dmenu -noinput -fn "${bfont}:size=${bfont_size}" -q -h "$bheight" \
		-nb "$bar_bg" -nf "$fg_normal" \
		-sb "$bar_fg" -sf "$fg_focus" -p "$prompt" | \
		sed -e "s/ans/$acc/g")
	if [[ $(command_check "$in" "$acc") -eq 1 ]]; then
		break
	fi

	out=$(echo "pi=$pi; e=$e; $acc $in" | calc -p 2>&1)
	
	if [[ "${?#0}" != "" ]]; then
		out=$(echo "$out" | tr -d "\n")
		if [[ "$out" = "Missing operator" ]]; then
			out=$(echo "pi=$pi; e=$e; $in" | calc -p 2>&1)
			if [[ "${?#0}" != "" ]]; then
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
	else
		acc=$out
		prompt="calc: ($acc)"
	fi
done
