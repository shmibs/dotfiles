[[ -f /etc/profile ]] && \
	emulate sh -c 'source /etc/profile'

################## SET EDITOR #################
if [[ ! -z $(whence nvim) ]] then
	export EDITOR=nvim
elif [[ ! -z $(whence vim) ]] then
	export EDITOR=vim
elif [[ ! -z $(whence vi) ]] then
	export EDITOR=vi
fi

############# STORE VIMTAGS IN TMP ############
export QT_STYLE_OVERRIDE=gtk

############# STORE VIMTAGS IN TMP ############
[[ -d /tmp/ ]] && \
	touch /tmp/.vimtags && ln -sf /tmp/.vimtags .

############# INITIALISE CONFIGS ##############
[[ -f ~/.config/init/init.sh ]] && \
	~/.config/init/init.sh

########## MAKE USER FUNCS AVAILABLE ##########
func_init_checkreq() {
	local func_init_state=0
	for e in "$@"; do
		if [[ $func_init_state -eq 0 ]]; then
			if [[ "$e" == ',' ]]; then
				func_init_state=1
			else
				whence $e >/dev/null
				[[ $? -eq 0 ]] || return 1
			fi
		else
			local cmd
			echo "$e" | read -A cmd
			$cmd 2>/dev/null 1>&2
			[[ $? -eq 0 ]] || return 1
		fi
	done
	return 0
}

if [[ -d $HOME/.config/init/funcs/ && -d $HOME/.config/init/funcreqs ]]; then
	rm -rf /tmp/funcs
	mkdir -p /tmp/funcs
	path+=(/tmp/funcs)
	for f in $HOME/.config/init/funcreqs/*; do
		source "$f"
		func_init_checkreq $func_init_prereqs , $func_init_checks
		if [[ $? -eq 0 ]] then
			chmod +x $HOME/.config/init/funcs/${f:t}
			ln -s $HOME/.config/init/funcs/${f:t} /tmp/funcs/${f:t}
		fi
	done
fi

############# CONNECTING OVER SSH #############
[[ -f $HOME/.zprofile-dtach ]] && \
	source $HOME/.zprofile-dtach

export PATH
