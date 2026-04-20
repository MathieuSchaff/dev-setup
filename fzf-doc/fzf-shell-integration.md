# FZF : Intégration Shell et Utilitaires Système

Ce document regroupe les scripts et fonctions pour améliorer l'expérience au terminal.

## 1. Raccourcis Clavier Standard

L'installation de `fzf` active généralement ces trois raccourcis :
- `CTRL-T` : Sélectionne des fichiers/répertoires et colle le chemin sur la ligne de commande.
- `CTRL-R` : Recherche dans l'historique des commandes. Re-appuyer sur `Ctrl-R` pour trier par chronologie. `Alt-R` bascule en mode "raw" (contexte autour du résultat).
- `ALT-C` : Se déplace (`cd`) dans le répertoire sélectionné.

### Exécuter immédiatement depuis l'historique (`Ctrl-X Ctrl-R`)
Par défaut `Ctrl-R` colle la commande sur la ligne (à valider avec Entrée). Pour **exécuter tout de suite** sans Entrée :
```bash
# zsh
fzf-history-widget-accept() {
  fzf-history-widget
  zle accept-line
}
zle -N fzf-history-widget-accept
bindkey '^X^R' fzf-history-widget-accept

# bash
bind "$(bind -s | grep '^"\\C-r"' | sed 's/"/"\\C-x/' | sed 's/"$/\\C-m"/')"
```

## 2. Complétion Fuzzy (`**`)

Déclenchée par `**` suivi de `TAB` :
- `vim **<TAB>` : Sélection de fichiers pour Vim.
- `cd **<TAB>` : Sélection de répertoires uniquement.
- `ssh **<TAB>` : Sélection d'hôtes (depuis `/etc/hosts` ou `~/.ssh/config`).
- `kill **<TAB>` : Sélection de processus à tuer.
- `export **<TAB>` / `unset **<TAB>` : Sélection de variables d'environnement.

## 3. Utilitaires Système (Scripts & Fonctions)

### Gestion des Processus (Fuzzy Kill)
```bash
# fkill - kill processes - list only the ones you can kill.
fkill() {
  local pid
  if [ "$UID" != "0" ]; then
    pid=$(ps -f -u $USER | sed 1d | fzf -m | awk '{print $2}')
  else
    pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
  fi

  if [ "x$pid" != "x" ]; then
    echo $pid | xargs kill -${1:-9}
  fi
}
```

### Variables d'Environnement (`fenv`)
```bash
fenv() {
  local var
  var=$(env | fzf) && echo "$var"
}
```

### Services Systemd (`fsvc`)
```bash
fsvc() {
  systemctl list-units --type=service --all | fzf --preview 'systemctl status {1}' | awk '{print $1}' | xargs systemctl
}
```

## 4. Intégration d'Outils Tierces

### APT (Debian/Ubuntu)
```bash
# Recherche et installation de paquets
apt-search() {
  apt-cache search . | fzf --multi --preview 'apt-cache show {1}' | awk '{print $1}' | xargs -ro sudo apt install
}
```

### Flatpak
```bash
# Install depuis flathub (zsh widget, bindkey Alt-f Alt-i)
fzf-flatpak-install-widget() {
  flatpak remote-ls flathub --cached --columns=app,name,description |
    fzf --prompt='Install > ' \
        --preview 'flatpak --system remote-info flathub {1}' \
        --bind 'enter:execute(flatpak install flathub {1})'
  zle reset-prompt
}
zle -N fzf-flatpak-install-widget
bindkey '^[f^[i' fzf-flatpak-install-widget

# Uninstall / run (Alt-u / Alt-r pour basculer)
fzf-flatpak-uninstall-widget() {
  flatpak list --columns=application,name |
    fzf --prompt='Uninstall > ' \
        --header='M-u: Uninstall | M-r: Run' \
        --preview 'flatpak info {1}' \
        --bind 'alt-r:change-prompt(Run > )' \
        --bind 'alt-u:change-prompt(Uninstall > )' \
        --bind 'enter:execute(flatpak uninstall {1})'
  zle reset-prompt
}
zle -N fzf-flatpak-uninstall-widget
bindkey '^[f^[u' fzf-flatpak-uninstall-widget
```

