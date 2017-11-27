#!/usr/bin/env zsh

source $HOME/.config/init/vars

for f in $HOME/.config/init/gen/*; do
	source "$f"
done
