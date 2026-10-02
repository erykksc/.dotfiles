# Shared by detached keybinding helpers; never default to another session.
set -euo pipefail
fail() { printf 'herdr shortcut: %s\n' "$*" >&2; exit 1; }
command -v mise >/dev/null || fail 'mise is required to resolve herdr'
# Resolve afresh after upgrades, using home config without changing helper cwd.
HERDR_BIN_PATH=$(mise -C "$HOME" which herdr) || fail 'mise could not resolve herdr from home configuration'
[[ -n $HERDR_BIN_PATH ]] || fail 'mise returned an empty herdr executable path'
[[ -f $HERDR_BIN_PATH && -x $HERDR_BIN_PATH ]] || fail "mise resolved an unavailable herdr executable: $HERDR_BIN_PATH"
export HERDR_BIN_PATH
[[ -n ${HERDR_SOCKET_PATH:-} ]] || fail 'missing HERDR_SOCKET_PATH'
[[ -n ${HERDR_ACTIVE_PANE_ID:-} ]] || fail 'missing originating HERDR_ACTIVE_PANE_ID'
command -v jq >/dev/null || fail 'jq is required'
source_pane=$HERDR_ACTIVE_PANE_ID
herdr_cli() { "$HERDR_BIN_PATH" "$@"; }
