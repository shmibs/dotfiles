emulate sh -c 'source /etc/profile'

export QT_STYLE_OVERRIDE=gtk

############# CONNECTING OVER SSH #############
if [[ -a ~/.zprofile-dtach ]]; then
	source ~/.zprofile-dtach
fi
