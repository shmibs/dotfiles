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

declare -i mpd_connected
declare mpc_current
declare mpc_rot


#################
#  SUBROUTINES  #
#################

# functions for retrieving and processing data
# upon events

update_mpd() {
	echo -n "%{F${bg_focus}}|%{F${fg_normal} A:mpd:} "

	# failed to connect or stopped
	if [[ -z "$(mpc current)" ]]; then
		if [[ $? ]]; then
			mpd_connected=0
		fi
		echo "%{F${fg_red}}\uE05C %{F${fg_normal} A}"
		return
	else
		if [[ "$(mpc current -f \"%title\")" == "$mpc_current" ]]; then
			if [[ ${#mpc_rot} -gt 10 ]]; then
				mpc_rot=$(echo "$mpc_rot" | sed -e 's/\(.\)\(.*\)/\2\1/')
			fi
		else
			mpc_current="$(mpc current -f \"%title%\")"
			mpc_rot=mpc_current
		fi

		echo -n "%{F${fg_green}}"
		# if you want separate icons for paused / playing
		# if [[ -z "$(mpc status | grep '\[playing\]')" ]]; then
		# 	echo -n "paused icon"
		# else
		# 	echo -n "playing icon"
		# fi
		echo -n "\uE05C "

		echo "$mpc_rot" | cut -c 10 | tr -d '\n'

		echo "%{F${fg_normal} A}"
	fi

	mpd_connected=1
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

update_date() {
	echo -n "%{F${bg_focus}}|%{F${fg_normal} A:date:} \uE015 "
	date +$'%a, %b %d, %H:%M:%S' | tr -d '\n'
	echo " %{A}"
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
fields[5]="$(update_mpd)"
# conky stats
fields[6]=""
# date
fields[7]="$(update_date)"



######################
#  EVENT GENERATORS  #
######################

# loops for generating a line of information,
# with the first element in the line as a
# unique identifier for the event type

# an event passed once a second
event_tick() {
	while true; do
		sleep 1
		echo "tick"
	done
}

event_mpd() {
	mpc status
	while true; do
		if [[ $? ]]; then
			mpd_connected=0
			echo -e "mpd\tdisconnected"
			sleep 10
			break
		else
			mpd_connected=1
			echo -e "mpd\tconnected"
		fi
		mpc idle player
	done
}

event_stat() {
	{
		conky -c ~/.config/herbstluftwm/panel/conky_stats
	}
}

event_when() {
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
	event_tick &
	child[1]=$!
	event_stat &
	child[2]=$!
	event_when &
	child[3]=$!
	event_mpd &
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
			tick)
				fields[7]=$(update_date)
				if [[ $mpd_connected ]]; then
					fields[5]=$(update_mpd)
				fi
				;;
				
			mpd)
				fields[5]=$(update_mpd)
				;;
				
			stats)
				event[1]=$(printf "%-4s" ${event[1]})
				event[2]=$(printf "%-4s" ${event[2]})
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

			quit_panel)
				pkill dunst
				break
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
