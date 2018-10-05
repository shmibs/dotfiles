#!/bin/bash

# race condition, obvs, but this is hopefully time enough
case "$1" in
	down)
		pavolume voldown --quiet 2
		;;
	up)
		pavolume volup --quiet 2
		;;
	mute)
		pavolume mutetoggle --quiet
		;;
	*)
		pavolume show
		;;
esac
