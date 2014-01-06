#!/bin/bash
input=""
filename=""
temp=""
action=""
destination=""
sleep .125s

cd /home/shmibs/.ftjerm/1/commands

while IFS="" read -r -e -d $'\n' -p "ssh: " -a input; do 
	history -s "$input"

	IFS=" "
	input=($input)
	
	if [ -n "$input" ]; then
		
		if [ "${input[0]}" == "send" ]; then
			destination=""
			if [ "${input[1]}" == "general" ]; then
				destination="gamarti6@general.asu.edu:/afs/asu.edu/users/g/a/m/gamarti6/"
			fi
			
			if [ "${input[1]}" == "withg" ]; then
				destination="shmibs@withg.org:/home/shmibs/"
			fi		
	
			if [ "${input[1]}" == "saguaro" ]; then
				destination="gamarti6@saguaro.fulton.asu.edu:/home/gamarti6/"
			fi
	
			if [ -n "$destination" ]; then
				cd ~
				read -r -e -d $'\n' -p "~/" -a filename
				temp=`basename $filename`
				scp -r '/home/shmibs/$filename' '$destination$temp'
				cd /home/shmibs/.ftjerm/1/commands

			fi
		fi
		
		if [ "$input" == "sendp" ]; then
			cd ~
			read -r -e -d $'\n' -p "~/" -a filename
			cd /home/shmibs/.ftjerm/1/commands
			temp=`basename $filename`
			scp -r /home/shmibs/$filename shmibs@withg.org:/home/shmibs/www/$temp
			echo "http://withg.org/shmibs/$temp" | xclip -selection clipboard
		fi
		
		if [ "$input" == "get" ]; then
			cd ~
			read -r -e -d $'\n' -p "~/" -a filename
			cd /home/shmibs/.ftjerm/1/commands
			temp=`basename $filename`
			scp -r shmibs@withg.org:~/$filename ~/Desktop/$temp
		fi
		
		if [ "$input" == "getp" ]; then
			cd ~
			read -r -e -d $'\n' -p "~/www/" -a filename
			cd /home/shmibs/.ftjerm/1/commands
			temp=`basename $filename`
			scp -r shmibs@withg.org:/home/shimbs/www/$filename ~/Desktop/$temp
		fi
		
		if [ "${input[0]}" == "connect" ]; then
			if [ "${input[2]}" != "-X" ]; then
				unset ${input[2]}
			fi
	
			destination=""		
	
			if [ "${input[1]}" == "general" ]; then
				destination=gamarti6@general.asu.edu
			fi
	
			if [ "${input[1]}" == "withg" ]; then
				destination=shmibs@withg.org
			fi
	
			if [ "${input[1]}" == "saguaro" ]; then
				destination=gamarti6@saguaro.fulton.asu.edu
			fi
	
			if [ "$destination" != "" ]; then
				ssh ${input[2]} $destination
			fi
		fi
	
	fi
	
done
