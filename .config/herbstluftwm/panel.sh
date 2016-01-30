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
source ~/.config/init/vars

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

unique_line() {
	awk '$0 != l { print ; l=$0 ; fflush(); }'
}

# functions for retrieving and processing data
# upon events

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
	tag_id=$(hc get_attr tags.focus.index)
	focus_id=$(hc get_attr clients.focus.winid | sed 's/^0x0*//')

	if [[ -z "$focus_id" ]]; then
		focus_id=0
	fi

	lines=$(wmctrl -l | sed 's/^0x0*//')

	# kind of messy. use hc dump's ordering but wmctrl -l for pairing
	# ids with titles
	for c in $(hc dump | grep -Eo '0x[0-9a-f]*' | sed 's/^0x0*//'); do
		echo "$lines" | grep "$c"
	done | while read -ra line
	do
		# is it focussed?
		if [[ $((16#${line[0]})) -eq $((16#$focus_id)) ]]; then
			echo -n " %{B${bg_focus} F${fg_focus}} "
		else
			echo -n " %{B${bg_normal} F${fg_normal}} "
		fi
		echo -n "${line[@]:3}" | sed -r 's/(.{60}).*/\1\.\.\./'
	done
	echo -n " %{B${bg_normal} F${fg_normal}}"
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
fields[5]=""
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
	while true; do
		echo -en "mpd\t"
		mpc status >/dev/null 2>&1
		if [[ $? -ne 0 ]]; then
			echo "disconnected"
			sleep 5
		else
			if [[ -z "$(mpc status | grep '\[playing\]')" ]]; then
				if [[ -z "$(mpc status | grep '\[paused\]')" ]]; then
					echo "stopped"
				else
					echo "paused"
				fi
			else
				echo "playing"
			fi
			mpc idle player >/dev/null 2>&1
		fi
	done > >(unique_line)
}

event_stat() {
	conky -c ~/.config/herbstluftwm/panel/conky_stats
}

event_when() {
	while true; do
		if [[ -z "$(when --future=2 | sed '1,2d')" ]]; then
			echo -e 'when\t0'
		else
			echo -e 'when\t1'
		fi
		sleep 10
	done > >(unique_line)
}



#######################
#  EVENT MULTIPLEXER  #
#######################

# the loops defined above are launched and
# their outputs multiplexed 

{
	event_tick &
	echo -e "child\t$!"
	event_stat &
	echo -e "child\t$!"
	event_when &
	echo -e "child\t$!"
	event_mpd &
	echo -e "child\t$!"
	
	hc --idle
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
				;;
				
			mpd)
				fields[5]="%{F${bg_focus}}|%{A:mpd: F"
				case "${event[1]}" in
					playing)
						fields[5]+=$(echo -n "${fg_green}} \uE0FE \uE09A")
						;;
					paused)
						fields[5]+=$(echo -n "${fg_yellow}} \uE0FE \uE09B")
						;;
					stopped)
						fields[5]+=$(echo -n "${fg_blue}} \uE0FE \uE099")
						;;
					*)
						fields[5]+=$(echo -n "${fg_red}} \uE0FE \uE09E")
						;;
				esac
				fields[5]+=" %{F${fg_normal} A}"
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
						echo -n "%{F${fg_yellow}} \uE0AE %{F${fg_normal} A}")
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

			# append children to kill list
			child)
				child[((${#child[@]}+1))]=event[1]
				;;

			quit_panel|reload)
				for id in ${child[@]}; do
					kill $id
				done
				exit
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
				~/.config/herbstluftwm/mpc-status.sh
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
