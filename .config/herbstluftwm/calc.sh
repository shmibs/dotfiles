#!/bin/bash

acc=0
in="first"
prompt="calc:"
pi="3.1415926535897932384626433832795028841971694"
e="2.7182818284590452353602874713526624977572471"
while [ "$in" != "" ]; do
	in=$(echo "" | dmenu -q -h 18 -nb $1 -nf $2 -sb $3 -sf $4 -p "$prompt")

	out=$(echo "pi=$pi; e=$e; $acc $in" | calc -p 2>&1 | tr -d "\n")
	
	if [ "$out" = "Missing operator" ]; then
		out=$(echo "pi=$pi; e=$e; $in" | calc -p 2>&1)
	fi

	# check for error output
	if [ "${?#0}" != "" ]; then
		out=$(echo "$out" | tr -d "\n")
		prompt="calc: ($acc) err: $out"
	else
		acc=$out
		prompt="calc: ($acc)"
	fi
done

