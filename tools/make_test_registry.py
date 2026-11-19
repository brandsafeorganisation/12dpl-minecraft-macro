#!/usr/bin/env python3
"""Write the test build's function registry from the macro's source.

12dPL can't call a function by its name, so the test build needs code
that names every function. This script reads every function defined
under src/, plus a list of library calls, and writes

  test/include/test_registry.h   the number of functions and the
                                 field names of the input/output records
  test/src/test_registry.4dm     test_registry_info(): what each function
                                 is (name, file, lines, signature, the
                                 functions it calls, why it can't be run);
                                 test_registry_call(): call function n
                                 with the inputs in a record, time it,
                                 and put its outputs in another record

Run it again whenever functions are added, removed or change their
parameters (the harness build checks the registry is up to date):

  python3 tools/make_test_registry.py          write the files
  python3 tools/make_test_registry.py --check  exit 1 if they are stale
"""
import os, re, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT_H = os.path.join(ROOT, 'test', 'include', 'test_registry.h')
OUT_4DM = os.path.join(ROOT, 'test', 'src', 'test_registry.4dm')
CHUNK = 40          # functions per generated function (keeps each one small)

# Records passed to an Attributes parameter, by parameter name. The test
# build owns the game's records while it runs, so functions get the real
# game state (made by "Make test world"); anything else gets a scratch record.
RECORDS = {
    'p_player': 'g_player', 'p_events': 'g_events', 'p_cows': 'g_cows', 'p_inventory': 'g_inventory',
    'p_furnaces': 'g_furnaces', 'p_info': 'g_info', 'p_settings': 'g_settings', 'p_drops': 'g_drops',
    'p_ui': 'g_ui', 'p_random': 'g_random', 'p_peers': 'g_peers', 'p_hud': 'g_hud', 'p_net': 'g_net',
    'p_grid': 'g_grid', 'p_event': 'g_event', 'p_book': 'g_book', 'p_game': 'g_game', 'p_inbox': 'g_net_inbox',
    'p_holder': 'g_inventory', 'p_away': 'g_away', 'p_from': 'g_inventory', 'p_to': 'g_grid', 'p_container': 'g_grid',
}
SCRATCH = ['g_test_record', 'g_test_record_2', 'g_test_record_3']

# Library calls that are safe to run over and over: maths, text, the
# clock, attributes on a scratch record and checks that only read.
# (name, return type, [(type, name)] with "&" marking a reference)
LIBRARY = [
    ('Absolute', 'Real', [('Real', 'p_value')]),
    ('Absolute', 'Integer', [('Integer', 'p_value')]),
    ('Floor', 'Real', [('Real', 'p_value')]),
    ('Sqrt', 'Real', [('Real', 'p_positive')]),
    ('Sin', 'Real', [('Real', 'p_angle')]),
    ('Cos', 'Real', [('Real', 'p_angle')]),
    ('To_text', 'Text', [('Integer', 'p_value')]),
    ('To_text', 'Text', [('Real', 'p_value'), ('Integer', 'p_decimals')]),
    ('Text_length', 'Integer', [('Text', 'p_text')]),
    ('Get_subtext', 'Text', [('Text', 'p_text'), ('Integer', 'p_start'), ('Integer', 'p_end')]),
    ('Find_text', 'Integer', [('Text', 'p_text'), ('Text', 'p_find')]),
    ('Text_lower', 'Text', [('Text', 'p_text')]),
    ('Text_justify', 'Text', [('Text', 'p_text')]),
    ('From_text', 'Integer', [('Text', 'p_number'), ('&Integer', 'p_value')]),
    ('From_text', 'Integer', [('Text', 'p_number'), ('&Real', 'p_value')]),
    ('From_text', 'Integer', [('Text', 'p_text'), ('&Dynamic_Text', 'p_words')]),
    ('Set_char', 'Integer', [('&Text', 'p_text'), ('Integer', 'p_position'), ('Integer', 'p_char')]),
    ('Get_time', 'Integer', [('&Real', 'p_time')]),
    ('Get_time', 'Integer', [('&Integer', 'p_time')]),
    ('Get_user_name', 'Integer', [('&Text', 'p_name')]),
    ('Get_random_number_closed', 'Real', []),
    ('File_exists', 'Integer', [('Text', 'p_path')]),
    ('Directory_exists', 'Integer', [('Text', 'p_folder')]),
    ('Set_attribute', 'Integer', [('&Attributes', 'p_record'), ('Text', 'p_field'), ('Integer', 'p_value')]),
    ('Set_attribute', 'Integer', [('&Attributes', 'p_record'), ('Text', 'p_field'), ('Real', 'p_value')]),
    ('Set_attribute', 'Integer', [('&Attributes', 'p_record'), ('Text', 'p_field'), ('Text', 'p_value')]),
    ('Get_attribute', 'Integer', [('&Attributes', 'p_record'), ('Text', 'p_field'), ('&Integer', 'p_value')]),
    ('Get_attribute', 'Integer', [('&Attributes', 'p_record'), ('Text', 'p_field'), ('&Real', 'p_value')]),
    ('Get_attribute', 'Integer', [('&Attributes', 'p_record'), ('Text', 'p_field'), ('&Text', 'p_value')]),
    ('Attribute_exists', 'Integer', [('&Attributes', 'p_record'), ('Text', 'p_field')]),
    ('Get_number_of_attributes', 'Integer', [('&Attributes', 'p_record'), ('&Integer', 'p_count')]),
    ('Attribute_delete_all', 'Integer', [('&Attributes', 'p_record')]),
]

