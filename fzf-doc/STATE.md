# État actuel — configuration fzf

Snapshot du 2026-04-21. Décrit où vit la config fzf, qui l'utilise, et comment.

> **Historique** : audit config vs `fzf-doc/*.md` le 2026-04-21 → 3 fixes appliqués (theme Catppuccin complet, Ctrl+R scheme=history, `_fzf_compgen_*` via fd). Voir section *Décisions* en bas.

## Binaire

- **Install** : clone git `~/.fzf/` (upstream `junegunn/fzf`), binaire `~/.fzf/bin/fzf`
- **Version** : 0.71.0 (62899fd7)
- **PATH** : ajouté par `.fzf.zsh` si absent (`$HOME/.fzf/bin`)
- **Install script** : `scripts/bootstrap.sh:234-244` (clone + `./install --all --no-update-rc`)
- **Update** : `scripts/update-tools.sh` (catégorie `fzf`, `git pull` + `./install --bin`)

## Fichier principal

**`~/dev-setup/config/.fzf.zsh`** (93 lignes) — tout le gros est ici :

| Zone | Lignes | Rôle |
|------|--------|------|
| PATH + shell integration | 4-8 | `source <(fzf --zsh)` |
| Theme Catppuccin + defaults | 10-18 | `FZF_DEFAULT_OPTS`, `FZF_DEFAULT_COMMAND=fdfind` |
| `Ctrl+T` | 20-25 | fichier + preview bat, walker-skip `.git,node_modules,target,.venv` |
| Clipboard detect | 27-34 | `xclip` sinon `wl-copy` |
| `Ctrl+R` | 36-46 | history + `scheme=history`, `--no-sort`, `--exact`, `Ctrl+Y` copier |
| `Alt+C` | 48-49 | désactivé (remplacé par `Ctrl+F`) |
| `_fzf_compgen_path/dir` | 51-58 | complétion `**<TAB>` via fdfind (respect gitignore) |
| fzf-tab theming | 60-74 | popup tmux (`ftb-tmux-popup`), couleurs re-injectées |
| `zdf()` + `Ctrl+F` | 76-92 | widget fuzzy-cd avec preview eza tree |

**Pas symlinké** sous `~/`. Sourcé directement depuis `.zshrc:144` :
```zsh
[ -f "$HOME/dev-setup/config/.fzf.zsh" ] && source "$HOME/dev-setup/config/.fzf.zsh"
```

## Fichiers qui utilisent / référencent fzf

### `config/.zshrc`
- **L11** : plugin oh-my-zsh `fzf-tab` activé
- **L75** : complétion `_update_tools` liste `fzf` comme tool gérable
- **L108-115** : fonction `cs()` — parcourt `~/dev-setup/cheatsheet/*.md` via fzf + preview glow
- **L121-134** : widget `cheat-browse-widget` (`Ctrl+E` / `Alt+P`) — même logique en widget ZLE
- **L144** : `source .fzf.zsh`

### `config/.bashrc`
- **L122** : `[ -f ~/.fzf.bash ] && source ~/.fzf.bash` (legacy bash, non utilisé en pratique)

### `config/.tmux.conf`
- **L104-105** : `bind -n M-u display-popup` — switcher sessions via `tmux ls | fzf --reverse`

### `config/.config/navi/config.yaml`
- **L20-22** : `finder.command: fzf` avec override `--height 50% --layout=reverse --border`
- navi appelé via widget `Ctrl+N` dans `.zshrc:118-119`

## Plugin zsh associé

**`fzf-tab`** — plugin oh-my-zsh custom, cloné par `scripts/bootstrap.sh:121` depuis `github.com/Aloxaf/fzf-tab`. Chargé via la ligne `plugins=(... fzf-tab)` dans `.zshrc:11`. Config (`zstyle`) dans `.fzf.zsh:60-74`.

## Commandes du shell fzf-powered

| Binding | Déclencheur | Source |
|---------|-------------|--------|
| `Ctrl+T` | fichier picker | `fzf --zsh` (shell integration) |
| `Ctrl+R` | history search | `fzf --zsh` |
| `Alt+C` | **désactivé** | `FZF_ALT_C_COMMAND=''` |
| `Ctrl+F` | `zdf-widget` fuzzy-cd | `.fzf.zsh:92` |
| `Ctrl+N` | navi widget | `.zshrc:119` |
| `Alt+P` | `cheat-browse-widget` | `.zshrc:134` |
| `Alt+U` (tmux) | switcher sessions | `.tmux.conf:105` |
| `Tab` (complétion) | fzf-tab popup | plugin oh-my-zsh |

## Fonctions qui invoquent fzf directement

- `zdf()` → `.fzf.zsh:77-80` (fuzzy-cd non-widget)
- `zdf-widget()` → `.fzf.zsh:83-91`
- `_fzf_compgen_path/dir()` → `.fzf.zsh:53-58` (utilisées par `**<TAB>`)
- `cs()` → `.zshrc:108-115`
- `cheat-browse-widget()` → `.zshrc:122-132`

## Documentation (ce dossier `fzf-doc/`)

| Fichier | Contenu |
|---------|---------|
| `fzf-core.md` | Base fzf — syntaxe, options |
| `fzf-shell-integration.md` | `Ctrl+T`/`Ctrl+R`/`Alt+C`, widgets |
| `fzf-theming.md` | Couleurs, Catppuccin, `FZF_DEFAULT_OPTS` |
| `fzf-tab.md` | Plugin fzf-tab config |
| `fzf-git.md` | Workflows git + fzf |
| `fzf-project.md` | Navigation projets |
| `fzf-vim.md` | Intégration vim/neovim |

