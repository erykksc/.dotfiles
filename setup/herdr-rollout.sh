#!/usr/bin/env bash
# Install only this migration, preserving other Stow packages and live panes.
set -euo pipefail
repo=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
cd "$repo"
command -v stow >/dev/null || { echo 'GNU Stow is required' >&2; exit 1; }
HERDR_CONFIG_PATH="$repo/dot-config/herdr/config.toml" herdr config check
backup=$HOME/.config/herdr/backups/$(date +%Y%m%d-%H%M%S)-$$
mkdir -p "$backup" "$HOME/.config/kitty"
herdr_config=$HOME/.config/herdr/config.toml
kitty_config=$HOME/.config/kitty/kitty.conf
moved_herdr=false
moved_kitty=false
restore() {
    if $moved_herdr; then
        rm -f -- "$herdr_config"
        mv -- "$backup/herdr-config.toml" "$herdr_config"
    fi
    if $moved_kitty; then
        rm -f -- "$kitty_config"
        mv -- "$backup/kitty.conf" "$kitty_config"
    fi
}
trap restore ERR
if [[ -e $herdr_config || -L $herdr_config ]]; then
    if [[ $herdr_config -ef $repo/dot-config/herdr/config.toml ]]; then
        cp -Lp -- "$herdr_config" "$backup/herdr-config.toml"
    else
        mv -- "$herdr_config" "$backup/herdr-config.toml"
        moved_herdr=true
    fi
fi
if [[ -e $kitty_config || -L $kitty_config ]]; then
    if [[ $kitty_config -ef $repo/dot-config/kitty/kitty.conf ]]; then
        cp -Lp -- "$kitty_config" "$backup/kitty.conf"
    else
        mv -- "$kitty_config" "$backup/kitty.conf"
        moved_kitty=true
    fi
fi
# Match both original dot-* names and the target names Stow uses recursively.
only_migration='^(?!(?:dot-config|\.config)(?:/(?:herdr(?:/(?:config\.toml|bin(?:/.*)?))?|kitty(?:/kitty\.conf)?))?$).*'
stow --simulate --verbose --target="$HOME" --ignore="$only_migration" .
stow --verbose --target="$HOME" --ignore="$only_migration" .
trap - ERR
printf 'Configuration backups: %s\n' "$backup"
printf 'Reload with: herdr server reload-config\n'
printf 'Reload kitty with: kitten @ --to "${KITTY_LISTEN_ON:-unix:@mykitty}" load-config "%s"\n' "$kitty_config"
