#merge Xresources
if [ -s ~/.Xresources ]
then
	xrdb -merge ~/.Xresources
fi

#add compose key
if [ -s ~/.Xmodmap ]
then
	xmodmap ~/.Xmodmap
fi

#urxvt daemon
urxvtd &

#smplayer screenshot tmp dir
if [ ! -d /tmp/smplayer_screenshots ]
then
	mkdir /tmp/smplayer_screenshots
fi

xsetroot -cursor_name left_ptr
compton -b -o 0.8 -r 10 -l -10 -t -10 --backend glx --paint-on-overlay &
ibus-daemon -x &
nitrogen --restore &

exec mate-session
