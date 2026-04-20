# FZF : Intégration Vim / Neovim

Référence de l'API plugin `junegunn/fzf` (commandes `:FZF`, `fzf#run`, `fzf#wrap`, variables globales) + recettes custom.

Plugin extension `junegunn/fzf.vim` = commandes préfaites (`:Files`, `:Rg`, `:Buffers`, etc.) bâties sur cette API.

## 1. Installation

```vim
" vim-plug : fzf core (installe/met à jour le binaire) + fzf.vim (commandes)
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
```
Le plugin utilise le binaire `fzf` du `$PATH` s'il existe, sinon propose de télécharger.

Sous AstroNvim / Lazy / autre gestionnaire : adapter la syntaxe, mais le hook `fzf#install()` reste le moyen standard de garder le binaire synchro.

## 2. Commande `:FZF`

Sélecteur de fichiers de base — référence d'implémentation pour commandes custom.

```vim
:FZF                         " fichiers sous le répertoire courant
:FZF ~                       " sous $HOME
:FZF --reverse --info=inline /tmp
:FZF!                        " bang = plein écran
```

Bindings dans l'interface fzf (comme ctrlp.vim) :

| Touche | Action |
| :--- | :--- |
| `Enter` | Ouvrir dans la fenêtre courante |
| `Ctrl-T` | Ouvrir dans un nouvel onglet |
| `Ctrl-X` | Split horizontal |
| `Ctrl-V` | Split vertical |

> `$FZF_DEFAULT_COMMAND` et `$FZF_DEFAULT_OPTS` s'appliquent ici.

## 3. Variables Globales

### `g:fzf_action`
Remappe les touches d'ouverture.
```vim
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Une action peut être une funcref — exemple : pousser en quickfix
function! s:build_qf_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val, "lnum": 1 }'))
  copen
  cc
endfunction
let g:fzf_action = {
  \ 'ctrl-q': function('s:build_qf_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }
```

### `g:fzf_layout`
Taille et position de la fenêtre fzf.
```vim
" Popup centrée sur l'écran
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }

" Popup relative à la fenêtre courante
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6, 'relative': v:true } }

" Popup ancrée au bas de la fenêtre courante
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6, 'relative': v:true, 'yoffset': 1.0 } }

" Split positionné
let g:fzf_layout = { 'down': '40%' }

" Commande Vim arbitraire pour créer la fenêtre
let g:fzf_layout = { 'window': '-tabnew' }
let g:fzf_layout = { 'window': '10new' }

" Popup tmux (tmux ≥ 3.2)
let g:fzf_layout = { 'tmux': '90%,70%' }
```

Options popup (`window: { ... }`) :
- **Requis** : `width`, `height` (float 0–1 = ratio, int = taille absolue)
- **Optionnels** : `yoffset` / `xoffset` (défaut 0.5), `relative` (défaut `v:false`), `border` (`rounded` défaut, ou `sharp`/`horizontal`/`vertical`/`top`/`bottom`/`left`/`right`/`none`)

### `g:fzf_colors`
Map les éléments fzf aux groupes highlight Vim. Structure :
```
element: [ component, group1 [, group2, ...] ]
```
- `element` : clé fzf (`fg`, `bg`, `hl`, `prompt`, etc.)
- `component` : `'fg'` ou `'bg'` du groupe à extraire
- `group1, group2, ...` : groupes highlight cherchés en cascade (fallback)

Exemple calé sur le colorscheme courant :
```vim
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }
```

Éléments supportés : `fg`, `bg`, `hl`, `fg+`, `bg+`, `hl+`, `preview-fg`, `preview-bg`, `gutter`, `pointer`, `marker`, `border`, `header`, `info`, `spinner`, `query`, `disabled`, `prompt`.

> Debug : `:echo fzf#wrap()` affiche le spec résolu, incluant la chaîne `--color` générée.

### `g:fzf_history_dir`
Active l'historique de requêtes par commande.
```vim
let g:fzf_history_dir = '~/.local/share/fzf-history'
```
Quand défini, `Ctrl-N` / `Ctrl-P` deviennent `next-history` / `previous-history` (au lieu de `down` / `up`). Le nom de la commande (1er arg de `fzf#wrap`) détermine le fichier d'historique.

