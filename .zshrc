zstyle ':completion:*' completer _complete _ignored 
zstyle :compinstall filename '~/.zshrc'
setopt completealiases
setopt interactivecomments

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

if [[ "$TERM" == "rxvt-unicode-256color" ]]; then
	if [[ -f "$HOME/.config/init/vars" ]]; then
		source "$HOME/.config/init/vars"
	else
		[[ -f "/home/shmibs/.config/init/vars" ]] &&
			source "/home/shmibs/.config/init/vars"
	fi
fi

##################### MISC ####################

# dynamic title
if [[ "$TERM" == "rxvt-unicode-256color" ]]; then

	precmd() {
		print -Pn "\e]0;zsh:%(1j,%j job%(2j|s|); ,)%~\a"
	}

	preexec() {
		printf "\033]0;%s\a" "$1"
	}

fi

#################### PROMPT ###################
if [[ -n $light_colours ]]; then
PROMPT="%{$fg[black]%}┌["
# if non-zero, previous return val
PROMPT+="%(0?..$fg[red]%?$fg[black]:)"
# if any, number of jobs
PROMPT+="%(1j.$fg[green]%j$fg[black]:.)"
# name and host (red for root)
PROMPT+="%{%(!.$fg[red].$fg[magenta])%}%n@%M%E "
# current location, with one level of parent context
PROMPT+="%{$fg[blue]%}%2c"
# newline
PROMPT+="%{$fg[black]%}]%{%b$reset_color%}
"
PROMPT+="%{$fg[black]%}└: %{%b$reset_color%}"
else
PROMPT="%{%B$fg[white]%}┌["
# if non-zero, previous return val
PROMPT+="%(0?..$fg[red]%?$fg[white]:)"
# if any, number of jobs
PROMPT+="%(1j.$fg[green]%j$fg[white]:.)"
# name and host (red for root)
PROMPT+="%{%(!.$fg[red].$fg[magenta])%}%n@%M%E "
# current location, with one level of parent context
PROMPT+="%{$fg[blue]%}%2c"
# newline
PROMPT+="%{$fg[white]%}]%{%b$reset_color%}
"
PROMPT+="%{%B$fg[white]%}└: %{%b$reset_color%}"
fi


################# HIGHLIGHTING ################
local HIGHLIGHT_DIR='~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'
[[ -f '/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' ]] && \
	HIGHLIGHT_DIR='/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'
[[ -f '/usr/local/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' ]] && \
	HIGHLIGHT_DIR='/usr/local/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'

source $HIGHLIGHT_DIR

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)

#ZSH_HIGHLIGHT_STYLES[alias]="fg=yellow"
#ZSH_HIGHLIGHT_STYLES[builtin]="fg=yellow"
#ZSH_HIGHLIGHT_STYLES[function]="fg=yellow"
#ZSH_HIGHLIGHT_STYLES[command]="fg=yellow"

ZSH_HIGHLIGHT_STYLES[single-quoted-argument]="fg=red"
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]="fg=red"


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

alias :q='exit'

if [[ ! -z $(whence vim) ]] then
	export EDITOR='vim'
	alias svim='sudo -E vim'
	alias svimdiff='sudo -E vim -d'
fi

if [[ ! -z $(whence nvim) ]] then
	alias svim='sudo -E nvim'
	alias svimdiff='sudo -E nvim -d'
	alias vim='nvim'
	export EDITOR='nvim'
fi

[[ ! -z $(whence sdcv) ]] && alias def='sdcv'
[[ ! -z $(whence mpv) ]] && alias dvd='mpv --deinterlace=yes dvd://'
[[ ! -z $(whence herbstclient) ]] && alias hc='herbstclient'
[[ ! -z $(whence aiksaurus) ]] && alias thesaurus='aiksaurus'
[[ ! -z $(whence ag) ]] && alias ag='ag --color-match "1;34"'
[[ ! -z $(whence latex) ]] && alias latex='latex -output-format=pdf'
[[ ! -z $(whence startx) ]] && alias sx='startx'

if [[ ! -z $(whence udevil) ]] then
	alias vmount='udevil mount'
	alias vumount='udevil umount'
fi

################## FUNCTIONS ##################

# ignore non-tracked files
if [[ ! -z $(whence git) ]] then
git() {
	case $1 in
		status) shift; $(whence -p git) status -uno "$@" ;;
		pull) shift; $(whence -p git) pull --recurse-submodules "$@" ;;
		*) $(whence -p git) "$@" ;;
	esac
}
fi

################# OS SPECIFIC #################

case $(uname) in 
	FreeBSD)
		source ~/.zshrc-freebsd
		;;
	Linux)
		source ~/.zshrc-linux
		if [[ -e ~/.zshrc-linux-desktop ]]; then
			source ~/.zshrc-linux-desktop
		fi
		;;
	*)
		echo -e '[-- OS UNRECOGNISED (T_T) --]'
esac
