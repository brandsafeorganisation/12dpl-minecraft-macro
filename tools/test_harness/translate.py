#!/usr/bin/env python3
"""Translate a preprocessed 12dPL program into C++ for testing.
Also lints for constructs that are risky in 12dPL."""
import re, subprocess, sys, os

src_dir, main_file, out = sys.argv[1], sys.argv[2], sys.argv[3]
pre = subprocess.run(['cpp','-P','-undef','-nostdinc','-x','c','-w',main_file],cwd=src_dir,capture_output=True,text=True)
if pre.returncode:
    print(pre.stderr); sys.exit(1)
code = pre.stdout

# ---------------------------------------------------------- tokenise into chunks keeping strings/comments
def strip_global_blocks(s):
    out=[]; depth=0; i=0; n=len(s); last_sig=''
    stack=[]  # for each '{' : True if it is a global block (to drop)
    while i<n:
        c=s[i]
        if c=='"' :
            j=i+1
            while j<n and s[j]!='"':
                if s[j]=='\\': j+=1
                j+=1
            out.append(s[i:j+1]); i=j+1; last_sig='"'; continue
        if c=="'":
            j=i+1
            while j<n and s[j]!="'":
                if s[j]=='\\': j+=1
                j+=1
            out.append(s[i:j+1]); i=j+1; last_sig="'"; continue
        if s.startswith('//',i):
            j=s.find('\n',i); j=n if j<0 else j
            out.append(s[i:j]); i=j; continue
        if s.startswith('/*',i):
            j=s.find('*/',i)+2
            out.append(s[i:j]); i=j; continue
        if c=='{':
            is_global = (len(stack)==0 and last_sig!=')')
            stack.append(is_global)
            if not is_global: out.append(c)
            last_sig='{'; i+=1; continue
        if c=='}':
            g=stack.pop()
            if not g: out.append(c)
            last_sig='}'; i+=1; continue
        if not c.isspace(): last_sig=c
        out.append(c); i+=1
    return ''.join(out)

code = strip_global_blocks(code)
# array declarations: size + 1 (1-based arrays)
code = re.sub(r'^(\s*(?:Integer|Real|Text|Integer64)\s+\w+\s*)\[([^\]]+)\](\s*;)', r'\1[(\2)+1]\3', code, flags=re.M)
code = re.sub(r'\bvoid\s+main\s*\(\s*\)', 'void macro_main()', code)
open(out,'w').write('#include "runtime.h"\n'+code+'\n')

# ---------------------------------------------------------- lint (on preprocessed code)
problems=[]
lines=code.split('\n')
for k,l in enumerate(lines):
    t=re.sub(r'"(\\.|[^"\\])*"','""',l)
    t=t.split('//')[0]
    for op in ['+=','-=','*=','/=']:
        if op in t: problems.append(f'{k+1}: compound assignment {op}: {l.strip()}')
    if re.search(r'\?[^:]*:',t) : problems.append(f'{k+1}: ternary?: {l.strip()}')
    if re.search(r'for\s*\(\s*(Integer|Real)\b',t): problems.append(f'{k+1}: declaration in for header: {l.strip()}')
    lits=list(re.finditer(r'"(?:\\.|[^"\\])*"',l))
    for a,b in zip(lits,lits[1:]):
        if re.fullmatch(r'\s*\+\s*',l[a.end():b.start()]): problems.append(f'{k+1}: literal+literal: {l.strip()}')

# per-function duplicate declarations and names clashing with functions
func_re=re.compile(r'^(?:void|Integer|Real|Text|Integer64)\s+(\w+)\s*\(([^)]*)\)\s*$',re.M)
funcs=set(m.group(1) for m in func_re.finditer(code))
builtin_used=set(re.findall(r'\b([A-Z][a-z]+(?:_[a-z0-9]+)*)\s*\(',code))
decl_re=re.compile(r'\b(Integer|Real|Text|Integer64|File|Dynamic_Text|Attributes|Draw_Box|Panel|Button|Input_Box|File_Box|List_Box|Vertical_Group|Horizontal_Group|Colour_Message_Box)\s+&?\s*(\w+)\s*(?:=|;|\[|,|\))')
# split into function bodies
pos=0
for m in func_re.finditer(code):
    name=m.group(1)
    start=code.find('{',m.end())
    if start<0: continue
    # find matching brace
    d=0;j=start
    while True:
        if code[j]=='{': d+=1
        elif code[j]=='}':
            d-=1
            if d==0: break
        j+=1
    body=code[start:j]
    params=m.group(2)
    seen={}
    for dm in decl_re.finditer(params+','):
        seen[dm.group(2)]=1
        if not dm.group(2).startswith('p_'): problems.append(f'{name}: parameter {dm.group(2)} should start with p_')
    bodyc=re.sub(r'"(\\.|[^"\\])*"','""',body)
    bodyc=re.sub(r'//[^\n]*','',bodyc)
    for dm in decl_re.finditer(bodyc):
        v=dm.group(2)
        if v in seen: problems.append(f'{name}: duplicate declaration of {v}')
        if not v.startswith(('l_','p_','g_')): problems.append(f'{name}: local {v} should start with l_')
        seen[v]=1
        if v in funcs or v in builtin_used: problems.append(f'{name}: variable {v} has the name of a function')
for p in problems: print('LINT', p)
print('lint problems:',len(problems))
