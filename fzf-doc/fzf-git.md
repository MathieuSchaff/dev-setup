# FZF : Workflow Git

L'usage de `fzf` avec Git permet de transformer des commandes complexes en sélections interactives simples.

## 1. Raccourcis pour objets Git (Recommandé)

Ces raccourcis peuvent être configurés pour injecter des identifiants dans vos commandes en cours.

| Raccourci | Objet Git | Action |
| :--- | :--- | :--- |
| `CTRL-G CTRL-F` | Fichiers | Sélectionne des fichiers depuis `git status` |
| `CTRL-G CTRL-B` | Branches | Sélectionne une branche |
| `CTRL-G CTRL-H` | Commits | Sélectionne un hash de commit depuis le log |

## 2. Scripts Utilitaires

### Checkout de branche (`fco`)
```bash
# fco - checkout git branch/tag
fco() {
  local tags branches target
  tags=$(git tag | awk '{print "\x1b[31;1mtag\x1b[m\t" $1}') || return
  branches=$(git branch --all | grep -v HEAD |
    sed "s/.* //" | sed "s#remotes/[^/]*/##" |
    sort -u | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}') || return
  target=$( (echo "$tags"; echo "$branches") |
    fzf-tmux -l30 -- --ansit --no-hscroll --reverse --tiebreak=index -d$'\t' -n2) || return
  git checkout $(echo "$target" | awk '{print $2}')
}
```

### Gestion des Stash (`fstash`)
```bash
# fstash - manage git stashes
fstash() {
  local out q k sha
  while out=$(
    git stash list --pretty="%C(yellow)%gd %>(14)%Cgreen%cr %C(reset)%s %C(cyan)%b" |
    fzf --ansi --no-sort --query="$q" --print-query \
        --expect=ctrl-d,ctrl-b);
  do
    mapfile -t out <<< "$out"
    q="${out[0]}"
    k="${out[1]}"
    sha="${out[2]}"
    sha="${sha%% *}"
    [[ -z "$sha" ]] && continue
    if [[ "$k" == 'ctrl-d' ]]; then
      git stash drop "$sha"
    elif [[ "$k" == 'ctrl-b' ]]; then
      git stash branch "stash-$sha" "$sha"
      break
    else
      git stash show -p "$sha" | bat
    fi
  done
}
```

### Ajout de fichiers (`fza`)
```bash
# fza - fuzzy add multiple files
fza() {
  local files
  files=$(git status -s | fzf -m | awk '{print $2}')
  if [[ -n "$files" ]]; then
    git add $files
  fi
}
```

## 3. Scripts Git Avancés

### Rebase interactif depuis un commit (`frebase`)
```bash
frebase() {
  local commit
  commit=$(git log --oneline | fzf --preview 'git show --stat {1}' | awk '{print $1}')
  [[ -n "$commit" ]] && git rebase -i "$commit"^
}
```

### Fixup d'un commit passé (`ffix`)
```bash
ffix() {
  local commit
  commit=$(git log --oneline | fzf --preview 'git show --stat {1}' | awk '{print $1}')
  [[ -n "$commit" ]] && git commit --fixup="$commit"
}
```

### Éditer des fichiers modifiés/non suivis (`fed`)
```bash
fed() {
  local files
  files=$(git status -s | fzf -m | awk '{print $2}')
  [[ -n "$files" ]] && ${EDITOR:-nvim} $files
}
```

### Éditer les fichiers en conflit (`fedconflicts`)
```bash
fedconflicts() {
  local files
  files=$(git diff --name-only --diff-filter=U | fzf -m)
  [[ -n "$files" ]] && ${EDITOR:-nvim} $files
}
```

### Grep dans l'historique git (`gfg`)
> Renommé depuis `fgrep` pour éviter la collision avec `fgrep` (grep -F) installé par défaut.
```bash
# gfg PATTERN [PATHSPEC]
gfg() {
  git grep --line-number "$1" "${2:-.}" | fzf --ansi \
    --delimiter : \
    --preview 'bat --color=always {1} --highlight-line {2}' \
    --bind 'enter:become(nvim {1} +{2})'
}
```

### Éditer un fichier depuis un commit passé (`fedlog`)
```bash
fedlog() {
  local commit file
  commit=$(git log --oneline | fzf | awk '{print $1}')
  [[ -z "$commit" ]] && return
  file=$(git show --name-only "$commit" | tail -n +6 | fzf)
  [[ -n "$file" ]] && git show "$commit:$file" | ${EDITOR:-nvim} -
}
```

### Soft reset vers un commit passé (`freset`)
```bash
# Annuler avec : git reset ORIG_HEAD
freset() {
  local commit
  commit=$(git log --oneline | fzf --preview 'git show --stat {1}' | awk '{print $1}')
  [[ -n "$commit" ]] && git reset "$commit"
}
```

## 3b. Scripts Git Supplémentaires

### `fbr` — Checkout branche (avec branches distantes)
```bash
fbr() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD)
  branch=$(echo "$branches" | fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m)
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# Version triée par dernier commit (30 branches)
fbr() {
  local branches branch
  branches=$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)")
  branch=$(echo "$branches" | fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m)
  git checkout $(echo "$branch" | sed "s/.* //")
}
```

### `fco_preview` — Checkout avec preview des commits
```bash
fco_preview() {
  local tags branches target
  branches=$(git --no-pager branch --all \
    --format="%(if)%(HEAD)%(then)%(else)%(if:equals=HEAD)%(refname:strip=3)%(then)%(else)%1B[0;34;1mbranch%09%1B[m%(refname:short)%(end)%(end)" \
    | sed '/^$/d') || return
  tags=$(git --no-pager tag | awk '{print "\x1b[35;1mtag\x1b[m\t" $1}') || return
  target=$((echo "$branches"; echo "$tags") |
    fzf --no-hscroll --no-multi -n 2 --ansi \
        --preview="git --no-pager log -150 --pretty=format:%s '..{2}'") || return
  git checkout $(awk '{print $2}' <<< "$target")
}
```

