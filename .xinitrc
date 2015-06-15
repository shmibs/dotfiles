#merge Xresources
if [ -s ~/.Xresources ]
then
	xrdb -merge ~/.Xresources
fi

echo "1" > test

#add compose key
if [ -s ~/.Xmodmap ]
then
	xmodmap ~/.Xmodmap
fi

echo "2" >> test


#input!
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
fcitx &

echo "3" >> test


#clean up sxiv cache
#and ensure necessary EV
#exists
sxiv -c
export XDG_CACHE_HOME=/home/shmibs/.cache

echo "4" >> test


#clear vimtags
#rm ~/.vimtags

echo "5" >> test


#load more fonts
xset +fp /usr/share/fonts/local
xset +fp /usr/share/fonts/misc
xset fp rehash

echo "6" >> test


#infinality settings
export INFINALITY_FT_BRIGHTNESS="-10"
export INFINALITY_FT_FILTER_PARAMS="16 20 28 20 16"

echo "7" >> test


#disable power saving, so screen doesn't power off
xset -dpms
xset s off

echo "8" >> test


#daemons
urxvtd &
compton -b --backend glx --vsync drm

echo "9" >> test


#QT style mimic gtk
#export QT_STYLE_OVERRIDE=gtk

#this is an ugly hack which runs a dummy program
#through bumblebee to get the fans on discrete
#nvidia graphics cards to shut up
command -v optirun && $(echo "" | optirun bar)

echo "10" >> test


xsetroot -cursor_name left_ptr
nitrogen --restore

echo "11" >> test


exec mate-session