### Conda (environnements)
```bash
# Sélection fuzzy d'env conda avec preview `conda tree leaves`
fzf-conda-activate() {
  local choice
  choice=$(conda env list | sed '/^#/d;/^$/d' | awk '{print $1"\t"$NF}' |
    fzf --layout=reverse --border=rounded --preview-window='right:30%' \
        --preview-label=' conda tree leaves ' \
        --preview 'conda tree -p {2} leaves 2>/dev/null | sort' |
    awk '{print $1}')
  [[ -n "$choice" ]] && conda activate "$choice"
}
```

### Password Store (`pass`)
```bash
# Complétion pour pass
_fzf_complete_pass() {
  _fzf_complete '' "$@" < <(
    find ~/.password-store/ -name "*.gpg" | sed -r 's,.*\.password-store/(.*)\.gpg,\1,'
  )
}
```

### Docker
```bash
# Entrer dans un container — essaie bash puis sh (certaines images n'ont pas bash)
docker-enter() {
  local container
  container=$(docker ps --format "{{.Names}}" | fzf)
  [[ -z "$container" ]] && return
  docker exec -it "$container" bash 2>/dev/null || docker exec -it "$container" sh
}

# da : start + attach à un container stoppé
da() {
  local cid
  cid=$(docker ps -a | sed 1d | fzf -1 -q "$1" | awk '{print $1}')
  [[ -n "$cid" ]] && docker start "$cid" && docker attach "$cid"
}

# ds : stop container (running only)
ds() {
  local cid
  cid=$(docker ps | sed 1d | fzf -q "$1" | awk '{print $1}')
  [[ -n "$cid" ]] && docker stop "$cid"
}

# drm : remove containers (multi-select)
drm() {
  docker ps -a | sed 1d | fzf -q "$1" --no-sort -m --tac | awk '{print $1}' | xargs -r docker rm
}

# drmi : remove images (multi-select)
drmi() {
  docker images | sed 1d | fzf -q "$1" --no-sort -m --tac | awk '{print $3}' | xargs -r docker rmi
}
```

### Ranger
Ajouter une commande `:fzf` dans Ranger pour naviguer rapidement.
*Plugin requis :* placer le script python dans `~/.config/ranger/plugins/fzf.py`.

## 5. Personnalisation de la Complétion Fuzzy

### Changer le déclencheur (par défaut `**`)
```bash
export FZF_COMPLETION_TRIGGER='~~'

# Ou : touche dédiée Ctrl-T pour la complétion, TAB reste normal
export FZF_COMPLETION_TRIGGER=''
bindkey '^T' fzf-completion
bindkey '^I' $fzf_default_completion
```
> Note zsh : si `setopt vi` est actif, il écrase TAB. Sourcer `.fzf.zsh` **après** `setopt vi`.

### Options globales de complétion
```bash
export FZF_COMPLETION_OPTS='--border --info=inline'
export FZF_COMPLETION_PATH_OPTS='--walker file,dir,follow,hidden'
export FZF_COMPLETION_DIR_OPTS='--walker dir,follow'
```

### Remplacer la source de complétion par `fd`
```bash
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}
```

### Preview par commande (`_fzf_comprun`)
```bash
_fzf_comprun() {
  local command=$1
  shift
  case "$command" in
    cd)           fzf --preview 'tree -C {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'"       "$@" ;;
    ssh)          fzf --preview 'dig {}'                  "$@" ;;
    *)            fzf --preview 'bat -n --color=always {}' "$@" ;;
  esac
}
```

### Complétion custom `_fzf_complete_*` (API expérimentale)

Étendre la complétion fzf à une commande spécifique :

```bash
# [ZSH] Complétion des branches pour `git co` (alias de git checkout)
_fzf_complete_git() {
  local branches
  branches=$(git branch -vv --all)
  if [[ $@ == 'git co'* ]]; then
    _fzf_complete --reverse --multi -- "$@" < <(echo "$branches")
  else
    eval "zle ${fzf_default_completion:-expand-or-complete}"
  fi
}
_fzf_complete_git_post() { awk '{print $1}'; }

# [ZSH] Complétion pour pass
_fzf_complete_pass() {
  _fzf_complete +m -- "$@" < <(
    local prefix="${PASSWORD_STORE_DIR:-$HOME/.password-store}"
    command find -L "$prefix" -name "*.gpg" -type f |
      sed -e "s#${prefix}/\{0,1\}##" -e 's#\.gpg##' | sort
  )
}

# [BASH] Complétion ssh/mosh sans trigger (**)
_fzf_complete_ssh_notrigger() {
  FZF_COMPLETION_TRIGGER='' _fzf_host_completion
}
complete -o bashdefault -o default -F _fzf_complete_ssh_notrigger ssh mosh

# [BASH/ZSH] Activer pour des commandes supplémentaires
_fzf_setup_completion path ag git kubectl
_fzf_setup_completion dir tree
```

