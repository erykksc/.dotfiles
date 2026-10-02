"""Focused CLI contract tests; no live sessions or user processes are touched."""
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

SCRIPTS = Path(__file__).resolve().parents[2] / 'dot-config/herdr/bin'
MOCK = '''#!/usr/bin/python3
import json, os, sys
args=sys.argv[1:]
with open(os.environ['CALLS'], 'a') as f:
    f.write(json.dumps({'args':args, 'socket':os.environ.get('HERDR_SOCKET_PATH'),
        'context':[os.environ.get(k) for k in ['HERDR_ACTIVE_WORKSPACE_ID', 'HERDR_ACTIVE_TAB_ID', 'HERDR_ACTIVE_PANE_ID']],
        'binary':os.environ.get('HERDR_BIN_PATH'), 'cwd':os.getcwd()})+'\\n')
operation=' '.join(args[:2])
if operation == os.environ.get('FAIL'):
    print('mock server failure',file=sys.stderr); sys.exit(1)
responses=json.loads(os.environ['RESPONSES'])
print(json.dumps({'result':responses.get(operation,{})}))
'''
MISE_MOCK = '''#!/usr/bin/python3
import json, os, sys
with open(os.environ['MISE_CALLS'], 'a') as f:
    f.write(json.dumps({'args':sys.argv[1:], 'cwd':os.getcwd()})+'\\n')
if os.environ.get('MISE_FAIL'):
    print('mock mise lookup failure', file=sys.stderr); sys.exit(1)
print(os.environ['MISE_RESULT'])
'''

