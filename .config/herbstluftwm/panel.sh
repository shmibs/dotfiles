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

# these are annoying, but i can't figure out a stateless way to handle rotation
declare -i mpd_offset
declare -i mpd_length
declare mpd_current
declare mpd_playing

hc pad $monitor $bheight



#################
#  SUBROUTINES  #
#################

# functions for retrieving and processing data
# upon events

update_mpd() {
		echo -n "%{F${bg_focus}}|%{F${fg_normal} A:mpd:} "
		echo -n "%{F${fg_green}}\uE05C%{F${fg_normal}} "
		#echo -n "$mpd_current" | cut -c -$(expr 20 - "$mpd_offset")
		echo "%{A}"
		if [[ $mpd_length -gt 20 ]]; then
			if [[ $mpd_offset -lt $[mpd_length-1] ]]; then
				mpd_offset=$[mpd_offset+1]
			else
				mpd_offset=0
			fi
		fi
}

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

	if [[ -z "$focus_id" ]]; then
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
# mpd
fields[5]=""
# conky stats
fields[6]=""
# date
fields[7]=""



######################
#  EVENT GENERATORS  #
######################

# loops for generating a line of information,
# with the first element in the line as a
# unique identifier for the event type

get_date() {
	{
		while true; do
			date +$'date\t%a, %b %d, %H:%M:%S'
			sleep 1
		done
	} |	awk '$0 != l { print ; l=$0 ; fflush(); }'
}

get_mpd() {
	while true; do
		if [[ -z "$(mpc status | grep '\[playing\]')" ]]; then
			echo -e "mpd\tpaused"
		else
			echo -e "mpd\tplaying"
		fi
		mpc idle player
	done
}

get_stat() {
	{
		conky -c ~/.config/herbstluftwm/panel/conky_stats
	}
}

get_when() {
	{
		while true; do
			if [[ -z "$(when --future=2 | sed '1,2d')" ]]; then
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
	get_mpd &
	child[4]=$!
	
	hc --idle
	
	for id in ${child[@]}; do
		kill $id
	done

	pkill lemonbar
	
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
				if [[ $mpd_playing ]]; then
					fields[5]=$(update_mpd)
				fi
				;;
				
			mpd)
				if [[ "${event[1]}" == "playing" ]]; then
					mpd_offset=0
					mpd_current="$(mpc current) "
					mpd_length=${#mpd_current}
					mpd_playing=true
					fields[5]=$(update_mpd)
				else
					mpd_offset=0
					mpd_length=0
					mpd_current=""
					mpd_playing=false
				fi
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
				fields[6]=$(
					echo -n "%{F${bg_focus}}|%{F${fg_normal} A:stats:} "
					echo -n "%{F${fg_blue}}\uE023%{F${fg_normal}} ${event[1]} "
					echo -n "%{F${fg_yellow}}\uE020%{F${fg_normal}} ${event[2]} "
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
		
		# finally, echo all the fields in order
		printf '%b' "${fields[@]}" '\n'
		
	done
	
	# pass the events into bar
} 2> /dev/null | lemonbar -f "$bfont1" -f "$bfont2" \
	-g${width}x${bheight}+${xpos}+${ypos} \
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
			mpd)
				notify-send "$(mpc status)"
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
