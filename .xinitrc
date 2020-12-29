#pull inna vars
source "$HOME/.config/init/vars"

#merge Xresources
if [ -s "$HOME/.Xresources" ]
then
	xrdb -override "$HOME/.Xresources"
fi

if [ -s $tmpdir/x-theme ]
then
	xrdb -override $tmpdir/x-theme
fi

#add compose key
setxkbmap -option compose:caps

#input!
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export SDL_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
fcitx5 &

#keyrate
xset r rate $kbdelay $kbrate

#store sxiv cache in ram
export XDG_CACHE_HOME="$HOME/.cache"
mkdir -p "$HOME/.cache"
if [ -d $tmpdir ]; then
    mkdir -p $tmpdir/sxiv
    cd "$HOME/.cache/"
    ln -sf $tmpdir/sxiv .
    cd
fi

#load more fonts
xset +fp /usr/share/fonts/local
xset +fp /usr/share/fonts/misc
xset +fp "$HOME/.fonts"
xset fp rehash

#disable power saving, so screen doesn't power off
xset -dpms
xset s off

#daemons
picom -b --backend glx --vsync -CG

xsetroot -cursor_name left_ptr
nitrogen --restore
xbanish &

redshift -b 0.8:0.6 -t 5400K:4400K &

exec herbstluftwm