TYPE_LETTER = {'Integer': 'I', 'Real': 'R', 'Text': 'T', 'Attributes': 'A', 'Draw_Box': 'B',
               'Dynamic_Text': 'D', 'Colour_Message_Box': 'M'}
SLOT_LETTER = {'Integer': 'i', 'Real': 'r', 'Text': 't'}
CANT_PASS = {'File': 'takes an open File', 'List_Box': 'takes a list widget (it would empty the test list)',
             'Panel': 'takes a panel'}


# ---------------------------------------------------------------- reading the source

def strip_strings_and_comments(text):
    """Same length as text, with string, character and comment contents blanked"""
    out = list(text)
    i, n = 0, len(text)
    while i < n:
        c = text[i]
        if text.startswith('//', i):
            j = text.find('\n', i)
            j = n if j < 0 else j
            for k in range(i, j): out[k] = ' '
            i = j
        elif text.startswith('/*', i):
            j = text.find('*/', i) + 2
            for k in range(i, j):
                if out[k] != '\n': out[k] = ' '
            i = j
        elif c in '"\'':
            j = i + 1
            while j < n and text[j] != c:
                if text[j] == '\\': j += 1
                j += 1
            for k in range(i + 1, j): out[k] = ' '
            i = j + 1
        else:
            i += 1
    return ''.join(out)


DEF = re.compile(r'^(void|Integer|Real|Text)\s+(\w+)\s*\(', re.M)


