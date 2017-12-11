#!/bin/zsh
file=$(grabc 2>/dev/null)
echo "$file" | tr -d '\n' | xclip -selection clipboard
echo "$file" | tr -d '\n' | xclip -selection primary