## 6. Navigation et Ouverture de Fichiers

### `fe` — Ouvrir dans `$EDITOR` avec preview
```bash
fe() {
  IFS=$'\n' files=($(fzf --query="$1" --multi --select-1 --exit-0 \
    --preview='bat --color=always {}'))
  [[ -n "$files" ]] && ${EDITOR:-nvim} "${files[@]}"
}
```

### `fo` — Ouvrir avec `open` (Ctrl-O) ou `$EDITOR` (Ctrl-E / Entrée)
```bash
fo() {
  IFS=$'\n' out=("$(fzf --query="$1" --exit-0 --expect=ctrl-o,ctrl-e \
    --preview='bat --color=always {}')")
  local key=$(head -1 <<< "$out")
  local file=$(head -2 <<< "$out" | tail -1)
  if [[ -n "$file" ]]; then
    [[ "$key" == ctrl-o ]] && xdg-open "$file" || ${EDITOR:-nvim} "$file"
  fi
}
```

### `fif` — Recherche dans le contenu des fichiers (rg + fzf)
```bash
fif() {
  if [[ ! "$#" -gt 0 ]]; then echo "Need a search term"; return 1; fi
  rg --files-with-matches --no-messages "$1" | fzf \
    --preview "rg --ignore-case --pretty --context 10 '$1' {}"
}
```

### `f` / `fm` — Wrapper générique (zsh, fd + fzf → buffer)
Sélectionne des fichiers et pousse `cmd arg1 arg2 ...` sur le buffer d'édition.
```bash
# Exemples : f mv    → sélection, puis entrée cible
#            f 'echo Selected:' --extension mp3
#            fm rm  → idem, mais non-récursif (max-depth 1)
f() {
  local sels
  sels=( "${(@f)$(fd "${@:2}" | fzf --multi)}" )
  [[ -n "$sels" ]] && print -z -- "$1 ${sels[@]:q:q}"
}
fm() { f "$@" --max-depth 1 }
```

### `vf` — Ouvrir fichier via `locate` + vim
```bash
vf() {
  local files
  files=(${(f)"$(locate -Ai -0 $@ | grep -z -vE '~$' | fzf --read0 -0 -1 -m)"})
  [[ -n "$files" ]] && ${EDITOR:-nvim} -- $files
}
```

### `vg` — Grep + ouverture avec ligne exacte (ag)
```bash
# Ouvre le fichier sélectionné à la ligne du match
vg() {
  local file line
  read -r file line <<< "$(ag --nobreak --noheading "$@" | fzf -0 -1 | awk -F: '{print $1, $2}')"
  [[ -n "$file" ]] && ${EDITOR:-nvim} "$file" +$line
}
```

### `v` — Ouvrir depuis `~/.viminfo` (MRU vim)
```bash
v() {
  local files
  files=$(grep '^>' ~/.viminfo | cut -c3- |
    while read line; do
      [[ -f "${line/\~/$HOME}" ]] && echo "$line"
    done | fzf -m -q "$*" -1) && ${EDITOR:-nvim} ${files//\~/$HOME}
}

# Variante fasd (plus riche : fréquence + récence)
v() {
  local file
  file="$(fasd -Rfl "$1" | fzf -1 -0 --no-sort +m)" && ${EDITOR:-nvim} "$file"
}
```

## 7. Navigation de Répertoires

### `fd` / `fda` — cd fuzzy
```bash
# cd vers un sous-répertoire (sans hidden)
fd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune -o -type d -print 2>/dev/null | fzf +m)
  [[ -n "$dir" ]] && cd "$dir"
}

# cd incluant les répertoires cachés
fda() {
  local dir
  dir=$(find ${1:-.} -type d 2>/dev/null | fzf +m) && cd "$dir"
}
```

### `fdr` — cd vers un répertoire parent
```bash
fdr() {
  local dirs=()
  get_parent_dirs() {
    [[ -d "$1" ]] && dirs+=("$1") || return
    [[ "$1" == '/' ]] && printf '%s\n' "${dirs[@]}" || get_parent_dirs "$(dirname "$1")"
  }
  local DIR=$(get_parent_dirs "$(realpath "${1:-$PWD}")" | fzf --tac)
  cd "$DIR"
}
```

### `cdf` — cd vers le répertoire du fichier sélectionné
```bash
cdf() {
  local file dir
  file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
}
```