def read_functions():
    functions = []
    for folder, _, files in sorted(os.walk(os.path.join(ROOT, 'src'))):
        for name in sorted(files):
            if not name.endswith('.4dm'): continue
            path = os.path.join(folder, name)
            rel = os.path.relpath(path, ROOT).replace(os.sep, '/')
            text = open(path, encoding='utf-8', errors='replace').read()
            clean = strip_strings_and_comments(text)
            for m in DEF.finditer(clean):
                # the parameter list ends at the matching ')'
                depth, i = 0, m.end() - 1
                while True:
                    if clean[i] == '(': depth += 1
                    elif clean[i] == ')':
                        depth -= 1
                        if depth == 0: break
                    i += 1
                params_text = text[m.end():i]
                rest = clean[i + 1:]
                # a definition, not a prototype: the body's '{' comes before any ';'
                brace, semi = rest.find('{'), rest.find(';')
                if brace < 0 or (0 <= semi < brace): continue
                start = i + 1 + brace
                depth, j = 0, start
                while True:
                    if clean[j] == '{': depth += 1
                    elif clean[j] == '}':
                        depth -= 1
                        if depth == 0: break
                    j += 1
                body = clean[start:j + 1]
                raw_body = text[start:j + 1]
                params = []
                for p in params_text.split(','):
                    p = ' '.join(p.split())
                    if not p: continue
                    pm = re.match(r'(\w+)\s*(&?)\s*(\w+)$', p)
                    if not pm: raise SystemExit('cannot read parameter %r of %s in %s' % (p, m.group(2), rel))
                    params.append(((pm.group(2) and '&' or '') + pm.group(1), pm.group(3)))
                functions.append({
                    'name': m.group(2), 'returns': m.group(1), 'params': params, 'file': rel,
                    'module': os.path.splitext(name)[0], 'part': rel.split('/')[1],
                    'first': text.count('\n', 0, m.start()) + 1, 'last': text.count('\n', 0, j) + 1,
                    'body': body, 'raw_body': raw_body, 'kind': 'macro'})
    return functions


def signature(f):
    parts = []
    for t, n in f['params']:
        parts.append(t.lstrip('&') + (' &' if t.startswith('&') else ' ') + n)
    return '%s %s(%s)' % (f['returns'], f['name'], ', '.join(parts))


# ---------------------------------------------------------------- what can be run

def classify(functions):
    names = {f['name'] for f in functions}
    by_name = {}
    for f in functions:
        by_name.setdefault(f['name'], f)
        f['calls'] = sorted({c for c in re.findall(r'\b(\w+)\s*\(', f['body']) if c in names and c != f['name']})
        f['why'] = ''
        f['writes'] = False
        for t, _ in f['params']:
            if t.lstrip('&') in CANT_PASS: f['why'] = CANT_PASS[t.lstrip('&')]
        if re.search(r'\bWait_on_events\s*\(|\bCreate_panel\s*\(', f['body']):
            f['why'] = 'opens a panel and waits for events'
        if re.search(r'\bDirectory_create\s*\(', f['body']): f['writes'] = True
        for m in re.finditer(r'\bsafe_file_open\s*\(([^;]*)\)', f['raw_body']):
            if not re.search(r',\s*("r"|"rb")\s*,', m.group(1)): f['writes'] = True
    # spread through the call graph: a function that calls one that waits
    # for a panel waits too, and one that calls a writer writes (a File or
    # list parameter only stops calling that function directly: its
    # callers open their own file)
    changed = True
    while changed:
        changed = False
        for f in functions:
            for c in f['calls']:
                g = by_name[c]
                if g['why'] and 'panel' in g['why'] and not f['why']:
                    f['why'] = 'calls ' + c + ', which opens a panel and waits for events'
                    changed = True
                if g['writes'] and not f['writes']:
                    f['writes'] = True
                    changed = True


def library_functions():
    out = []
    for name, returns, params in LIBRARY:
        out.append({'name': name, 'returns': returns, 'params': params, 'file': '', 'module': 'library',
                    'part': 'library', 'first': 0, 'last': 0, 'calls': [], 'why': '', 'writes': False,
                    'kind': 'library'})
    return out


# ---------------------------------------------------------------- writing 12dPL

def text_literal(s):
    return '"' + s.replace('\\', '\\\\').replace('"', '\\"') + '"'


def param_spec(f):
    out = []
    for t, n in f['params']:
        base = t.lstrip('&')
        out.append(('&' if t.startswith('&') else '') + TYPE_LETTER.get(base, '?') + ':' + n)
    return ' '.join(out)


