#!/bin/bash

###########
#  SETUP  #
###########

hc() { "${herbstclient_command[@]:-herbstclient}" "$@" ;}
monitor=${1:-0}
geometry=( $(herbstclient monitor_rect "$monitor") )
if [ -z "$geometry" ] ;then
    echo "Invalid monitor $monitor"
    exit 1
fi
# geometry has the format W H X Y
xpos=${geometry[0]}
ypos=${geometry[1]}
width=${geometry[2]}

# grab standardised colours
source ~/.config/herbstluftwm/config_vars

# set alpha for background colours
alpha='#ff'
bg_normal=$(echo -n $alpha; echo "$bg_normal" | tr -d '#')
fg_normal=$(echo -n '#ff'; echo "$fg_normal" | tr -d '#')
bg_focus=$(echo -n $alpha; echo "$bg_focus" | tr -d '#')
fg_focus=$(echo -n '#ff'; echo "$fg_focus" | tr -d '#')
bg_urgent=$(echo -n $alpha; echo "$bg_urgent" | tr -d '#')
fg_urgent=$(echo -n '#ff'; echo "$fg_urgent" | tr -d '#')

fg_grey=$(echo -n '#ff'; echo "$fg_grey" | tr -d '#')
fg_red=$(echo -n '#ff'; echo "$fg_red" | tr -d '#')
fg_green=$(echo -n '#ff'; echo "$fg_green" | tr -d '#')
fg_yellow=$(echo -n '#ff'; echo "$fg_yellow" | tr -d '#')
fg_blue=$(echo -n '#ff'; echo "$fg_blue" | tr -d '#')

hc pad $monitor $bheight



#################
#  SUBROUTINES  #
#################

# functions for retrieving and processing data
# upon events

# bytes to human readable, cropped to 4 chars wide
#b2hc() {
#	suffixes=( 'B' 'K' 'M' 'G' 'T' 'P' 'E' 'Z' 'Y' )
#	sindex=0
#	val=$1
#	[[ -z $(echo $1 | grep "^[0-9]*$") ]] && read val
#	
#	while [[ $(echo $val / 1024 | bc) -ne 0 ]]; do
#		val=$(echo "scale=2; $val / 1024" | bc)
#		let sindex=sindex+1
#	done
#	
#	val=$(echo $val | sed
#	echo "${val}${suffixes[$sindex]}"
#}

update_taglist() {
	echo -n "%{l}%{B${bg_normal} F${fg_normal} U${fg_normal}}"
	hc tag_status | tr '\t' '\n' | sed \
		-e '1d' \
		-e '$d' \
		-e 's/\(.*\)/\1 /' \
		-e 's/:/ /' \
		-e "s/[#+\-%]\(.*\)/%{B${bg_focus} F${fg_focus}} \1%{B${bg_normal} F${fg_normal}}/" \
		-e "s/!\(.*\)/%{B${bg_urgent} F${fg_urgent}} \1%{B${bg_normal} F${fg_normal}}/" \
		-e "s/\.\(.*\)/%{B${bg_normal} F${fg_grey}} \1%{B${bg_normal} F${fg_normal}}/" \
		| tr -d '\n'
	echo "%{F${bg_focus}}|%{F${fg_normal}}"
}

update_winlist() {
	focus_id=$(hc get_attr clients.focus.winid)

	if [[ "$focus_id" == "" ]]; then
		return
	fi

	# grab current window list, limit to current desktop,
	# clean up output, cut to length,add focused window 
	# formatting, and finally delete win ids and merge
	# lines
	
	for c in $(hc layout | grep -Eo '0x[0-9a-f]*'); do
		xwininfo -id $c | sed -n 2p | sed -e 's/"//' -e 's/"$//' -e 's/$/\t/' | cut -c -70 | sed \
		-e 's/xwininfo: Window id: //' \
		-e 's/$/.../' -e 's/\t\.\.\.$//' \
		-e "s/${focus_id} \(.*\)/%{B${bg_focus} F${fg_focus}} \1 %{B${bg_normal} F${fg_normal}}/" \
		-e 's/0x[a-f0-9]* \(.*\)/ \1 /' | tr -d '\n'
	done
}



#######################
#  OUTPUT CONTAINERS  #
#######################

# all fields are put in separate elements

# tag list
fields[1]=$(update_taglist)
# window list
fields[2]=$(update_winlist)
# align right
fields[3]="%{r}"
# when
fields[4]=""
# banshee np
fields[5]=""
# conky stats
fields[6]=""
# date
fields[7]=""
# vertical separator and gap for tray
fields[8]="%{F${bg_focus}}|    %{F${fg_normal}}"


