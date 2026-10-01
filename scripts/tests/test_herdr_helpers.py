"""Focused CLI contract tests; no live sessions or user processes are touched."""
import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest

SCRIPTS = Path(__file__).resolve().parents[2] / 'dot-config/herdr/bin'
MOCK = '''#!/usr/bin/python3
import json, os, sys
args=sys.argv[1:]
with open(os.environ['CALLS'], 'a') as f:
    f.write(json.dumps({'args':args, 'socket':os.environ.get('HERDR_SOCKET_PATH')})+'\\n')
operation=' '.join(args[:2])
if operation == os.environ.get('FAIL'):
    print('mock server failure',file=sys.stderr); sys.exit(1)
responses=json.loads(os.environ['RESPONSES'])
print(json.dumps({'result':responses.get(operation,{})}))
'''

class Helpers(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name)
        self.binary = self.root/'herdr'; self.binary.write_text(MOCK); self.binary.chmod(0o755)
        (self.root/'.dotfiles').mkdir()
        self.calls = self.root/'calls'
        self.env = dict(os.environ, HOME=str(self.root), CALLS=str(self.calls),
                        HERDR_BIN_PATH=str(self.binary), HERDR_SOCKET_PATH='/tmp/origin.sock',
                        HERDR_ACTIVE_PANE_ID='w3:p7', HERDR_ACTIVE_WORKSPACE_ID='w3', HERDR_ACTIVE_TAB_ID='w3:t1',
                        HERDR_ACTIVE_PANE_CWD=str(self.root), HERDR_PANE_ID='w99:p99')
        self.responses = {'pane process-info': {'process_info': {'foreground_processes': [{'name':'bash'}]}},
                          'pane neighbor': {'neighbor': {'neighbor_pane_id':'w3:p8'}},
                          'tab list': {'tabs': []},
                          'tab create': {'root_pane': {'pane_id':'w3:p9'}}}

    def run_helper(self, name, arg=None, fail=None, overrides=None, input=None):
        env = dict(self.env, RESPONSES=json.dumps(self.responses), FAIL=fail or '')
        env.update(overrides or {})
        argv = ['bash',str(SCRIPTS/name)] + ([] if arg is None else [arg])
        result = subprocess.run(argv,env=env,text=True,capture_output=True,input=input)
        calls = [json.loads(line) for line in self.calls.read_text().splitlines()] if self.calls.exists() else []
        self.assertTrue(all(c['socket']=='/tmp/origin.sock' for c in calls))
        return result, [c['args'] for c in calls]

    def test_first_exact_title_in_origin_workspace(self):
        self.responses['tab list']['tabs']=[
            {'workspace_id':'w9','label':'lazygit','number':1,'tab_id':'w9:t1'},
            {'workspace_id':'w3','label':'lazygit logs','number':1,'tab_id':'w3:t1'},
            {'workspace_id':'w3','label':'lazygit','number':4,'tab_id':'w3:t4'},
            {'workspace_id':'w3','label':'lazygit','number':2,'tab_id':'w3:t2'}]
        result,calls=self.run_helper('herdr-tab-launcher','lazygit')
        self.assertEqual(result.returncode,0,result.stderr)
        self.assertEqual(calls,[['tab','list','--workspace','w3'],['tab','focus','w3:t2']])

    def test_existing_lazygit_does_not_require_source_directory(self):
        self.responses['tab list']['tabs']=[{'workspace_id':'w3','label':'lazygit','number':1,'tab_id':'w3:t1'}]
        result,calls=self.run_helper('herdr-tab-launcher','lazygit',overrides={'HERDR_ACTIVE_PANE_CWD':''})
        self.assertEqual(result.returncode,0,result.stderr)
        self.assertEqual(calls[-1],['tab','focus','w3:t1'])

    def test_new_lazygit_targets_only_created_pane(self):
        result,calls=self.run_helper('herdr-tab-launcher','lazygit')
        self.assertEqual(result.returncode,0,result.stderr)
        self.assertEqual(calls[-2],['tab','create','--workspace','w3','--cwd',str(self.root),'--label','lazygit','--focus'])
        self.assertEqual(calls[-1],['pane','run','w3:p9','lazygit'])

    def test_dotfiles_always_creates_in_dotfiles(self):
        result,calls=self.run_helper('herdr-tab-launcher','dotfiles')
        self.assertEqual(result.returncode,0,result.stderr)
        self.assertEqual(calls[0],['tab','create','--workspace','w3','--cwd',str(self.root/'.dotfiles'),'--label','dotfiles','--focus'])
        self.assertEqual(calls[1],['pane','run','w3:p9','nvim .'])

    def test_launcher_failures_do_not_run_in_source(self):
        for operation in ['tab list','tab create','pane run']:
            with self.subTest(operation=operation):
                self.calls.unlink(missing_ok=True)
                result,calls=self.run_helper('herdr-tab-launcher','lazygit',operation)
                self.assertNotEqual(result.returncode,0)
                self.assertIn('herdr shortcut:',result.stderr)
                self.assertFalse(any(c[:3]==['pane','run','w3:p7'] for c in calls))
                if operation != 'pane run': self.assertFalse(any(c[:2]==['pane','run'] for c in calls))

    def test_malformed_creation_never_runs_command(self):
        self.responses['tab create']={}
        result,calls=self.run_helper('herdr-tab-launcher','dotfiles')
        self.assertNotEqual(result.returncode,0)
        self.assertIn('no pane ID',result.stderr)
        self.assertFalse(any(c[:2]==['pane','run'] for c in calls))

    def move_menu(self, input, fail=None, overrides=None):
        self.responses.setdefault('pane move', {'move_result': {'changed': True}})
        if not self.responses['tab list']['tabs']:
            self.responses['tab list']['tabs']=[
                {'workspace_id':'w3','label':'shell','number':1,'tab_id':'w3:t1'},
                {'workspace_id':'w3','label':'editor','number':2,'tab_id':'w3:t2'}]
        return self.run_helper('herdr-move-pane',input=input,fail=fail,overrides=overrides)

    def test_move_menu_new_tab_uses_origin_context(self):
        result,calls=self.move_menu('c')
        self.assertEqual(result.returncode,0,result.stderr)
        self.assertIn('1  shell (current)',result.stdout)
        self.assertIn('2  editor',result.stdout)
        self.assertEqual(calls,[['tab','list','--workspace','w3'],
                               ['pane','move','w3:p7','--new-tab','--workspace','w3','--focus']])

    def test_move_menu_existing_tab(self):
        result,calls=self.move_menu('2')
        self.assertEqual(result.returncode,0,result.stderr)
        self.assertEqual(calls[-1],['pane','move','w3:p7','--tab','w3:t2','--split','right','--focus'])

    def test_move_menu_cancel_and_eof(self):
        for choice in ['q','\x1b','']:
            with self.subTest(choice=choice):
                self.calls.unlink(missing_ok=True)
                result,calls=self.move_menu(choice)
                self.assertEqual(result.returncode,0,result.stderr)
                self.assertEqual(len(calls),1)

    def test_move_menu_rejects_current_and_invalid_numbers(self):
        result,calls=self.move_menu('192')
        self.assertEqual(result.returncode,0,result.stderr)
        self.assertIn('Already in that tab',result.stdout)
        self.assertIn('No tab with that number',result.stdout)
        self.assertEqual(len(calls),2)
        self.assertIn('w3:t2',calls[-1])

    def test_move_menu_multiple_digits_and_enter(self):
        self.responses['tab list']['tabs']=[
            {'workspace_id':'w3','label':'tab '+str(n),'number':n,'tab_id':'w3:t'+str(n)}
            for n in range(1,11)]
        for choice,target in [('10','w3:t10'),('1\n','w3:t1'),('1\x7f10','w3:t10')]:
            with self.subTest(choice=choice):
                self.calls.unlink(missing_ok=True)
                result,calls=self.move_menu(choice,overrides={'HERDR_ACTIVE_TAB_ID':'w3:t3'})
                self.assertEqual(result.returncode,0,result.stderr)
                self.assertIn(target,calls[-1])

    def test_move_menu_numbers_follow_current_order_without_gaps(self):
        self.responses['tab list']['tabs']=[
            {'workspace_id':'w3','label':'source','number':1,'tab_id':'w3:t1'},
            {'workspace_id':'w3','label':'reordered','number':8,'tab_id':'w3:t8'},
            {'workspace_id':'w3','label':'remaining','number':5,'tab_id':'w3:t5'}]
        for choice,target in [('2','w3:t8'),('3','w3:t5')]:
            with self.subTest(choice=choice):
                self.calls.unlink(missing_ok=True)
                result,calls=self.move_menu(choice)
                self.assertEqual(result.returncode,0,result.stderr)
                self.assertIn('  1  source (current)',result.stdout)
                self.assertIn('  2  reordered',result.stdout)
                self.assertIn('  3  remaining',result.stdout)
                self.assertIn(target,calls[-1])

    def test_move_menu_pages_keep_consecutive_menu_numbers(self):
        self.responses['tab list']['tabs']=[
            {'workspace_id':'w3','label':'tab '+str(n),'number':n,'tab_id':'w3:t'+str(n)}
            for n in range(1,14)]
        result,calls=self.move_menu(']9')
        self.assertEqual(result.returncode,0,result.stderr)
        self.assertIn('Previous/next page',result.stdout)
        self.assertIn('9  tab 9',result.stdout)
        self.assertIn('w3:t9',calls[-1])

    def test_move_menu_filters_workspace_and_sanitizes_labels(self):
        self.responses['tab list']['tabs']=[
            {'workspace_id':'w9','label':'foreign','number':2,'tab_id':'w9:t2'},
            {'workspace_id':'w3','label':'source','number':1,'tab_id':'w3:t1'},
            {'workspace_id':'w3','label':'unsafe\x1b[31m\nlabel','number':2,'tab_id':'w3:t2'}]
        result,calls=self.move_menu('2')
        self.assertEqual(result.returncode,0,result.stderr)
        self.assertNotIn('foreign',result.stdout)
        self.assertNotIn('\x1b[31m',result.stdout)
        self.assertIn('w3:t2',calls[-1])

    def test_move_menu_failures_do_not_create_fallback_tabs(self):
        for operation in ['tab list','pane move']:
            with self.subTest(operation=operation):
                self.calls.unlink(missing_ok=True)
                result,calls=self.move_menu('2',fail=operation)
                self.assertNotEqual(result.returncode,0)
                self.assertIn('Move pane:',result.stderr)
                self.assertFalse(any('--new-tab' in call for call in calls))

    def test_move_menu_explains_zoom_rejection(self):
        self.responses['pane move']={'move_result':{'changed':False,'reason':'zoomed_tab'}}
        result,calls=self.move_menu('c')
        self.assertNotEqual(result.returncode,0)
        self.assertIn('unzoom the source and destination',result.stderr)
        self.assertEqual(len(calls),2)

    def test_move_menu_missing_tab_context(self):
        result,calls=self.move_menu('c',overrides={'HERDR_ACTIVE_TAB_ID':''})
        self.assertNotEqual(result.returncode,0)
        self.assertEqual(calls,[])

    def test_move_menu_malformed_move_response(self):
        self.responses['pane move']={}
        result,calls=self.move_menu('2')
        self.assertNotEqual(result.returncode,0)
        self.assertIn('invalid move response',result.stderr)
        self.assertEqual(len(calls),2)

if __name__ == '__main__': unittest.main()