## 4. `fzf#run(spec)` — API Core

Lance fzf dans Vim avec le `spec` donné (dictionnaire). Au minimum : `sink`.

```vim
call fzf#run({'sink': 'e'})                              " fs walk → :e
call fzf#run({'source': 'git ls-files', 'sink': 'e'})    " git files → :e
call fzf#run({'sink': 'tabedit', 'options': '--multi --reverse'})
```

Options du `spec` :

| Clé | Type | Description |
| :--- | :--- | :--- |
| `source` | string | Commande shell qui génère la liste (`find .`, `git ls-files`) |
| `source` | list | Liste Vim utilisée directement comme entrée |
| `sink` | string | Commande Vim (`e`, `tabe`, `colo`) |
| `sink` | funcref | Appelée avec chaque item sélectionné |
| `sinklist` (alias `sink*`) | funcref | Comme `sink`, mais reçoit toute la liste d'un coup |
| `exit` | funcref | Appelée avec le code de sortie fzf (0, 1, 2, 130) |
| `options` | string / list | Options fzf (`--multi`, `--preview`, ...) — préférer **list** pour éviter l'échappement |
| `dir` | string | Répertoire de travail |
| `up` / `down` / `left` / `right` | num / string | Layout : position et taille (`20`, `50%`) |
| `tmux` | string | Layout tmux (`90%,70%`, cf. `--tmux` de fzf) |
| `window` | string | Commande Vim pour créer la fenêtre (`vertical aboveleft 30new`) |
| `window` | dict | Popup (cf. `g:fzf_layout`) |

> **Options en liste** (pas en string) pour éviter les galères de quoting :
> ```vim
> call fzf#run({'options': ['--reverse', '--prompt', 'C:\Program Files\']})
> ```

## 5. `fzf#wrap([name], [spec], [fullscreen]) → dict`

Enrichit un `spec` pour respecter les variables globales (`g:fzf_action`, `g:fzf_layout`, `g:fzf_colors`, `g:fzf_history_dir`). Convention : `wrap` avant `run`.

```vim
call fzf#run(fzf#wrap({'source': 'ls'}))
```

Arguments (tous optionnels) :
- `name` (string) : nom pour l'historique (ignoré si `g:fzf_history_dir` non défini)
- `spec` (dict) : le spec à enrichir
- `fullscreen` (0/1, défaut 0)

### Pattern commande custom avec bang = fullscreen

```vim
" :LS  → popup, :LS! → plein écran, :LS /tmp → dir spécifique
command! -bang -complete=dir -nargs=? LS
    \ call fzf#run(fzf#wrap('ls', {'source': 'ls', 'dir': <q-args>}, <bang>0))
```
`<bang>0` vaut `0` pour `:LS` et `1` pour `:LS!`.

> `g:fzf_action` ne s'applique **que si** le spec n'a pas de `sink`/`sinklist` custom (sinon ouvrir via `tabedit` n'aurait pas de sens — l'item peut ne pas être un chemin).

## 6. Commandes `fzf.vim` utiles

| Commande | Action |
| :--- | :--- |
| `:Files [path]` | Recherche de fichiers (style Ctrl-P) |
| `:GFiles` | Fichiers suivis par Git |
| `:GFiles?` | `git status` — fichiers modifiés |
| `:Buffers` | Buffers ouverts |
| `:Colors` | Aperçu et sélection de colorschemes |
| `:Ag [query]` | Recherche via The Silver Searcher |
| `:Rg [query]` | Recherche via Ripgrep |
| `:Lines` / `:BLines` | Lignes dans tous les buffers / buffer courant |
| `:Tags` / `:BTags` | Tags globaux / du buffer courant |
| `:Marks` / `:Jumps` / `:Changes` | Marks, jumplist, changelist |
| `:History` | Fichiers récemment ouverts (`v:oldfiles`) |
| `:History:` / `:History/` | Historique des commandes / recherches |
| `:Commits` / `:BCommits` | Commits git globaux / du buffer |
| `:Helptags` / `:Maps` / `:Filetypes` | Tags d'aide / mappings / filetypes |

## 7. Tips