######################
#  EVENT GENERATORS  #
######################

# loops for generating a line of information,
# with the first element in the line as a
# unique identifier for the event type

get_stat() {
	{
		conky -c ~/.config/herbstluftwm/panel/conky_stats
	}
}

get_date() {
	{
		while true; do
			date +$'date\t%a, %b %d, %H:%M:%S'
			sleep 1
		done
	} |	awk '$0 != l { print ; l=$0 ; fflush(); }'
}

get_when() {
	{
		while true; do
			if [[ "$(when --future=2 | sed '1,2d')" == "" ]]; then
				echo -e 'when\t0'
			else
				echo -e 'when\t1'
			fi
			sleep 10
		done
	} |	awk '$0 != l { print ; l=$0 ; fflush(); }'
}



#######################
#  EVENT MULTIPLEXER  #
#######################

# the loops defined above are launched and
# their outputs multiplexed 

{
	get_stat &
	child[1]=$!
	get_date &
	child[2]=$!
	get_when &
	child[3]=$!
	
	hc --idle
	
	for id in ${child[@]}; do
		kill $id
	done

	pkill bar
	
} 2> /dev/null | {



##################
#  EVENT PARSER  #
##################

# those lines are then read, one by one,
# and the information contained used to
# generate the required fields

	while true; do
		
		# split our read lines into an array
		# for easy parsing
		IFS=$'\t' read -ra event || break
		
		# determine event type and act
		# accordingly
		case "${event[0]}" in
			date)
				fields[7]="%{F${bg_focus}}|%{F${fg_normal} A:date:} \uE015 ${event[@]:1} %{A}"
				;;
				
			stats)
				# enforce fixed widths with sed. printf
				# pads in the other direction
				event[1]=$(echo ${event[1]} | sed \
					-e 's/^\(..\)$/\1  /' \
					-e 's/^\(...\)$/\1 /')
				event[2]=$(echo ${event[2]} | sed \
					-e 's/^\(..\)$/\1  /' \
					-e 's/^\(...\)$/\1 /')
				event[3]=$(echo ${event[3]} | sed \
					-e 's/^\(..\)$/\1   /' \
					-e 's/^\(...\)$/\1  /' \
					-e 's/^\(....\)$/\1 /')
				event[4]=$(echo ${event[4]} | sed \
					-e 's/^\(..\)$/\1   /' \
					-e 's/^\(...\)$/\1  /' \
					-e 's/^\(....\)$/\1 /')
				fields[6]=$(
					echo -n "%{F${bg_focus}}|%{F${fg_normal} A:stats:} "
					echo -n "%{F${fg_blue}}\uE023%{F${fg_normal}} ${event[1]} "
					echo -n "%{F${fg_yellow}}\uE020%{F${fg_normal}} ${event[2]} "
					echo -n "%{F${bg_focus}}|%{F${fg_normal}} "
					echo -n "%{F${fg_green}}\uE07B%{F${fg_normal}} ${event[3]} "
					echo -n "%{F${fg_red}}\uE07C%{F${fg_normal}} ${event[4]} "
					echo -n "%{A}")
				;;
				
			when)
				if [[ "${event[1]}" -eq 1 ]]; then
					fields[4]=$(echo -n "%{F${bg_focus}}|%{F${fg_normal} A:when:}"
						echo -n "%{F${fg_red}} \uE0AE %{F${fg_normal} A}")
				else
					fields[4]=""
				fi
				;;

			# hc events
			focus_changed|window_title_changed)
				fields[2]=$(update_winlist)
				;;
				
			tag_changed|tag_flags)
				fields[1]=$(update_taglist)
				fields[2]=$(update_winlist)
				;;
				
			*)
				;;
		esac
		
		# i wish i could just print the entire array
		# this easily, but that inserts spaces
		#echo -e "${fields[@]}"
		
		echo -en "${fields[1]}${fields[2]}${fields[3]}${fields[4]}"
		echo -e "${fields[5]}${fields[6]}${fields[7]}${fields[8]}"
		
	done
	
	# pass the events into bar
} 2> /dev/null | bar -f $dfont -g${width}x${bheight}+${xpos}+${ypos} \
	-B ${bg_normal} -F ${fg_normal} | \
{

#####################
#  COMMAND HANDLER  #
#####################

# finally, take the output from bar and execute commands
	while read command; do
		case "$command" in
			date)
				notify-send "$(cal)"
				;;
			stats)
				urxvt -e htop &
				;;
			when)
				notify-send "$(when)"
				;;
			*)
				;;
		esac
	done
}
