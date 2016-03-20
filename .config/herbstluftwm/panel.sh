#!/bin/bash

###########
#  SETUP  #
###########

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

std_black=$(echo -n '#ff'; echo "$std_black" | tr -d '#')
std_red=$(echo -n '#ff'; echo "$std_red" | tr -d '#')
std_green=$(echo -n '#ff'; echo "$std_green" | tr -d '#')
std_yellow=$(echo -n '#ff'; echo "$std_yellow" | tr -d '#')
std_blue=$(echo -n '#ff'; echo "$std_blue" | tr -d '#')
std_magenta=$(echo -n '#ff'; echo "$std_magenta" | tr -d '#')
std_cyan=$(echo -n '#ff'; echo "$std_cyan" | tr -d '#')
std_white=$(echo -n '#ff'; echo "$std_white" | tr -d '#')

light_black=$(echo -n '#ff'; echo "$light_black" | tr -d '#')
light_red=$(echo -n '#ff'; echo "$light_red" | tr -d '#')
light_green=$(echo -n '#ff'; echo "$light_green" | tr -d '#')
light_yellow=$(echo -n '#ff'; echo "$light_yellow" | tr -d '#')
light_blue=$(echo -n '#ff'; echo "$light_blue" | tr -d '#')
light_magenta=$(echo -n '#ff'; echo "$light_magenta" | tr -d '#')
light_cyan=$(echo -n '#ff'; echo "$light_cyan" | tr -d '#')
light_white=$(echo -n '#ff'; echo "$light_white" | tr -d '#')

bg_normal=$(echo -n $alpha; echo "$bg_normal" | tr -d '#')
fg_normal=$(echo -n '#ff'; echo "$fg_normal" | tr -d '#')
bg_focus=$(echo -n $alpha; echo "$bg_focus" | tr -d '#')
fg_focus=$(echo -n '#ff'; echo "$fg_focus" | tr -d '#')
bg_urgent=$(echo -n $alpha; echo "$bg_urgent" | tr -d '#')
fg_urgent=$(echo -n '#ff'; echo "$fg_urgent" | tr -d '#')

# separator macro
sep="%{F${bg_focus}}│%{F${fg_normal}}"

hc pad $monitor $bheight


#################
#  SUBROUTINES  #
#################

# functions for retrieving and processing data
# upon events

update_taglist() {
	echo -n "%{l}%{B${bg_normal} F${fg_normal} U${fg_normal}}"
	hc tag_status | tr '\t' '\n' | sed \
		-e '1d' \
		-e '$d' \
		-e 's/\(.*\)/\1 /' \
		-e 's/:/ /' \
		-e "s/^[-%]\(.*\)/%{B${light_black} F${fg_normal}} \1%{B${bg_normal} F${fg_normal}}/" \
		-e "s/^[#+]\(.*\)/%{B${bg_focus} F${fg_focus}} \1%{B${bg_normal} F${fg_normal}}/" \
		-e "s/^!\(.*\)/%{B${bg_urgent} F${fg_urgent}} \1%{B${bg_normal} F${fg_normal}}/" \
		-e "s/^\.\(.*\)/%{B${bg_normal} F${light_black}} \1%{B${bg_normal} F${fg_normal}}/" \
		| tr -d '\n'
	echo "$sep"
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
			echo -n "%{B${bg_focus} F${fg_focus}} "
		else
			echo -n "%{B${bg_normal} F${fg_normal}} "
		fi
		{
			if [[ -z "${line[@]:3}" ]]; then
				echo -n "(has no name)"
			else
				echo -n "${line[@]:3}"
			fi
		} | sed -r 's/(.{40})...*/\1\.\.\./'
		echo -n " "
	done
	echo -n "%{B${bg_normal} F${fg_normal}}"
}

update_date() {
	echo -n "${sep}%{A:date:} \uE015 "
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

unique_line() {
	stdbuf -i0 -o0 uniq
}

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

event_stats() {
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
	event_stats &
	event_when &
	event_mpd &
	
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
				fields[5]="${sep}%{A:mpd: F"
				case "${event[1]}" in
					playing)
						fields[5]+=$(echo -n "${light_green}} \uE0FE \uE09A")
						;;
					paused)
						fields[5]+=$(echo -n "${light_yellow}} \uE0FE \uE09B")
						;;
					stopped)
						fields[5]+=$(echo -n "${light_blue}} \uE0FE \uE099")
						;;
					*)
						fields[5]+=$(echo -n "${light_red}} \uE0FE \uE09E")
						;;
				esac
				fields[5]+=" %{F${fg_normal} A}"
				;;
				
			stats)
				event[1]=$(printf "%-4s" ${event[1]})
				event[2]=$(printf "%-4s" ${event[2]})
				fields[6]=$(
					echo -n "${sep}%{A:stats:} "
					echo -n "%{F${light_blue}}\uE023%{F${fg_normal}} ${event[1]} "
					echo -n "%{F${light_cyan}}\uE020%{F${fg_normal}} ${event[2]} "
					echo -n "%{A}")
				;;
				
			when)
				if [[ "${event[1]}" -eq 1 ]]; then
					fields[4]=$(echo -n "${sep}%{A:when:}"
						echo -n "%{F${light_red}} \uE0AE %{F${fg_normal} A}")
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

			quit_panel|reload)
				kill -- -$$
				exit
				;;
				
			*)
				;;
		esac
		
		# finally, echo all the fields in order
		printf '%b' "${fields[@]}" '\n'
		
	done
	
	# pass the events into bar
} 2> /dev/null | lemonbar -f "$ifont" -o "$ifont_off" \
	-f "${bfont}:size=${bfont_size}" -o "$bfont_off" \
	-f "${jfont}:size=${jfont_size}" -o "$jfont_off" \
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
