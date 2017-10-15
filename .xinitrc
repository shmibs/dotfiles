#initialise configs to auto-match theme
# ~/.config/init/init.sh

#pull inna vars
source ~/.config/init/vars

#merge Xresources
if [ -s ~/.Xresources ]
then
	xrdb -override ~/.Xresources
fi

if [ -s /tmp/urxvt-theme ]
then
	xrdb -override /tmp/urxvt-theme
fi

#add compose key
# if [ -s ~/.Xmodmap ]
# then
# 	xmodmap ~/.Xmodmap
# fi
setxkbmap -option compose:caps

#input!
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
fcitx &

#keyrate
xset r rate $kbdelay $kbrate

#store sxiv cache in ram
export XDG_CACHE_HOME=/home/shmibs/.cache
if [ -d /tmp/ ]; then
    mkdir -p /tmp/sxiv
    cd /home/shmibs/.cache/
    ln -sf /tmp/sxiv .
    cd
fi

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
compton -b --backend glx --vsync opengl

#QT style mimic gtk
#export QT_STYLE_OVERRIDE=gtk

#this is an ugly hack which runs a dummy program
#through bumblebee to get the fans on discrete
#nvidia graphics cards to shut up
command -v optirun && $(echo "" | optirun lemonbar)

xsetroot -cursor_name left_ptr
nitrogen --restore

exec herbstluftwm