def call_code(f):
    """Lines of the branch that loads the inputs, calls f between two clock
    readings and stores what came out"""
    counts = {'i': 0, 'r': 0, 't': 0}
    scratch = 0
    args, load, store = [], [], []
    for t, n in f['params']:
        base = t.lstrip('&')
        if base in SLOT_LETTER:
            k = SLOT_LETTER[base]
            counts[k] += 1
            var = 'l_%s%d' % (k, counts[k])
            field = 'ATTR_TEST_%s%d' % (k.upper(), counts[k])
            getter = {'i': 'record_integer', 'r': 'record_real', 't': 'record_text'}[k]
            setter = {'i': 'record_set_integer', 'r': 'record_set_real', 't': 'record_set_text'}[k]
            load.append('%s = %s(p_in, %s);' % (var, getter, field))
            if t.startswith('&'): store.append('%s(p_out, %s, %s);' % (setter, field, var))
            args.append(var)
        elif base == 'Attributes':
            if n in RECORDS:
                args.append(RECORDS[n])
            else:
                args.append(SCRATCH[min(scratch, len(SCRATCH) - 1)])
                scratch += 1
        elif base == 'Draw_Box':
            args.append('g_test_box')
        elif base == 'Colour_Message_Box':
            args.append('g_test_message')
        elif base == 'Dynamic_Text':
            load.append('test_reset_words(g_test_words, record_text(p_in, ATTR_TEST_WORDS));')
            args.append('g_test_words')
        else:
            raise SystemExit('no way to pass %s to %s' % (t, f['name']))
    call = '%s(%s)' % (f['name'], ', '.join(args))
    if f['returns'] == 'Integer': call = 'l_ret_i = ' + call
    elif f['returns'] == 'Real': call = 'l_ret_r = ' + call
    elif f['returns'] == 'Text': call = 'l_ret_t = ' + call
    if any(t.lstrip('&') == 'Dynamic_Text' for t, _ in f['params']):
        store.append('record_set_text(p_out, ATTR_TEST_WORDS, test_words_text(g_test_words));')
    return load + ['Get_time(l_start);', call + ';', 'Get_time(l_end);'] + store, counts


