"""Run with: kitty +runpy scripts/tests/check_kitty_forwarding.py"""
from pathlib import Path
from kitty.config import load_config
from kitty.options.utils import parse_shortcut

config = Path(__file__).resolve().parents[2] / 'dot-config/kitty/kitty.conf'
bad = []
opts = load_config(str(config), accumulate_bad_lines=bad)
assert not bad, bad
keymap = opts.keyboard_modes[''].keymap
forwarded = ['ctrl+space', 'ctrl+b', 'ctrl+shift+t', 'ctrl+shift+w', 'ctrl+shift+.', 'alt+g']
forwarded += ['alt+' + k for k in 'hjkl123456789']
forwarded += ['alt+shift+' + k for k in 'hjkl']
forwarded += ['ctrl+shift+u', 'ctrl+shift+d']
for key in forwarded:
    effective = keymap.get(parse_shortcut(key), [])
    assert not effective or effective[-1].definition == '', (key, effective)
    assert not any(d.is_sequence or d.options.when_focus_on for d in effective), key
translations = {
    'ctrl+page_up': 'ctrl+alt+left', 'ctrl+page_down': 'ctrl+alt+right',
    'ctrl+shift+page_up': 'ctrl+alt+shift+left', 'ctrl+shift+page_down': 'ctrl+alt+shift+right',
}
for key, target in translations.items():
    assert keymap[parse_shortcut(key)][-1].definition == 'send_key ' + target, key
for key, action in [('ctrl+shift+c','copy_to_clipboard'),('ctrl+shift+v','paste_from_clipboard')]:
    assert keymap[parse_shortcut(key)][-1].definition == action, key
assert 'kitty-graceful-close' in keymap[parse_shortcut('ctrl+shift+q')][-1].definition
assert keymap[parse_shortcut('ctrl+shift+0')][-1].definition == 'change_font_size all 0'
print('kitty effective mappings: all migrated keys forward; clipboard/font/close mappings preserved')