## 8. Historique de Commandes

### `fh` — Exécuter une commande de l'historique
```bash
# zsh : print -z pousse sur le buffer d'édition (commande modifiable avant exécution)
fh() {
  print -z $(fc -l 1 | fzf +s --tac | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
}

# bash : eval exécute directement
fh() {
  eval $(history | fzf +s --tac | sed -E 's/ *[0-9]+ *//')
}
```

## 9. Intégration Tmux

### `tm` — Attacher ou créer une session
```bash
tm() {
  [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
  if [[ $1 ]]; then
    tmux $change -t "$1" 2>/dev/null || (tmux new-session -d -s "$1" && tmux $change -t "$1")
    return
  fi
  local session
  session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) \
    && tmux $change -t "$session" || echo "No sessions found."
}
```

### `fs` — Switch de session
```bash
fs() {
  local session
  session=$(tmux list-sessions -F "#{session_name}" | \
    fzf --query="$1" --select-1 --exit-0) &&
  tmux switch-client -t "$session"
}
```

### `ftpane` — Switch de pane
```bash
ftpane() {
  local panes current_window current_pane target target_window target_pane
  panes=$(tmux list-panes -s -F '#I:#P - #{pane_current_path} #{pane_current_command}')
  current_pane=$(tmux display-message -p '#I:#P')
  current_window=$(tmux display-message -p '#I')
  target=$(echo "$panes" | grep -v "$current_pane" | fzf +m --reverse) || return
  target_window=$(echo $target | awk 'BEGIN{FS=":|-"} {print$1}')
  target_pane=$(echo $target | awk 'BEGIN{FS=":|-"} {print$2}' | cut -c1)
  if [[ $current_window -eq $target_window ]]; then
    tmux select-pane -t ${target_window}.${target_pane}
  else
    tmux select-pane -t ${target_window}.${target_pane} && tmux select-window -t $target_window
  fi
}
# Dans tmux.conf : bind-key 0 run "tmux split-window -p 40 'bash -ci ftpane'"
```

### `tmuxkillf` — Kill de sessions (multi-select)
```bash
tmuxkillf() {
  local sessions
  sessions="$(tmux ls | fzf --exit-0 --multi)" || return $?
  local i
  for i in "${(f@)sessions}"; do
    [[ $i =~ '([^:]*):.*' ]] && { echo "Killing $match[1]"; tmux kill-session -t "$match[1]"; }
  done
}
```

## 10. Kubectl

Remplacer la complétion kubectl standard par fzf :
```bash
# Bash
command -v fzf >/dev/null 2>&1 && {
  source <(kubectl completion bash | sed 's#"${requestComp}" 2>/dev/null#"${requestComp}" 2>/dev/null | head -n -1 | fzf --multi=0 #g')
}

# Zsh
command -v fzf >/dev/null 2>&1 && {
  source <(kubectl completion zsh | sed 's#${requestComp} 2>/dev/null#${requestComp} 2>/dev/null | head -n -1 | fzf --multi=0 #g')
}
```
Utilisation : `kubectl get pods <TAB><TAB>` ouvre fzf avec la liste des pods.

## 11. Favoris Personnalisés (Bookmarks `cdg`)

```bash
# ~/.cdg_paths : un chemin par ligne, # pour commenter
cdg() {
  local dest_dir=$(sed 's/#.*//' ~/.cdg_paths | sed '/^\s*$/d' | fzf)
  [[ -n "$dest_dir" ]] && cd "$dest_dir"
}
```

## 12. Marque-pages Chrome (Ruby)

Naviguer et ouvrir des marque-pages Google Chrome depuis le terminal :
```bash
b() {
  local open output
  open=xdg-open
  output=$(ruby << 'EORUBY'
require 'json'
FILE = '~/.config/google-chrome/Default/Bookmarks'
CJK = /\p{Han}|\p{Katakana}|\p{Hiragana}|\p{Hangul}/

def build(parent, json)
  name = [parent, json['name']].compact.join('/')
  json['type'] == 'folder' ?
    json['children'].map { |c| build(name, c) } :
    { name: name, url: json['url'] }
end

width = `tput cols`.to_i / 2
json = JSON.load(File.read(File.expand_path(FILE)))
items = json['roots'].values_at(*%w(bookmark_bar synced other)).compact
  .flat_map { |e| build(nil, e) }

items.each do |item|
  name = item[:name].to_s
  puts [name.ljust(width), item[:url]].join("\t\x1b[36m") + "\x1b[m"
end
EORUBY
)
  echo -e "$output" |
    fzf --ansi --multi --no-hscroll --tiebreak=begin |
    awk 'BEGIN{FS="\t"}{print $2}' |
    xargs -I{} $open {} &>/dev/null
}
```

