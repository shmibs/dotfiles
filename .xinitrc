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

#input!
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
fcitx &

#urxvt daemon
urxvtd &

#smplayer screenshot tmp dir
if [ ! -d /tmp/smplayer_screenshots ]
then
	mkdir /tmp/smplayer_screenshots
fi

xsetroot -cursor_name left_ptr
compton -b --backend glx --vsync opengl &
#ibus-daemon -x &
nitrogen --restore &

exec mate-session
