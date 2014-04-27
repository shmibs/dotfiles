#
# /home/shmibs/.bashrc
#

# coloured
# PS1="$(if [[ ${EUID} == 0 ]]; then echo '\033[1;31m'; else echo '\033[1;32m'; fi)\u@\h\033[1;34m[\W]\$\033[0m "

# plain
# PS1='[\u@\h \W]\$ '

# If not running interactively, don't do anything

[[ $- != *i* ]] && return

shopt -s checkwinsize

PS1='[\u@\h \W]\$ '
PS2='> '
PS3='> '
PS4='+ '

case ${TERM} in
  xterm*|rxvt*|Eterm|aterm|kterm|gnome*|mate*)
    PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
    ;;
  screen)
    PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033_%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
    ;;
esac

[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion

export EDITOR="vim"
export PAGER="less -R"

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias diff='colordiff'
alias less='less -R'

alias vmount='udevil mount'
alias vumount='udevil umount'
alias def='sdcv'

send() {
	scp $@ shmibbles.me:/srv/http/tmp/
	for name in "$@"
	do
		echo "http://shmibbles.me/tmp/$(basename $name)" | xclip -i -selection clipboard
	done
}

sendi() {
	scp $@ shmibbles.me:/srv/http/img/
	for name in "$@"
	do
		echo "http://shmibbles.me/img/$(basename $name)" | xclip -i -selection clipboard
	done
}

