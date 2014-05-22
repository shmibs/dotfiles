#!/bin/bash
file=$(xoris)
echo "$file" | tr -d '\n' | xclip -selection clipboard
echo "$file" | tr -d '\n' | xclip -selection primary
