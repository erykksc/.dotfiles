#!/usr/bin/env bash

APP_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/applications"

shopt -s nullglob
projects=("$HOME"/dev/*/)

desktop-escape() {
	local value="$1"
	value=${value//\\/\\\\}
	value=${value//$'\n'/\\n}
	value=${value//$'\r'/\\r}
	value=${value//$'\t'/\\t}
	printf '%s' "$value"
}

desktop-exec-arg() {
	local value="$1"
	value=${value//\\/\\\\}
	value=${value//\"/\\\"}
	value=${value//\`/\\\`}
	value=${value//\$/\\\$}
	value=${value//%/%%}
	printf '"%s"' "$value"
}

desktop-content() {
	local projectPath="$1"
	local projectName
	local definedSession
	projectName=$(basename "$projectPath")

	definedSession=$(find "$HOME/.dotfiles/dot-config/kitty/sessions/" -type f -name "$projectName.kitty-session" -print -quit)

	if [ -z "$definedSession" ]; then
		definedSession="$HOME/.dotfiles/dot-config/kitty/sessions/generic.kitty-session"
	fi

	printf '%s\n' \
		'[Desktop Entry]' \
		'Type=Application' \
		"Name=$(desktop-escape "$projectName")" \
		"Exec=kitty --detach --directory $(desktop-exec-arg "$projectPath") --session $(desktop-exec-arg "$definedSession")" \
		'Icon=kitty' \
		'Terminal=false' \
		'Categories=System;TerminalEmulator;' \
		'TryExec=kitty' \
		'X-Kitty-Session-Managed=true' \
		"X-Kitty-Session-Path=$(desktop-escape "$definedSession")"
}

mkdir -p "$APP_DIR"
deletedCount=$(find "$APP_DIR" -type f -name "auto-kitty-session*" -printf . | wc -c)
find "$APP_DIR" -type f -name "auto-kitty-session*" -delete
echo "Deleted $deletedCount old auto kitty sessions"

createdCount=0
for project in "${projects[@]}"; do
	pname=$(basename "$project")
	desktopFilepath="$APP_DIR/auto-kitty-session_$pname.desktop"
	desktop-content "$project" >"$desktopFilepath"
	echo "Created $desktopFilepath"
	createdCount=$((createdCount + 1))
done
echo "Created $createdCount new desktop project files"

# force update of desktop entries by DE
update-desktop-database ~/.local/share/applications
