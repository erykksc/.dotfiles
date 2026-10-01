# Shared by detached keybinding helpers; never default to another session.
set -euo pipefail
fail() { printf 'herdr shortcut: %s\n' "$*" >&2; exit 1; }
[[ -n ${HERDR_BIN_PATH:-} && -x $HERDR_BIN_PATH ]] || fail 'missing executable HERDR_BIN_PATH'
[[ -n ${HERDR_SOCKET_PATH:-} ]] || fail 'missing HERDR_SOCKET_PATH'
[[ -n ${HERDR_ACTIVE_PANE_ID:-} ]] || fail 'missing originating HERDR_ACTIVE_PANE_ID'
command -v jq >/dev/null || fail 'jq is required'
source_pane=$HERDR_ACTIVE_PANE_ID
herdr_cli() { "$HERDR_BIN_PATH" "$@"; }
