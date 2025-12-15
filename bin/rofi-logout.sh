#!/usr/bin/env bash

set -euo pipefail

options=(
	'lock'
	'hibernate'
	'logout'
	'shutdown'
	'suspend'
	'reboot'
)

action=$(printf '%s\n' "${options[@]}" | rofi -dmenu)

case "$action" in
'lock')
	swaylock \
		--screenshots \
		--clock \
		--indicator \
		--indicator-radius 100 \
		--indicator-thickness 7 \
		--effect-blur 7x5 \
		--effect-vignette 0.5:0.5 \
		--ring-color bb00cc \
		--key-hl-color 880033 \
		--line-color 00000000 \
		--inside-color 00000088 \
		--separator-color 00000000 \
		--fade-in 0.2
	;;
'hibernate')
	systemctl hibernate
	;;
'logout')
	loginctl terminate-user $USER
	;;
'shutdown')
	systemctl poweroff
	;;
'suspend')
	systemctl suspend
	;;
'reboot')
	echo 'rebooting...'
	systemctl reboot
	;;
*)
	echo "unknown action: '$action'"
	exit 1
	;;
esac
