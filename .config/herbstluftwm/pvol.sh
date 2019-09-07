#!/usr/bin/env zsh

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
