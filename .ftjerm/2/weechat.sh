#!/bin/bash
sleep .125s
input=""
cd /home/shmibs/.ftjerm/2/commands
while IFS="" read -r -e -d $'\n' -p "irc: " -a input; do 
	history -s "$input"

	IFS=" "
	input=($input)
	if [ -n "$input" ]; then
				
		if [ ${input[0]} == "connect" ]; then
			weechat-curses
		fi

		if [ ${input[0]} == "logs" ]; then
			if [ -z ${input[1]} ]; then
				for i in $( ls /home/shmibs/.weechat/logs ); do
					echo $i:
					ls /home/shmibs/.weechat/logs/$i
					echo
				done
			else
				less "/home/.weechat/logs/${input[1]}.log"
			fi
		fi

		if [ ${input[0]} == "clear" ]; then
			clear
		fi

		if [ ${input[0]} == "search" ]; then
			if [ -n ${input[1]} ]; then
				cd /home/shmibs/.weechat/logs
				grep --color=always "${input[1]}" ./irc.*${input[2]}* | sed -e 's/.\/irc.\|.weechatlog\|grep: * No such file or directory//g'
				cd /home/shmibs/.tilda/2/commands
			fi
		fi
	fi
done
