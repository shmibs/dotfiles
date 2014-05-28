#!/bin/bash

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
	if [ "$1" ]; then
		scp $@ shmibbles.me:/srv/http/tmp/
		if [ $? -eq 0 ]; then
			for name in "$@"
			do
				name=$(echo "http://shmibbles.me/tmp/$(basename $name)" | sed 's/ /%20/g')
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
				name=$(echo "http://shmibbles.me/img/$(basename $name)" | sed 's/ /%20/g')
				echo $name | tr -d '\n' | xclip -i -selection clipboard
				echo $name | tr -d '\n' | xclip -i -selection primary
			done
		fi
	else
		echo "specify at least one file to send"
	fi
}