Pas de `cheatsheet/fzf.md` en place (malgré mention dans mémoire — corrigée).

## Décisions

### Duplication des couleurs entre `FZF_DEFAULT_OPTS` et `fzf-flags`

**État actuel** : le thème Catppuccin est défini **deux fois** dans `.fzf.zsh` :
- L14-17 : `FZF_DEFAULT_OPTS` → couvre toutes invocations fzf (Ctrl+T, Ctrl+R, widgets custom, commandes directes)
- L71-74 : `zstyle ':fzf-tab:*' fzf-flags` → couvre le popup fzf-tab (Tab de complétion)

**Pourquoi la duplication** : fzf-tab **n'hérite pas** de `FZF_DEFAULT_OPTS` par défaut. Sans `fzf-flags`, le popup de complétion s'afficherait avec les couleurs fzf standard — cassure visuelle avec le reste du shell Catppuccin.

**Alternative évaluée et rejetée** : `zstyle ':fzf-tab:*' use-fzf-default-opts yes` (cf. `fzf-tab.md:80-81`) ferait hériter `FZF_DEFAULT_OPTS`, éliminant la duplication. **Non retenu** — la doc mentionne l'issue GitHub Aloxaf/fzf-tab#455 : certains flags de `FZF_DEFAULT_OPTS` (notamment `--bind` custom et `--height`) cassent le popup fzf-tab. Le risque n'est pas pris : la duplication est explicite et maîtrisée (deux blocs de 4 lignes), la maintenance est acceptable.

**Si modification theme** : penser à mettre à jour **les deux blocs** (L14-17 et L71-74).

### Fixes appliqués le 2026-04-21 (audit vs `fzf-doc/`)

1. **Theme Catppuccin complété** (L14-22, L71-74)
   - `marker` : `#f4dbd6` → `#b7bdf8` (distinction visuelle avec `pointer`)
   - Ajout `selected-bg:#494d64` (ligne multi-sélection visible)
   - Retrait doublon `header:#ed8796` (déjà défini plus haut)
2. **`FZF_CTRL_R_OPTS`** (L41-43) : ajout `--scheme=history --no-sort --exact` pour comportement history-optimal
3. **Complétion `**<TAB>`** (L51-58) : `_fzf_compgen_path/dir` routent vers `fdfind` (respect `.gitignore`, plus rapide que `find`)
4. **Popup tmux pour fzf** (L11-22) : `FZF_DEFAULT_OPTS` utilise `--tmux center,80%,60%` dans tmux (popup flottant), fallback `--height 40%` hors tmux. Plus lisible que le shrink du pane, couvre Ctrl+T / Ctrl+R / Ctrl+F / cs / etc.
5. **`fnb()` / `fns()`** (`.zshrc` près de `_bun`) : picker fzf des scripts `package.json` → `bun run` / `npm run`. Dépend de `jq` (déjà installé).
6. **`fman()`** (`.zshrc`) : man-page browser via `man -k .` + fzf + preview `bat -l man`. Appel : `fman` ou `fman <topic>`.

### Module binaire fzf-tab (activé)

Installé le 2026-04-21. Compile un module C qui remplace le parser `LS_COLORS` en zsh pur → popup fzf-tab plus rapide sur gros dossiers.

**Deps apt** requises pour compiler (zsh source + autotools) :
```bash
sudo apt install -y autoconf build-essential libncurses-dev
```
- `autoconf` — génère `./configure` depuis `configure.ac` (l'erreur initiale `autoconf: not found`)
- `build-essential` — `gcc`, `make`, headers libc
- `libncurses-dev` — headers ncurses (requis pour compiler zsh source)

**Build** : `build-fzf-tab-module` (fourni par le plugin, clone zsh-5.9 + compile dans `~/.oh-my-zsh/custom/plugins/fzf-tab/modules/`). Chargé auto au prochain lancement de shell.

> Si bootstrap sur nouvelle machine : ajouter ces 3 paquets à `scripts/bootstrap.sh` (ou accepter le fallback zsh pur).

### Pas fait (volontairement)
- `_fzf_comprun` (preview par commande) — pas d'usage intensif de `**<TAB>`
- `Ctrl+X Ctrl+R` execute-immediate history widget — habitude acquise avec Entrée
- **`fzf-git.sh`** upstream (`Ctrl+G Ctrl+F/B/H`) — **conflit direct** avec `.tmux.conf:99` qui bind `Ctrl+G` (sans préfixe) vers popup lazygit. Sous tmux, les bindings `Ctrl+G Ctrl+*` de fzf-git ne remonteraient jamais au shell. Lazygit couvre déjà 95% du workflow git. Si besoin one-shot : `git log --oneline | fzf`.
- fzf.vim — Neovim utilise AstroNvim (Telescope), pas fzf.vim

## Résumé

Config **centralisée** dans `.fzf.zsh`, **sourcée** (non symlinkée) par `.zshrc`. Refs **dispersées** mais ciblées : `.zshrc` (usages applicatifs), `.tmux.conf` (popup sessions), `navi/config.yaml` (finder), `.bashrc` (legacy). Binaire upstream, géré par `bootstrap.sh` et `update-tools.sh`. Theme Catppuccin défini en double (`FZF_DEFAULT_OPTS` + `fzf-flags`) — voir section *Décisions*.