class Helpers(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name)
        self.binary = self.root/'herdr'; self.binary.write_text(MOCK); self.binary.chmod(0o755)
        self.tools = self.root/'tools'; self.tools.mkdir()
        # Keep PATH deterministic, including when testing missing Mise.
        for name in ['bash', 'dirname', 'jq']:
            (self.tools/name).symlink_to(shutil.which(name))
        self.mise = self.tools/'mise'; self.mise.write_text(MISE_MOCK); self.mise.chmod(0o755)
        self.mise_calls = self.root/'mise-calls'
        self.project = self.root/'project'; self.project.mkdir()
        (self.root/'.dotfiles').mkdir()
        self.calls = self.root/'calls'
        self.env = dict(os.environ, HOME=str(self.root), CALLS=str(self.calls),
                        PATH=str(self.tools), MISE_CALLS=str(self.mise_calls), MISE_RESULT=str(self.binary), MISE_FAIL='',
                        HERDR_BIN_PATH=str(self.binary), HERDR_SOCKET_PATH='/tmp/origin.sock',
                        HERDR_ACTIVE_PANE_ID='w3:p7', HERDR_ACTIVE_WORKSPACE_ID='w3', HERDR_ACTIVE_TAB_ID='w3:t1',
                        HERDR_ACTIVE_PANE_CWD=str(self.root), HERDR_PANE_ID='w99:p99')
        self.responses = {'pane process-info': {'process_info': {'foreground_processes': [{'name':'bash'}]}},
                          'pane neighbor': {'neighbor': {'neighbor_pane_id':'w3:p8'}},
                          'workspace list': {'workspaces': []},
                          'workspace create': {'workspace': {'workspace_id':'w4'},
                                               'tab': {'tab_id':'w4:t1'},
                                               'root_pane': {'pane_id':'w4:p1'}},
                          'tab list': {'tabs': []},
                          'tab create': {'root_pane': {'pane_id':'w3:p9'}}}

    def run_helper(self, name, arg=None, fail=None, overrides=None, input=None):
        env = dict(self.env, RESPONSES=json.dumps(self.responses), FAIL=fail or '')
        env.update(overrides or {})
        env = {key:value for key,value in env.items() if value is not None}
        argv = ['bash',str(SCRIPTS/name)] + ([] if arg is None else [arg])
        self.mise_calls.unlink(missing_ok=True)
        result = subprocess.run(argv,env=env,text=True,capture_output=True,input=input,cwd=self.project)
        lookups = [json.loads(line) for line in self.mise_calls.read_text().splitlines()] if self.mise_calls.exists() else []
        self.assertEqual(lookups, [{'args':['-C',str(self.root),'which','herdr'], 'cwd':str(self.project)}] if self.mise.exists() else [])
        calls = [json.loads(line) for line in self.calls.read_text().splitlines()] if self.calls.exists() else []
        self.assertTrue(all(c['socket']=='/tmp/origin.sock' for c in calls))
        self.assertTrue(all(c['context']==[env['HERDR_ACTIVE_WORKSPACE_ID'], env['HERDR_ACTIVE_TAB_ID'], env['HERDR_ACTIVE_PANE_ID']] for c in calls))
        self.assertTrue(all(c['binary']==str(self.binary) and c['cwd']==str(self.project) for c in calls))
        return result, [c['args'] for c in calls]

    def helper_cases(self):
        self.layout_responses()
        self.responses['pane move'] = {'move_result':{'changed':True}}
        return [('herdr-tab-launcher','dotfiles',None),
                ('herdr-generic-layout',None,None), ('herdr-move-pane',None,'c')]

    def test_mise_replaces_valid_missing_and_deleted_inherited_paths(self):
        old_binary = self.root/'old-herdr'
        old_binary.write_text('#!/bin/sh\nexit 99\n'); old_binary.chmod(0o755)
        deleted_binary = self.root/'deleted-herdr'
        deleted_binary.write_text(MOCK); deleted_binary.unlink()
        for name,arg,input in self.helper_cases():
            for inherited in [str(old_binary), None, '', str(deleted_binary)]:
                with self.subTest(helper=name, inherited=inherited):
                    self.calls.unlink(missing_ok=True)
                    result,calls=self.run_helper(name,arg,overrides={'HERDR_BIN_PATH':inherited},input=input)
                    self.assertEqual(result.returncode,0,result.stderr)
                    self.assertTrue(calls)
                    if name == 'herdr-move-pane':
                        self.assertEqual(calls[-1],['pane','move','w3:p7','--new-tab','--workspace','w3','--focus'])

    def assert_resolution_failure(self, overrides, message):
        for name,arg,input in self.helper_cases():
            with self.subTest(helper=name):
                self.calls.unlink(missing_ok=True)
                result,calls=self.run_helper(name,arg,overrides=overrides,input=input)
                self.assertNotEqual(result.returncode,0)
                self.assertIn('herdr shortcut:',result.stderr)
                self.assertIn(message,result.stderr)
                self.assertEqual(calls,[])

    def test_missing_mise_stops_before_herdr(self):
        self.mise.unlink()
        self.assert_resolution_failure({}, 'mise is required')

    def test_mise_lookup_failure_stops_before_herdr(self):
        self.assert_resolution_failure({'MISE_FAIL':'1'}, 'mise could not resolve herdr')

    def test_mise_empty_output_stops_before_herdr(self):
        self.assert_resolution_failure({'MISE_RESULT':''}, 'empty herdr executable path')

    def test_mise_unavailable_executable_stops_before_herdr(self):
        nonexecutable = self.root/'nonexecutable'; nonexecutable.write_text(MOCK)
        for path in [nonexecutable, self.root/'missing', self.root]:
            with self.subTest(path=path):
                self.assert_resolution_failure({'MISE_RESULT':str(path)}, 'unavailable herdr executable')

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

    def layout_responses(self):
        self.responses['tab list']['tabs']=[
            {'workspace_id':'w3','label':'scratch','number':1,'tab_id':'w3:t1'}]
        self.responses['tab create']={'tab':{'tab_id':'w3:t9'},
                                      'root_pane':{'pane_id':'w3:p9'}}

    def test_generic_layout_creates_tabs_and_starts_expected_commands(self):
        self.layout_responses()
        result,calls=self.run_helper('herdr-generic-layout')
        self.assertEqual(result.returncode,0,result.stderr)
        self.assertEqual(calls,[
            ['tab','list','--workspace','w3'],
            ['tab','create','--workspace','w3','--cwd',str(self.root),'--label','neovim','--focus'],
            ['pane','run','w3:p9','nvim .'],
            ['tab','create','--workspace','w3','--cwd',str(self.root),'--label','shell','--no-focus'],
            ['tab','create','--workspace','w3','--cwd',str(self.root),'--label','agent','--no-focus'],
            ['pane','run','w3:p9','codex --no-daemon resume --last'],
            ['tab','create','--workspace','w3','--cwd',str(self.root),'--label','lazygit','--no-focus'],
            ['pane','run','w3:p9','lazygit'],
            ['tab','create','--workspace','w3','--cwd',str(self.root),'--label','services','--no-focus'],
            ['pane','close','w3:p7'],
            ['tab','focus','w3:t9']])

    def test_generic_layout_reuses_tabs_without_restarting_agents(self):
        self.responses['tab list']['tabs']=[
            {'workspace_id':'w3','label':label,'number':i,'tab_id':f'w3:t{i}'}
            for i,label in enumerate(['neovim','shell','agent','lazygit','services'],1)]
        result,calls=self.run_helper('herdr-generic-layout')
        self.assertEqual(result.returncode,0,result.stderr)
        self.assertEqual(calls,[['tab','list','--workspace','w3'],
                                ['tab','focus','w3:t1'],['tab','focus','w3:t1']])

    def test_generic_layout_requires_available_origin_directory(self):
        result,calls=self.run_helper('herdr-generic-layout',overrides={'HERDR_ACTIVE_PANE_CWD':''})
        self.assertNotEqual(result.returncode,0)
        self.assertIn('originating pane directory',result.stderr)
        self.assertEqual(calls,[])

    def test_generic_layout_rejects_malformed_tab_list(self):
        self.responses['tab list']={}
        result,calls=self.run_helper('herdr-generic-layout')
        self.assertNotEqual(result.returncode,0)
        self.assertIn('invalid workspace tab list response',result.stderr)
        self.assertEqual(calls,[['tab','list','--workspace','w3']])

    def test_generic_layout_rejects_malformed_tab_creation(self):
        self.layout_responses()
        self.responses['tab create']={}
        result,calls=self.run_helper('herdr-generic-layout')
        self.assertNotEqual(result.returncode,0)
        self.assertIn('no pane ID',result.stderr)
        self.assertEqual(calls,[['tab','list','--workspace','w3'],
                                ['tab','create','--workspace','w3','--cwd',str(self.root),'--label','neovim','--focus']])

    def test_generic_layout_failures_stop_subsequent_commands(self):
        self.layout_responses()
        for operation in ['tab list','tab create','pane run']:
            with self.subTest(operation=operation):
                self.calls.unlink(missing_ok=True)
                result,calls=self.run_helper('herdr-generic-layout',fail=operation)
                self.assertNotEqual(result.returncode,0)
                self.assertIn('herdr shortcut:',result.stderr)
                self.assertFalse(any(c[:3]==['pane','run','w3:p7'] for c in calls))
                self.assertFalse(any(c[:2]==['pane','close'] for c in calls))

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
