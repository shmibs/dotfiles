#initialise configs to auto-match theme
~/.config/init/init.sh

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

#clean up sxiv cache
#and ensure necessary EV
#exists
sxiv -c
export XDG_CACHE_HOME=/home/shmibs/.cache

#clear vimtags
#rm ~/.vimtags

#load more fonts
xset +fp /usr/share/fonts/local
xset +fp /usr/share/fonts/misc
xset fp rehash

#infinality settings
export INFINALITY_FT_BRIGHTNESS="-10"
export INFINALITY_FT_FILTER_PARAMS="16 20 28 20 16"

#disable power saving, so screen doesn't power off
xset -dpms
xset s off

#daemons
urxvtd &
compton -b --backend glx --vsync opengl

#QT style mimic gtk
#export QT_STYLE_OVERRIDE=gtk

#this is an ugly hack which runs a dummy program
#through bumblebee to get the fans on discrete
#nvidia graphics cards to shut up
command -v optirun && $(echo "" | optirun lemonbar)

xsetroot -cursor_name left_ptr
nitrogen --restore

exec mate-session
