#!/usr/bin/env zsh

# Print all hyper key keybinds
jq '.profiles
	| .[]
	| .complex_modifications.rules
	| .[]
	| select(.description | contains("open") and contains("Meh"))
	| .manipulators 
	| .[] 
	| "\(.from.key_code),\(.to.[0].shell_command)"' ~/.config/karabiner/karabiner.json \
	| sed 's/"//g' \
	| sed 's/open /,/g' \
	| sed 's/^/Meh + /' \
	| column -ts ,

jq '.profiles
	| .[]
	| .complex_modifications.rules
	| .[]
	| select(.description | contains("open") and contains("Hyper"))
	| .manipulators 
	| .[] 
	| "\(.from.key_code),\(.to.[0].shell_command)"' ~/.config/karabiner/karabiner.json \
	| sed 's/"//g' \
	| sed 's/open /,/g' \
	| sed 's/^/Hyper + /' \
	| column -ts ,