### `fcoc` — Checkout d'un commit
```bash
fcoc() {
  local commits commit
  commits=$(git log --pretty=oneline --abbrev-commit --reverse)
  commit=$(echo "$commits" | fzf --tac +s +m -e)
  [[ -n "$commit" ]] && git checkout $(echo "$commit" | sed "s/ .*//")
}
```

### `fshow` — Navigateur de commits avec diff
```bash
fshow() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
        (grep -o '[a-f0-9]\{7\}' | head -1 |
        xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
        {}
FZF-EOF"
}
```

### `fshow_preview` — Navigateur de commits avec diff-so-fancy
```bash
alias glNoGraph='git log --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr %C(auto)%an" "$@"'
_gitLogLineToHash="echo {} | grep -o '[a-f0-9]\{7\}' | head -1"
_viewGitLogLine="$_gitLogLineToHash | xargs -I % sh -c 'git show --color=always % | diff-so-fancy'"

fshow_preview() {
  glNoGraph |
  fzf --no-sort --reverse --tiebreak=index --no-multi --ansi \
      --preview="$_viewGitLogLine" \
      --header "enter to view, alt-y to copy hash" \
      --bind "enter:execute:$_viewGitLogLine | less -R" \
      --bind "alt-y:execute:$_gitLogLineToHash | wl-copy"
}
```

### `fcs` — Copier un hash de commit
```bash
# Usage : git rebase -i `fcs`
fcs() {
  local commits commit
  commits=$(git log --color=always --pretty=oneline --abbrev-commit --reverse)
  commit=$(echo "$commits" | fzf --tac +s +m -e --ansi --reverse)
  echo -n $(echo "$commit" | sed "s/ .*//")
}
```

### `fgst` — Sélecteur de fichiers depuis `git status`
```bash
is_in_git_repo() { git rev-parse HEAD >/dev/null 2>&1; }

fgst() {
  is_in_git_repo || return
  local cmd="${FZF_CTRL_T_COMMAND:-"command git status -s"}"
  eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS" \
    fzf -m "$@" | while read -r item; do
      echo "$item" | awk '{print $2}'
    done
  echo
}
```

### `git-fixup` — Fixup interactif
```bash
git-fixup() {
  git log --oneline -n 20 | fzf | cut -f1 -d' ' | xargs git commit --fixup
}
# Puis : git rebase -i master --autosquash
```

### `gh-watch` — Surveiller les GitHub Actions de la branche courante
```bash
gh-watch() {
  gh run list \
    --branch $(git rev-parse --abbrev-ref HEAD) \
    --json status,name,databaseId |
  jq -r '.[] | select(.status != "completed") | (.databaseId | tostring) + "\t" + (.name)' |
  fzf -1 -0 | awk '{print $1}' | xargs gh run watch
}
```

### `ftags` — Rechercher dans les ctags avec preview
```bash
ftags() {
  local line
  [[ -e tags ]] &&
  line=$(
    awk 'BEGIN { FS="\t" } !/^!/ {print toupper($4)"\t"$1"\t"$2"\t"$3}' tags |
    fzf --nth=1,2 --with-nth=2 --preview-window="50%" \
        --preview="bat {3} --color=always | tail -n +\$(echo {4} | tr -d ';\"\'')"
  ) && ${EDITOR:-nvim} $(cut -f3 <<< "$line") -c "set nocst" \
       -c "silent tag $(cut -f2 <<< "$line")"
}
```

## 4. Intégration Ripgrep

### `rfv` — Filtrage statique (rg pré-filtre, fzf affine)
```bash
#!/usr/bin/env bash
# rfv QUERY : rg trouve, fzf affine de façon fuzzy, nvim ouvre
rg --color=always --line-number --no-heading --smart-case "${*:-}" |
  fzf --ansi \
      --color "hl:-1:underline,hl+:-1:underline:reverse" \
      --delimiter : \
      --preview 'bat --color=always {1} --highlight-line {2}' \
      --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
      --bind 'enter:become(nvim {1} +{2})'
```

### `rgl` — Launcher interactif (rg se relance à chaque frappe)
Chaque frappe relance rg — recherche en temps réel, pas de fuzzy (rg fait tout).
```bash
#!/usr/bin/env bash
# rgl QUERY : rg interactif rechargé à chaque frappe
RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
INITIAL_QUERY="${*:-}"
fzf --ansi --disabled --query "$INITIAL_QUERY" \
    --bind "start:reload:$RG_PREFIX {q} || true" \
    --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
    --delimiter : \
    --preview 'bat --color=always {1} --highlight-line {2}' \
    --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
    --bind 'enter:become(nvim {1} +{2})'
```

### `rgi` — Mode hybride (bascule rg ↔ fzf avec `Alt-Enter`)
Phase 1 : rg en launcher. `Alt-Enter` bascule en mode fuzzy fzf pur.
```bash
#!/usr/bin/env bash
RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
INITIAL_QUERY="${*:-}"
fzf --ansi --disabled --query "$INITIAL_QUERY" \
    --bind "start:reload:$RG_PREFIX {q}" \
    --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
    --bind "alt-enter:unbind(change,alt-enter)+change-prompt(fzf> )+enable-search+clear-query" \
    --color "hl:-1:underline,hl+:-1:underline:reverse" \
    --prompt '1. rg> ' \
    --delimiter : \
    --preview 'bat --color=always {1} --highlight-line {2}' \
    --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
    --bind 'enter:become(nvim {1} +{2})'
```
