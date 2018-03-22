#!/bin/zsh
stint 2>/dev/null | xargs -n3 printf '#%02x%02x%02x\n' | tr -d '\n'|
	tee >(xclip -i -selection clipboard) | xclip -i -selection primary