### Cacher la statusline en mode split
Quand `g:fzf_layout = { 'down': '40%' }` est utilisé, fzf ouvre un terminal buffer — le statusline parent peut distraire.
```vim
let g:fzf_layout = { 'down': '30%' }
autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
```

### Popup tmux si dispo, sinon popup Vim
```vim
if exists('$TMUX')
  let g:fzf_layout = { 'tmux': '90%,70%' }
else
  let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
endif
```

### Couleurs du terminal buffer
Sur Vim/Neovim récent, fzf tourne dans un terminal buffer. Si les couleurs ANSI paraissent off :
- **Neovim** : `g:terminal_color_0..15`
- **Vim** : `g:terminal_ansi_colors` (liste de 16 hex)

## 8. Recettes

### `:Locate` — recherche système
```vim
command! -nargs=1 -bang Locate call fzf#run(fzf#wrap(
  \ {'source': 'locate <q-args>', 'options': '-m'}, <bang>0))
```

### Ouvrir dans des splits (mappings rapides)
```vim
nnoremap <silent> <Leader>s :call fzf#run({
  \ 'down': '40%',
  \ 'sink': 'botright split' })<CR>

nnoremap <silent> <Leader>v :call fzf#run({
  \ 'right': winwidth('.') / 2,
  \ 'sink': 'vertical botright split' })<CR>
```

### Choisir un colorscheme
```vim
nnoremap <silent> <Leader>C :call fzf#run({
  \ 'source': map(split(globpath(&rtp, 'colors/*.vim'), '\n'),
  \               "substitute(fnamemodify(v:val, ':t'), '\\..\\{-}$', '', '')"),
  \ 'sink':    'colo',
  \ 'options': '+m',
  \ 'left':    30 })<CR>
```

### Sélecteur de buffer custom
```vim
function! s:buflist()
  redir => ls | silent ls | redir END
  return split(ls, '\n')
endfunction

function! s:bufopen(e)
  execute 'buffer' matchstr(a:e, '^[ 0-9]*')
endfunction

nnoremap <silent> <Leader><Enter> :call fzf#run({
  \ 'source':  reverse(<sid>buflist()),
  \ 'sink':    function('<sid>bufopen'),
  \ 'options': '+m',
  \ 'down':    len(<sid>buflist()) + 2 })<CR>
```

### MRU — fichiers récents
```vim
" Simple : v:oldfiles seul
command! FZFMru call fzf#run({
  \ 'source':  v:oldfiles,
  \ 'sink':    'e',
  \ 'options': '-m -x +s',
  \ 'down':    '40%'})

" Filtré : v:oldfiles + buffers ouverts, sans temporaires/git/NERDTree
command! FZFMru call fzf#run({
  \ 'source':  reverse(s:all_files()),
  \ 'sink':    'edit',
  \ 'options': '-m -x +s',
  \ 'down':    '40%' })

function! s:all_files()
  return extend(
    \ filter(copy(v:oldfiles),
    \        "v:val !~ 'fugitive:\\|NERD_tree\\|^/tmp/\\|.git/'"),
    \ map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), 'bufname(v:val)'))
endfunction
```

### `:Tags` — tags globaux avec preview
```vim
function! s:tags_sink(line)
  let parts = split(a:line, '\t\zs')
  let excmd = matchstr(parts[2:], '^.*\ze;"\t')
  execute 'silent e' parts[1][:-2]
  let [magic, &magic] = [&magic, 0]
  execute excmd
  let &magic = magic
endfunction

function! s:tags()
  if empty(tagfiles())
    echohl WarningMsg | echom 'Preparing tags' | echohl None
    call system('ctags -R')
  endif
  call fzf#run({
    \ 'source':  'cat '.join(map(tagfiles(), 'fnamemodify(v:val, ":S")')).
    \            '| grep -v -a ^!',
    \ 'options': '+m -d "\t" --with-nth 1,4.. -n 1 --tiebreak=index',
    \ 'down':    '40%',
    \ 'sink':    function('s:tags_sink')})
endfunction

command! Tags call s:tags()
```

