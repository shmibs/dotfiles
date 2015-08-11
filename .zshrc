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

#################### PROMPT ###################
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


################# HIGHLIGHTING ################
if [[ -f '/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' ]]; then
	source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
else
	source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)

#ZSH_HIGHLIGHT_STYLES[alias]="fg=yellow"
#ZSH_HIGHLIGHT_STYLES[builtin]="fg=yellow"
#ZSH_HIGHLIGHT_STYLES[function]="fg=yellow"
#ZSH_HIGHLIGHT_STYLES[command]="fg=yellow"

ZSH_HIGHLIGHT_STYLES[single-quoted-argument]="fg=red"
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]="fg=red"

# highlight comments
ZSH_HIGHLIGHT_PATTERNS+=('\#*' 'fg=cyan')

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

################# OS SPECIFIC #################
case $(uname) in 
	FreeBSD)
		source ~/.zshrc-freebsd
		;;
	Linux)
		source ~/.zshrc-linux
		;;
	*)
		echo -e '[-- OS UNRECOGNISED --]'
esac
