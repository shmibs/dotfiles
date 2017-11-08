#!/usr/bin/env zsh

source ~/.config/init/vars

zparseopts -M -E -A args \
	f	-firefox=f

local password_files

password_files=( ~/.password-store/**/*.gpg )
password_files=( ${password_files:t:r} )

printf "%s\n" $password_files | dmenu -fn "${bfont}:size=${bfont_size}" -i \
		-h "$bheight" -nb "$bar_bg" -nf "$bar_fg" \
		-sb "$bg_focus" -sf "$fg_focus" \
		-p "Pass:"  | cut -d ')' -f 1 | read choice

[[ -n $choice ]] || exit

pass show $choice | sed -n -e 's/^login: //p' | xclip -selection clipboard

pass show $choice | sed -n -e 's/^url: //p' | read url
[[ ${(@k)args[-f]} ]] && firefox --new-tab "$url"

pass show -c $choice
