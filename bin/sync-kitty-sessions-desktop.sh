#!/usr/bin/env bash
set -euo pipefail

APP_PREFIX="kitty-session-"
APP_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/applications"
MAX_DEPTH=6
DRY_RUN=0
VERBOSE=0
declare -a SEARCH_ROOTS=(
  "$HOME/.config"
  "$HOME/.dotfiles"
  "$HOME/dev"
)

usage() {
  printf 'Usage: %s [--dry-run] [--verbose]\n' "${0##*/}"
}

log() {
  if ((VERBOSE)); then
    printf '%s\n' "$*"
  fi
}

say() {
  printf '%s\n' "$*"
}

while (($#)); do
  case "$1" in
  --dry-run)
    DRY_RUN=1
    ;;
  --verbose)
    VERBOSE=1
    ;;
  -h | --help)
    usage
    exit 0
    ;;
  *)
    usage >&2
    exit 2
    ;;
  esac
  shift
done

desktop_value_escape() {
  local value=$1
  value=${value//\\/\\\\}
  value=${value//$'\n'/ }
  printf '%s' "$value"
}

exec_arg_escape() {
  local value=$1
  value=${value//\\/\\\\}
  value=${value//\"/\\\"}
  value=${value//$'\n'/ }
  printf '"%s"' "$value"
}

session_name() {
  local basename=${1##*/}
  printf '%s' "${basename%.kitty-session}"
}

relative_parent() {
  local path=$1 parent rel
  parent=${path%/*}
  rel=$parent
  if [[ $parent == "$HOME" ]]; then
    rel="~"
  elif [[ $parent == "$HOME"/* ]]; then
    rel=${parent#"$HOME"/}
  fi
  printf '%s' "$rel"
}

session_hash() {
  printf '%s' "$1" | sha256sum | cut -d ' ' -f 1
}

desktop_file_for_session() {
  local hash
  hash=$(session_hash "$1")
  printf '%s/%s%s.desktop' "$APP_DIR" "$APP_PREFIX" "${hash:0:16}"
}

desktop_content() {
  local session=$1 name=$2 escaped_name escaped_path quoted_session
  escaped_name=$(desktop_value_escape "$name")
  escaped_path=$(desktop_value_escape "$session")
  quoted_session=$(exec_arg_escape "$session")

  printf '%s\n' \
    '[Desktop Entry]' \
    'Type=Application' \
    "Name=$escaped_name" \
    "Exec=kitty --detach --session $quoted_session" \
    'Icon=kitty' \
    'Terminal=false' \
    'Categories=System;TerminalEmulator;' \
    'TryExec=kitty' \
    'X-Kitty-Session-Managed=true' \
    "X-Kitty-Session-Path=$escaped_path"
}

read_desktop_value() {
  local key=$1 file=$2 line
  while IFS= read -r line; do
    if [[ $line == "$key="* ]]; then
      printf '%s' "${line#*=}"
      return 0
    fi
  done <"$file"
  return 1
}

is_managed_entry() {
  local file=$1 value
  value=$(read_desktop_value 'X-Kitty-Session-Managed' "$file" || true)
  [[ $value == true ]]
}

declare -a sessions=()
declare -A name_counts=()
declare -A expected_files=()

for root in "${SEARCH_ROOTS[@]}"; do
  if [[ ! -d $root ]]; then
    log "Skipping missing root: $root"
    continue
  fi

  while IFS= read -r -d '' session; do
    sessions+=("$session")
    name_counts["$(session_name "$session")"]=$((${name_counts["$(session_name "$session")"]:-0} + 1))
  done < <(find "$root" -maxdepth "$MAX_DEPTH" -type f -name '*.kitty-session' -print0 2>/dev/null | sort -z)
done

if ((!DRY_RUN)); then
  mkdir -p "$APP_DIR"
fi

created=0
updated=0
unchanged=0
removed=0

for session in "${sessions[@]}"; do
  base_name=$(session_name "$session")
  display_name=$base_name
  if ((${name_counts[$base_name]} > 1)); then
    display_name="$base_name ($(relative_parent "$session"))"
  fi

  desktop_file=$(desktop_file_for_session "$session")
  expected_files["$desktop_file"]=1
  content=$(desktop_content "$session" "$display_name")

  if [[ -f $desktop_file ]] && cmp -s <(printf '%s\n' "$content") "$desktop_file"; then
    unchanged=$((unchanged + 1))
    log "Unchanged: $desktop_file"
    continue
  fi

  if [[ -f $desktop_file ]]; then
    updated=$((updated + 1))
    say "Update: $desktop_file ($display_name)"
  else
    created=$((created + 1))
    say "Create: $desktop_file ($display_name)"
  fi

  if ((!DRY_RUN)); then
    tmp=$(mktemp "$APP_DIR/.${APP_PREFIX}XXXXXX")
    printf '%s\n' "$content" >"$tmp"
    chmod 0644 "$tmp"
    mv "$tmp" "$desktop_file"
  fi
done

shopt -s nullglob
for desktop_file in "$APP_DIR"/${APP_PREFIX}*.desktop; do
  if ! is_managed_entry "$desktop_file"; then
    log "Skipping unmanaged entry: $desktop_file"
    continue
  fi

  session_path=$(read_desktop_value 'X-Kitty-Session-Path' "$desktop_file" || true)
  if [[ ! -f $session_path || -z ${expected_files[$desktop_file]:-} ]]; then
    stale_name=$(read_desktop_value 'Name' "$desktop_file" || true)
    removed=$((removed + 1))
    say "Remove stale: $desktop_file ($stale_name)"
    if ((!DRY_RUN)); then
      rm -f -- "$desktop_file"
    fi
  fi
done
shopt -u nullglob

if ((!DRY_RUN)) && ((created + updated + removed > 0)) && command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database "$APP_DIR" >/dev/null 2>&1 || true
fi

say "Sessions found: ${#sessions[@]}"
say "Created: $created, updated: $updated, unchanged: $unchanged, removed: $removed"
