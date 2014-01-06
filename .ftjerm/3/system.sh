#!/bin/bash
sleep .125s
input=""
first=""

cd /home/shmibs/.ftjerm/3/commands

while IFS="" read -r -e -d $'\n' -p "sys: " -a input; do 
	history -s "$input"

	IFS=" "
	input=($input)
	
	if [ -n "$input" ]; then

	first=${input[0]}
	unset input[0]
	
		if [ "$first" == "upgrade" ]; then	
			if [ "${input[1]}" == "-a" ]; then
				yaourt -Syua
			else
				sudo pacman -Syu
			fi
		fi

		if [ "$first" == "update" ]; then
			sudo pacman -Syy
		fi

		if [ "$first" == "update-keys" ]; then
			sudo pacman-key --populate archlinux
		fi

		if [ "$first" == "clear" ]; then
			clear
		fi

		if [ "$first" == "install" ]; then
			sudo pacman -S ${input[*]}
		fi

		if [ "$first" == "remove" ]; then
			sudo pacman -R ${input[*]}
		fi

		if [ "$first" == "search" ]; then
			if [ "${input[1]}" == "-a" ]; then
				unset input[1]		
				yaourt -Ss ${input[*]}
			else
				pacman -Ss ${input[*]}
			fi		
		fi

		if [ "$first" == "aur" ]; then
			yaourt -S ${input[*]}
		fi

		if [ "$first" == "reboot" ]; then
			systemctl reboot
		fi

		if [ "$first" == "poweroff" ]; then
			poweroff
		fi

		if [ "$first" == "logout" ]; then
			mate-session-save --logout
		fi

		if [ "$first" == "spell" ]; then
			echo "${input[*]}" | aspell -a
		fi

		if [ $first == "thesaurus" ]; then
			aiksaurus "${input[1]}"
		fi

		if [ "$first" == "define" ]; then
			sdcv "${input[1]}"
		fi
		
		if [ "$first" == "record" ]; then
			if [ -f ~/Desktop/temp.mkv ]; then
				rm ~/Desktop/temp.mkv
			fi
			ffmpeg -f alsa -i pulse -f x11grab -s 1920x1080 -i :0.0 -preset ultrafast -vcodec libx264 -threads 0 -qp 0 ~/Desktop/temp.mkv
		fi
		
		if [ "$first" == "suspend" ]; then
			systemctl suspend
		fi
		
	fi

done