### `:BTags` — tags du buffer courant
```vim
function! s:btags_source()
  let lines = map(split(system(printf(
    \ 'ctags -f - --sort=no --excmd=number --language-force=%s %s',
    \ &filetype, expand('%:S'))), "\n"), 'split(v:val, "\t")')
  if v:shell_error | throw 'failed to extract tags' | endif
  return map(s:align_lists(lines), 'join(v:val, "\t")')
endfunction

function! s:btags_sink(line)
  execute split(a:line, "\t")[2]
endfunction

function! s:btags()
  try
    call fzf#run({
      \ 'source':  s:btags_source(),
      \ 'options': '+m -d "\t" --with-nth 1,4.. -n 1 --tiebreak=index',
      \ 'down':    '40%',
      \ 'sink':    function('s:btags_sink')})
  catch
    echohl WarningMsg | echom v:exception | echohl None
  endtry
endfunction

command! BTags call s:btags()
```

### `:FZFLines` — recherche dans tous les buffers ouverts
```vim
function! s:line_handler(l)
  let keys = split(a:l, ':\t')
  exec 'buf' keys[0]
  exec keys[1]
  normal! ^zz
endfunction

function! s:buffer_lines()
  let res = []
  for b in filter(range(1, bufnr('$')), 'buflisted(v:val)')
    call extend(res, map(getbufline(b, 0, "$"),
      \ 'b . ":\t" . (v:key + 1) . ":\t" . v:val '))
  endfor
  return res
endfunction

command! FZFLines call fzf#run({
  \ 'source':  <sid>buffer_lines(),
  \ 'sink':    function('<sid>line_handler'),
  \ 'options': '--extended --nth=3..',
  \ 'down':    '60%'
  \ })
```

### `:Ag` → quickfix
Ctrl-X/V/T pour ouvrir dans split/vsplit/tab. Ctrl-A sélectionne tout, Ctrl-D désélectionne. Si plusieurs matchs sélectionnés → quickfix list.
```vim
function! s:ag_to_qf(line)
  let parts = split(a:line, ':')
  return {'filename': parts[0], 'lnum': parts[1], 'col': parts[2],
    \     'text': join(parts[3:], ':')}
endfunction

function! s:ag_handler(lines)
  if len(a:lines) < 2 | return | endif
  let cmd = get({'ctrl-x': 'split', 'ctrl-v': 'vertical split',
    \            'ctrl-t': 'tabe'}, a:lines[0], 'e')
  let list = map(a:lines[1:], 's:ag_to_qf(v:val)')
  let first = list[0]
  execute cmd escape(first.filename, ' %#\')
  execute first.lnum
  execute 'normal!' first.col.'|zz'
  if len(list) > 1
    call setqflist(list)
    copen
    wincmd p
  endif
endfunction

command! -nargs=* Ag call fzf#run({
  \ 'source':  printf('ag --nogroup --column --color "%s"',
  \            escape(empty(<q-args>) ? '^(?=.)' : <q-args>, '"\')),
  \ 'sink*':   function('<sid>ag_handler'),
  \ 'options': '--ansi --expect=ctrl-t,ctrl-v,ctrl-x --delimiter : --nth 4..
  \             --multi --bind=ctrl-a:select-all,ctrl-d:deselect-all
  \             --color hl:68,hl+:110',
  \ 'down':    '50%'
  \ })
```

### `:FZFNeigh` — fichiers voisins du fichier courant
```vim
function! s:fzf_neighbouring_files()
  let current_file = expand("%")
  let cwd = fnamemodify(current_file, ':p:h')
  let command = 'ag -g "" -f ' . cwd . ' --depth 0'
  call fzf#run({
    \ 'source':  command,
    \ 'sink':    'e',
    \ 'options': '-m -x +s',
    \ 'window':  'enew' })
endfunction

command! FZFNeigh call s:fzf_neighbouring_files()
```

### `:LoadTemplate` — insérer un template
```vim
function! s:read_template_into_buffer(template)
  execute '0r ~/.config/nvim/templates/'.a:template
endfunction

command! -bang -nargs=* LoadTemplate call fzf#run({
  \ 'source': 'ls -1 ~/.config/nvim/templates',
  \ 'down':   20,
  \ 'sink':   function('<sid>read_template_into_buffer')
  \ })
```
