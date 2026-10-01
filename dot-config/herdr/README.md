# Herdr setup and shortcuts on Linux

Herdr's configuration and helper scripts are managed by this dotfiles repo and
work with Linux terminals that pass the configured key chords through to Herdr.
Requirements: herdr 0.9.3+, Bash, jq, Neovim, lazygit, and GNU Stow. Herdr and
lazygit are listed in Mise; the other tools can be installed with your system
package manager. Terminal notifications preserve the active Herdr setting.

## Quick setup on a new machine

Install Mise, GNU Stow, Bash, jq, and Neovim. Clone the repo, install Herdr and
lazygit from its Mise config, then link the repo:

```sh
git clone git@github.com:erykksc/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
mise install herdr lazygit
stow .
HERDR_CONFIG_PATH="$HOME/.config/herdr/config.toml" herdr config check
```

Start Herdr manually in the directory where you want to work. The tracked
`dot-config/herdr` files provide the Herdr config and helper commands. If this
machine already has a Herdr or Kitty config, use the backup rollout script
below before linking files.

## Optional Kitty shortcuts

Kitty remains optional. Its companion config forwards selected physical key
chords that Kitty would otherwise consume. With another terminal, Herdr's
configured prefix bindings remain available; terminal-specific forwarding and
shortcuts such as PageUp/PageDown may need equivalent mappings in that terminal.
The Kitty config is included when running the repo-wide `stow .` workflow.

`P` means either Ctrl+B or Ctrl+Space. Unlisted herdr bindings inherit their
defaults. The config uses `prefix = "ctrl+b"` plus `extra_prefixes = ["ctrl+space"]`,
the compatibility spelling accepted by herdr 0.9.3. It lets the running 0.9.1
server read the config while the 0.9.3 client handles both prefixes. The older
server may report that it ignores `keys.extra_prefixes`; the client still uses it. The first column below retains every modified native default.

| Action | Herdr default | Added shortcut |
| --- | --- | --- |
| Side-by-side split | P v | P % |
| Stacked split | P - | P " |
| Rename tab | P Shift+T | P , |
| Detach | P q | P d |
| Close tab | P Shift+X | P & |
| New tab | P c | Ctrl+Shift+T |
| Previous / next tab | P p / P n | Ctrl+PageUp / Ctrl+PageDown |
| Tab 1–9 | P 1–9 | Alt+1–9 |
| Agent 1–9 | Unbound | Ctrl+1–9 |
| Reorder tab backward / forward | Unbound | Ctrl+Shift+PageUp / Ctrl+Shift+PageDown |
| Focus left / down / up / right | P h/j/k/l | P Left/Down/Up/Right; Alt+H/J/K/L |
| Swap left / down / up / right | P Shift+H/J/K/L | Alt+Shift+H/J/K/L |
| Close pane | P x | Ctrl+Shift+W |
| Focus/create lazygit tab | Unbound | Alt+G |
| New dotfiles Neovim tab | Unbound | Ctrl+Shift+. |
| Move pane to new/existing tab | Unbound | P ! |

Herdr 0.9.3 does not parse PageUp/PageDown key names. The four kitty `send_key`
mappings translate those physical shortcuts to Ctrl+Alt+Left/Right and
Ctrl+Alt+Shift+Left/Right, which herdr handles as native tab actions. The active
help shows those translated chords. Herdr 0.9.3 omits swap actions from help;
those bindings are validated by config checks and live swapping tests. All other migrated kitty mappings are
removed or explicitly disabled to prevent built-in actions from taking them.
This compatibility exception was chosen instead of changing upstream herdr.

Alt navigation inspects the originating pane's foreground processes. In Neovim,
it forwards the chord so the existing `smart-splits.nvim` mappings navigate
editor splits first, then herdr panes, and stop at the outer edge. Native prefix
navigation always goes directly to herdr. Empty or failed inspection and missing
neighbors forward the key to the originating application. Helpers require the
binary, socket, and active-pane context supplied by herdr; failures print a
`herdr shortcut:` diagnostic. Detached command errors may appear in server
output/logs; run a helper from a shell with the same supplied context to diagnose.

Alt+G focuses the first exact-title `lazygit` tab in the originating workspace.
Otherwise it creates one in the originating pane's directory. Ctrl+Shift+.
always creates a `dotfiles` tab in `$HOME/.dotfiles`. Applications run only in
the new pane's interactive shell; quitting returns to that shell. New tabs
inherit the source directory and open without a naming prompt.