def generate(functions):
    count = len(functions)
    most = {'i': 1, 'r': 1, 't': 1}
    branches = []
    for f in functions:
        if f['why']:
            branches.append(None)
            continue
        lines, counts = call_code(f)
        for k in most: most[k] = max(most[k], counts[k])
        branches.append(lines)

    h = []
    h.append('#ifndef TEST_REGISTRY_H_INCLUDED')
    h.append('#define TEST_REGISTRY_H_INCLUDED')
    h.append('')
    h.append('// ----------------------------------------------------------------')
    h.append('// Written by tools/make_test_registry.py: do not edit; run it again')
    h.append('// after adding, removing or changing a function.')
    h.append('//')
    h.append('// Every function of the macro (and some library calls) by number:')
    h.append('// test_registry_info fills a record with what function n is, and')
    h.append('// test_registry_call runs it with the inputs in p_in (fields i1..,')
    h.append('// r1.., t1.. for its Integer, Real and Text parameters in order,')
    h.append('// "words" for a Dynamic_Text), putting the return value, the')
    h.append('// reference parameters afterwards and the seconds it took in p_out.')
    h.append('// ----------------------------------------------------------------')
    h.append('')
    h.append('#define TEST_FUNCTION_COUNT     %d' % count)
    h.append('#define TEST_MACRO_COUNT        %d' % sum(1 for f in functions if f['kind'] == 'macro'))
    h.append('#define TEST_INTEGER_SLOTS      %d' % most['i'])
    h.append('#define TEST_REAL_SLOTS         %d' % most['r'])
    h.append('#define TEST_TEXT_SLOTS         %d' % most['t'])
    h.append('')
    h.append('#define TEST_FLAG_WRITES_FILES  1')
    h.append('')
    h.append('#define DATATYPE_TEST_INFO      ("test_info")')
    for field in ['name', 'kind', 'part', 'module', 'file', 'first', 'last', 'returns', 'params', 'signature',
                  'flags', 'why', 'calls']:
        h.append('#define ATTR_TEST_%-15s ("%s")' % (field.upper(), field))
    for k in 'irt':
        for n in range(1, most[k] + 1):
            h.append('#define ATTR_TEST_%s%-14d ("%s%d")' % (k.upper(), n, k, n))
    h.append('#define ATTR_TEST_WORDS         ("words")')
    h.append('#define ATTR_TEST_RET_I         ("ret_i")')
    h.append('#define ATTR_TEST_RET_R         ("ret_r")')
    h.append('#define ATTR_TEST_RET_T         ("ret_t")')
    h.append('#define ATTR_TEST_SECONDS       ("seconds")')
    h.append('')
    h.append('void    test_info_set      (Attributes &p_info, Text p_name, Text p_kind, Text p_part, Text p_module, Text p_file,')
    h.append('                            Integer p_first, Integer p_last, Text p_returns, Text p_params, Text p_signature,')
    h.append('                            Integer p_flags, Text p_why, Text p_calls);')
    nchunks = (count + CHUNK - 1) // CHUNK
    for c in range(1, nchunks + 1):
        h.append('void    test_registry_info_%d (Integer p_id, Attributes &p_info);' % c)
        h.append('void    test_registry_call_%d (Integer p_id, Attributes &p_in, Attributes &p_out);' % c)
    h.append('void    test_registry_info (Integer p_id, Attributes &p_info);')
    h.append('void    test_registry_call (Integer p_id, Attributes &p_in, Attributes &p_out);')
    h.append('')
    h.append('#endif')

    s = []
    s.append('#ifndef TEST_REGISTRY_4DM_INCLUDED')
    s.append('#define TEST_REGISTRY_4DM_INCLUDED')
    s.append('')
    s.append('// Written by tools/make_test_registry.py: do not edit (see the header)')
    s.append('')
    s.append('#include "../../include/core/records.h"')
    s.append('#include "../include/test.h"')
    s.append('#include "../include/test_registry.h"')
    s.append('')
    s.append('void test_info_set(Attributes &p_info, Text p_name, Text p_kind, Text p_part, Text p_module, Text p_file,')
    s.append('                   Integer p_first, Integer p_last, Text p_returns, Text p_params, Text p_signature,')
    s.append('                   Integer p_flags, Text p_why, Text p_calls)')
    s.append('// ----------------------------------------------------------------')
    s.append('// Fill an info record')
    s.append('// ----------------------------------------------------------------')
    s.append('{')
    s.append('  record_clear      (p_info, DATATYPE_TEST_INFO);')
    for field, var, kind in [('NAME', 'p_name', 't'), ('KIND', 'p_kind', 't'), ('PART', 'p_part', 't'),
                             ('MODULE', 'p_module', 't'), ('FILE', 'p_file', 't'), ('FIRST', 'p_first', 'i'),
                             ('LAST', 'p_last', 'i'), ('RETURNS', 'p_returns', 't'), ('PARAMS', 'p_params', 't'),
                             ('SIGNATURE', 'p_signature', 't'), ('FLAGS', 'p_flags', 'i'), ('WHY', 'p_why', 't'),
                             ('CALLS', 'p_calls', 't')]:
        setter = 'record_set_integer' if kind == 'i' else 'record_set_text   '
        s.append('  %s(p_info, ATTR_TEST_%s, %s);' % (setter, field, var))
    s.append('}')
    s.append('')
    for c in range(1, nchunks + 1):
        lo, hi = (c - 1) * CHUNK + 1, min(count, c * CHUNK)
        s.append('void test_registry_info_%d(Integer p_id, Attributes &p_info)' % c)
        s.append('// ----------------------------------------------------------------')
        s.append('// What functions %d to %d are' % (lo, hi))
        s.append('// ----------------------------------------------------------------')
        s.append('{')
        for n in range(lo, hi + 1):
            f = functions[n - 1]
            flags = 1 if f['writes'] else 0
            s.append('  if (p_id == %d) test_info_set(p_info, %s, %s, %s, %s, %s, %d, %d, %s, %s,' % (
                n, text_literal(f['name']), text_literal(f['kind']), text_literal(f['part']),
                text_literal(f['module']), text_literal(f['file']), f['first'], f['last'],
                text_literal(f['returns']), text_literal(param_spec(f))))
            s.append('                              %s, %d, %s, %s);' % (
                text_literal(signature(f)), flags, text_literal(f['why']), text_literal(', '.join(f['calls']))))
        s.append('}')
        s.append('')
        s.append('void test_registry_call_%d(Integer p_id, Attributes &p_in, Attributes &p_out)' % c)
        s.append('// ----------------------------------------------------------------')
        s.append('// Run one of functions %d to %d (see the header)' % (lo, hi))
        s.append('// ----------------------------------------------------------------')
        s.append('{')
        for k, ty, zero in [('i', 'Integer', '0'), ('r', 'Real   ', '0.0'), ('t', 'Text   ', '""')]:
            for n in range(1, most[k] + 1):
                s.append('  %s l_%s%d = %s;' % (ty, k, n, zero))
        s.append('  Integer l_ret_i = 0;')
        s.append('  Real    l_ret_r = 0.0;')
        s.append('  Text    l_ret_t = "";')
        s.append('  Real    l_start = 0.0;')
        s.append('  Real    l_end   = 0.0;')
        s.append('')
        first = True
        for n in range(lo, hi + 1):
            lines = branches[n - 1]
            if lines is None: continue
            s.append('  %sif (p_id == %d) {   // %s' % ('' if first else '} else ', n, functions[n - 1]['name']))
            first = False
            for line in lines: s.append('    ' + line)
        if not first: s.append('  }')
        s.append('  record_set_integer(p_out, ATTR_TEST_RET_I,   l_ret_i);')
        s.append('  record_set_real   (p_out, ATTR_TEST_RET_R,   l_ret_r);')
        s.append('  record_set_text   (p_out, ATTR_TEST_RET_T,   l_ret_t);')
        s.append('  record_set_real   (p_out, ATTR_TEST_SECONDS, l_end - l_start);')
        s.append('}')
        s.append('')
    for what, args, desc in [('info', 'p_id, p_info', 'Fill p_info with what function p_id (1..TEST_FUNCTION_COUNT) is'),
                             ('call', 'p_id, p_in, p_out', 'Run function p_id with the inputs in p_in; outputs go in p_out')]:
        if what == 'info':
            s.append('void test_registry_info(Integer p_id, Attributes &p_info)')
        else:
            s.append('void test_registry_call(Integer p_id, Attributes &p_in, Attributes &p_out)')
        s.append('// ----------------------------------------------------------------')
        s.append('// ' + desc)
        s.append('// ----------------------------------------------------------------')
        s.append('{')
        if what == 'call':
            s.append('  record_clear(p_out, DATATYPE_TEST_INFO);')
        for c in range(1, nchunks + 1):
            lo, hi = (c - 1) * CHUNK + 1, min(count, c * CHUNK)
            s.append('  if (p_id >= %d && p_id <= %d) test_registry_%s_%d(%s);' % (lo, hi, what, c, args))
        s.append('}')
        s.append('')
    s.append('#endif')
    return '\n'.join(h) + '\n', '\n'.join(s) + '\n'


def main():
    functions = read_functions()
    classify(functions)
    functions += library_functions()
    header, source = generate(functions)
    if '--check' in sys.argv:
        stale = []
        for path, text in [(OUT_H, header), (OUT_4DM, source)]:
            if not os.path.exists(path) or open(path, encoding='utf-8').read() != text: stale.append(path)
        if stale:
            print('test registry is out of date: run python3 tools/make_test_registry.py')
            sys.exit(1)
        return
    os.makedirs(os.path.dirname(OUT_H), exist_ok=True)
    os.makedirs(os.path.dirname(OUT_4DM), exist_ok=True)
    open(OUT_H, 'w', encoding='utf-8').write(header)
    open(OUT_4DM, 'w', encoding='utf-8').write(source)
    macro = [f for f in functions if f['kind'] == 'macro']
    print('%d functions (%d macro, %d library); %d can not be run, %d write files' % (
        len(functions), len(macro), len(functions) - len(macro), sum(1 for f in functions if f['why']),
        sum(1 for f in functions if f['writes'])))


if __name__ == '__main__':
    main()
