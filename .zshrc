zstyle ':completion:*' completer _complete _ignored 
zstyle :compinstall filename '/home/shmibs/.zshrc'
setopt completealiases

autoload -U compinit
compinit
autoload -U colors
colors

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt HIST_IGNORE_DUPS

# urxvt does visual mode just fine, and i don't compose
# any large strings in a shell, so treating it as always
# insert mode is more sensible
bindkey -e
setopt notify
unsetopt beep

PROMPT="%{%B$fg[white]%}[%{%(!.$fg[red].$fg[magenta])%}%n@%M %{$fg[blue]%}%c%{$fg[white]%}]: %{%b$reset_color%}"

################# KEYBINDINGS #################
typeset -g -A key

key[F1]='^[[11~'
key[F2]='^[[12~'
key[F3]='^[[13~'
key[F4]='^[[14~'
key[F5]='^[[15~'
key[F6]='^[[17~'
key[F7]='^[[18~'
key[F8]='^[[19~'
key[F9]='^[[20~'
key[F10]='^[[21~'
key[F11]='^[[23~'
key[F12]='^[[24~'
key[Backspace]='^?'
key[Insert]='^[[2~'
key[Home]='^[[7~'
key[PageUp]='^[[5~'
key[Delete]='^[[3~'
key[End]='^[[8~'
key[PageDown]='^[[6~'
key[Up]='^[[A'
key[Left]='^[[D'
key[Down]='^[[B'
key[Right]='^[[C'

bindkey ${key[Backspace]} backward-delete-char
bindkey ${key[Insert]}    overwrite-mode
bindkey ${key[Home]}      beginning-of-line
bindkey ${key[Delete]}    delete-char
bindkey ${key[End]}       end-of-line
bindkey ${key[Up]}        up-line-or-search
bindkey ${key[Left]}      backward-char
bindkey ${key[Down]}      down-line-or-search
bindkey ${key[Right]}     forward-char
bindkey ${key[PageUp]}    history-beginning-search-backward
bindkey ${key[PageDown]}  history-beginning-search-forward
bindkey '^W' backward-kill-word
bindkey '^U' backward-kill-line
bindkey '^P' up-history
bindkey '^N' down-history


################### ALIASES ##################
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias diff='colordiff'
alias less='less -R'
alias latex='latex -output-format=pdf'

alias vmount='udevil mount'
alias vumount='udevil umount'
alias def='sdcv'
alias thesaurus='aiksaurus'

export EDITOR="vim"
export PAGER="less -R"

################## FUNCTIONS ##################
send() {
	if [ "$1" ]; then
		scp $@ shmibbles.me:/srv/http/tmp/
		if [ $? -eq 0 ]; then
			for name in "$@"
			do
				name=$(echo "http://shmibbles.me/tmp/$(basename $name)"\
				| sed 's/ /%20/g')
				echo $name | tr -d '\n' | xclip -i -selection clipboard
				echo $name | tr -d '\n' | xclip -i -selection primary
			done
		fi
	else
		echo "specify at least one file to send"
	fi
}

sendi() {
	if [ "$1" ]; then
		scp $@ shmibbles.me:/srv/http/img/
		if [ $? -eq 0 ]; then
			for name in "$@"
			do
				name=$(echo "http://shmibbles.me/img/$(basename $name)"\
				| sed 's/ /%20/g')
				echo $name | tr -d '\n' | xclip -i -selection clipboard
				echo $name | tr -d '\n' | xclip -i -selection primary
			done
		fi
	else
		echo "specify at least one file to send"
	fi
}

ssh-firefox() {
	xpra start ssh:shmibs@shmibbles.me:1 --pulseaudio --exit-with-children --start-child="firefox" 
	# this shouldn't be necessary, but just to make sure
	xpra stop ssh:shmibs@shmibbles.me:1
}