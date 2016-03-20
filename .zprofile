emulate sh -c 'source /etc/profile'

export QT_STYLE_OVERRIDE=gtk

########## MAKE USER FUNCS AVAILABLE ##########
[[ -d ~/.config/init/funcs/ ]] && \
	PATH="$PATH:$HOME/.config/init/funcs"

############# CONNECTING OVER SSH #############
[[ -f ~/.zprofile-dtach ]] && \
	source ~/.zprofile-dtach