Zoom (P z), pane cycling (P Tab / P Shift+Tab), copy mode (P [), scrollback
editing in Neovim (P e), help (P ?), resizing, and other workspace controls remain
inherited. Ctrl+1–9 focuses agents by index; Alt+1–9 switches tabs within the
current workspace. Use copy mode for pane history; kitty's Ctrl+Shift+U/D history
scrolling and custom copy-hint sequences are retired. Normal Ctrl+Shift+C/V
clipboard access, font controls, appearance, and Ctrl+Shift+Q stay in kitty.
Project layouts and project launchers remain outside this migration.

In workspace navigation mode (P w), use Up/Down or k/j to move the selection.

P l is still focus-right, P o still opens the notification target, and P q still
detaches. No last-tab, pane-cycle, or pane-number aliases replace these defaults.
Layout cycling remains omitted.

P ! opens a small popup listing the originating workspace’s tabs in their current
order, numbered consecutively from 1 each time it opens. These menu numbers are
independent of herdr’s stable tab numbers.
Press `c` to move the originating pane into a new tab, or a tab’s number to
join it beside that tab’s focused pane. The current tab is marked and cannot be
selected as a destination. Press Esc or `q` to cancel. Single-digit choices act
immediately unless they are also the start of a larger tab number; in that case,
finish typing the number or press Enter to confirm. Use `[` / `]` to page
through longer lists. The move preserves the
running process and focuses its destination. Unzoom source/destination tabs
before moving.

## Setup and reload

For a clean install, link the repo with `stow .`, then check the config and
helper scripts from the repository:

```sh
bash -n dot-config/herdr/bin/context.bash dot-config/herdr/bin/herdr-navigate dot-config/herdr/bin/herdr-tab-launcher dot-config/herdr/bin/herdr-move-pane
HERDR_CONFIG_PATH="$PWD/dot-config/herdr/config.toml" herdr config check
python3 scripts/tests/test_herdr_helpers.py
kitty +runpy 'import runpy; runpy.run_path("scripts/tests/check_kitty_forwarding.py", run_name="__main__")'
```

For an existing machine with configs to preserve, run
`bash setup/herdr-rollout.sh` instead of `stow .`. It backs up existing Herdr and
Kitty configs under `~/.config/herdr/backups/<timestamp>/`, then stows the
Herdr files and Kitty companion config. Helpers live in `bin` because `.stowrc`
ignores directories named `scripts`. After setup, reload the Herdr config with
`herdr server reload-config`. When using Kitty, reload its config with:

```sh
kitten @ --to "${KITTY_LISTEN_ON:-unix:@mykitty}" load-config "$HOME/.config/kitty/kitty.conf"
```

No server restart is needed. If another Kitty instance has a different socket,
use its `KITTY_LISTEN_ON` value or reload that instance with Ctrl+Shift+F5. In
Herdr, use the UI's reload action (P Shift+R) too, so the client restores its
local keybindings.

For a manual isolated check, run `herdr --session dotfiles-shortcuts-test` in a
fresh kitty window. Exercise both prefixes, split orientation, arrows/Alt
navigation, swapping, Alt+1–9, tab ordering, inherited directories, repeated
Alt+G, and Neovim internal/boundary navigation. Put distinct history in two
panes and confirm P [ selects the focused pane's history. Detach with P d and
reattach to the same session; running applications must remain alive. Stop only
this test session after validation.

## Rollback

Choose the backup directory printed by the rollout script. Restore the backed-up
contents into the managed repository files, which safely handles both individual
file links and kitty's existing Stow directory link:

```sh
backup="$HOME/.config/herdr/backups/<timestamp>"
kitty_backup="$backup/kitty.conf"
# This rollout also saved kitty's original configuration before the migration.
[ ! -f "$backup/kitty-pre-migration.conf" ] || kitty_backup="$backup/kitty-pre-migration.conf"
cp -L "$backup/herdr-config.toml" "$HOME/.dotfiles/dot-config/herdr/config.toml"
cp -L "$kitty_backup" "$HOME/.dotfiles/dot-config/kitty/kitty.conf"
herdr server reload-config
kitten @ --to "${KITTY_LISTEN_ON:-unix:@mykitty}" load-config "$HOME/.config/kitty/kitty.conf"
```

Use herdr's UI reload action (P Shift+R) too, so the client restores its local
keybindings. If a config did not exist before rollout, remove its managed link
instead. The helper link can remain unused. Do not remove a file through a
Stow directory link: that removes the repository source too. Rollback does not
stop herdr or its pane processes.

Configuration semantics and custom-command context:
[herdr configuration](https://herdr.dev/docs/configuration/),
[config reference](https://herdr.dev/docs/config-reference/).
