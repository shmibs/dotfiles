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
[[ -n "${key[PageUp]}"   ]] && bindkey  "${key[PageUp]}"    history-beginning-search-backward
[[ -n "${key[PageDown]}" ]] && bindkey  "${key[PageDown]}"  history-beginning-search-forward

# urxvt does visual mode just fine, and i don't compose
# any large strings in a shell, so treating it as always
# insert mode is more sensible
bindkey -e
setopt notify
unsetopt beep
#%(?..%{$fg[red]%}[e]%{$fg[white]%})
PROMPT="%{%B$fg[white]%}[%{%(!.$fg[red].$fg[magenta])%}%n@%M %{$fg[blue]%}%~%{$fg[white]%}]: %{%b$reset_color%}"

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias diff='colordiff'
alias less='less -R'

alias vmount='udevil mount'
alias vumount='udevil umount'
alias def='sdcv'

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