## 13. Clipboard Wayland (`wl-copy`)

Bind `Ctrl-Y` : copie l'entrée courante vers le presse-papier Wayland.
```bash
export FZF_DEFAULT_OPTS='--bind "ctrl-y:execute-silent(printf {} | cut -f 2- | wl-copy --trim-newline)"'
```
> `execute-silent` requis : `execute` attend la fin de `wl-copy` et bloque.
> Fallback XWayland : remplacer par `xclip -selection clipboard`.

## 14. Pages de Manuel (`fman`)

### Version simple avec preview `bat`
```bash
fman() {
  man -k . | fzf -q "$1" --prompt='man> ' \
    --preview 'echo {} | tr -d "()" | awk "{printf \"%s \", \$2} {print \$1}" | xargs -r man | col -bx | bat -l man -p --color always' |
  tr -d '()' | awk '{printf "%s ", $2} {print $1}' | xargs -r man
}

# Optionnel : MANPAGER coloré via bat
export MANPAGER="sh -c 'col -bx | bat -l man -p --paging always'"
```

### Widget zsh (ne ferme pas fzf)
Bindings : `Alt-c` → cheat.sh, `Alt-m` → man, `Alt-t` → tldr.
```bash
fzf-man-widget() {
  local manpage batman
  manpage='echo {} | sed "s/\([[:alnum:][:punct:]]*\) (\([[:alnum:]]*\)).*/\2 \1/"'
  batman="${manpage} | xargs -r man | col -bx | bat --language=man --plain --color always"
  man -k . | sort |
    awk -v c=$(tput setaf 6) -v b=$(tput setaf 4) -v r=$(tput sgr0) '{ $1=c$1; $2=r b$2 } 1' |
    fzf -q "$1" --ansi --tiebreak=begin --prompt=' Man > ' \
        --preview-window '50%,rounded,<50(up,85%,border-bottom)' \
        --preview "${batman}" \
        --bind "enter:execute(${manpage} | xargs -r man)" \
        --bind "alt-c:+change-preview(cht.sh {1})+change-prompt('Cheat > ')" \
        --bind "alt-m:+change-preview(${batman})+change-prompt('Man > ')" \
        --bind "alt-t:+change-preview(tldr --color=always {1})+change-prompt('TLDR > ')"
  zle reset-prompt
}
zle -N fzf-man-widget
bindkey '^h' fzf-man-widget
```

## 15. Bookmarks CLI (`buku`)

> Gestionnaire de bookmarks SQLite indépendant du navigateur. `sudo apt install buku`.

```bash
# Helper : IDs des bookmarks sélectionnés
get_buku_ids() {
  buku -p -f 5 | fzf --tac --layout=reverse-list -m | cut -d $'\t' -f 1
}

# fb : ouvrir (multi)
fb() {
  local ids=( $(get_buku_ids) )
  [[ -z $ids ]] && return 1
  buku --open ${ids[@]}
}

# fbu : mettre à jour (passe les args après sélection)
fbu() {
  local ids=( $(get_buku_ids) )
  [[ -z $ids ]] && return 0
  buku --update ${ids[@]} "$@"
}

# fbw : refresh titre/meta depuis le web
fbw() {
  local ids=( $(get_buku_ids) )
  for i in ${ids[@]}; do buku --write $i; done
}
```

## 16. Readline (bash)

`Ctrl-X 1` : insère le nom d'une fonction readline via fzf — utile pour découvrir/rebinder.
```bash
__fzf_readline() {
  builtin eval "
    builtin bind '\"\C-x3\": $(builtin bind -l | command fzf +s +m --toggle-sort=ctrl-r)'
  "
}
builtin bind -x '"\C-x2": __fzf_readline'
builtin bind '"\C-x1": "\C-x2\C-x3"'
```

## 17. npm Scripts (`fns`)

Lance un script défini dans `package.json` via fzf. Nécessite `jq`.
```bash
fns() {
  local script
  script=$(jq -r '.scripts | keys[]' package.json | sort | fzf) && npm run "$script"
}

# Variante bun
fnb() {
  local script
  script=$(jq -r '.scripts | keys[]' package.json | sort | fzf) && bun run "$script"
}
```
