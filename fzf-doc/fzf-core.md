# FZF : Guide de Référence et Configuration Core

Ce document regroupe les informations essentielles sur le fonctionnement interne, la syntaxe de recherche et la configuration globale de `fzf`.

## 1. Syntaxe de Recherche (Extended Search Mode)

Par défaut, `fzf` utilise un algorithme de recherche floue (fuzzy), mais vous pouvez affiner les résultats avec des opérateurs spécifiques.

| Jeton | Type de correspondance | Description |
| :--- | :--- | :--- |
| `sbtrkt` | fuzzy-match | Éléments qui correspondent à `sbtrkt` |
| `'wild` | exact-match | Éléments qui incluent `wild` exactement |
| `'wild'` | exact-boundary-match | Éléments qui incluent `wild` aux limites de mot |
| `^music` | prefix-exact-match | Éléments qui commencent par `music` |
| `.mp3$` | suffix-exact-match | Éléments qui finissent par `.mp3` |
| `!fire` | inverse-exact-match | Éléments qui n'incluent pas `fire` |
| `!^music` | inverse-prefix-exact-match | Éléments qui ne commencent pas par `music` |
| `!.mp3$` | inverse-suffix-exact-match | Éléments qui ne finissent pas par `.mp3` |

**Astuces de recherche :**
- L'espace agit comme un **ET**. Exemple : `^core go$ | rb$ | py$` (commence par `core` ET finit par `go`, `rb` ou `py`).
- Le caractère `|` agit comme un **OU**.
- Utilisez `-e` ou `--exact` pour désactiver le flou par défaut.

## 2. Variables d'Environnement Globales

Ces variables permettent de configurer le comportement de `fzf` pour toutes les commandes.

### FZF_DEFAULT_COMMAND
Définit la commande utilisée pour générer la liste par défaut (quand on tape juste `fzf`).
```bash
# Utiliser fd (plus rapide que find) en respectant le .gitignore
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
```

### Options Walker (alternative à FZF_DEFAULT_COMMAND)
Depuis fzf 0.53+, `--walker` remplace avantageusement `FZF_DEFAULT_COMMAND` pour le parcours de fichiers :
```bash
# Équivalent fd mais natif (pas de dépendance externe)
export FZF_DEFAULT_OPTS='--walker=file,dir,follow,hidden --walker-skip=.git,node_modules'
# --walker-root=<dir> : restreint la recherche à un répertoire
```

### FZF_DEFAULT_OPTS
Définit les options visuelles et fonctionnelles par défaut.
```bash
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --info=inline'
```

### FZF_DEFAULT_OPTS_FILE
Alternative à `FZF_DEFAULT_OPTS` : gère les options dans un fichier dédié.
```bash
export FZF_DEFAULT_OPTS_FILE=~/.fzfrc
```

### Variables par raccourci clavier
Chaque binding shell a ses propres variables de personnalisation :
```bash
# Ctrl-T : liste de fichiers/dossiers
export FZF_CTRL_T_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# Ctrl-R : historique
export FZF_CTRL_R_OPTS="
  --bind 'ctrl-y:execute-silent(echo -n {2..} | wl-copy)+abort'
  --bind '?:toggle-preview'
  --preview 'echo {}' --preview-window down:3:hidden:wrap
  --no-sort --exact
  --color header:italic
  --header 'Ctrl-Y : copier · ? : afficher commande complète'"
# --no-sort : ordre chronologique par défaut (Ctrl-R pour trier par pertinence)
# --exact   : matching non-fuzzy (comportement Ctrl-R classique)
# ? (bind)  : toggle preview pour voir la commande complète si tronquée

# Alt-C : navigation répertoires
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'tree -C {}'"
```
> Note : `FZF_DEFAULT_COMMAND` n'est **pas** utilisé par l'intégration shell. Utiliser les variables spécifiques ci-dessus.

### Thèmes de couleurs

Voir [`fzf-theming.md`](./fzf-theming.md) — schémas de base, clés de couleur, 24-bit, et ~15 thèmes prêts à coller (Catppuccin, Nord, Tokyo Night, Gruvbox, Dracula, Solarized, etc.).

## 3. Modes d'Affichage Avancés

### Préréglages de style (`--style`)
Option de mise en page rapide (fzf 0.53+) :
```bash
fzf --style default   # style standard
fzf --style full      # préview + bordures étendues
fzf --style minimal   # interface minimaliste
```

### Layout et espacement
```bash
fzf --layout=reverse --info=inline --border --margin=1 --padding=1
# margin : espace autour du widget entier
# padding : espace à l'intérieur des bordures
```

### Hauteur (`--height`)
```bash
fzf --height 40%          # hauteur fixe sous le curseur
fzf --height ~100%        # hauteur maximale (s'adapte à la liste)
fzf --height -3           # hauteur = taille écran - 3 lignes
fzf --height 40% --layout reverse --border
```
> Astuce : combiner `--height` et `--tmux/--popup` : si sur tmux, le popup prend la main ; sinon `--height` s'applique.
> ```bash
> fzf --height 70% --tmux 70%
> ```

### Mode plein écran
Désactiver le `--height 40%` implicite des bindings shell :
```bash
export FZF_DEFAULT_OPTS='--no-height --no-reverse'
```

### Mode Popup
Deux flags selon la version de fzf installée :

| Flag | Version tmux requise | Notes |
| :--- | :--- | :--- |
| `--popup` | tmux 3.3+ ou Zellij 0.44+ | Syntaxe officielle actuelle |
| `--tmux` | tmux 3.2+ | Ancien flag, toujours supporté |

```bash
# --popup : syntaxe complète
# --popup [center|top|bottom|left|right][,SIZE[%]][,SIZE[%]][,border-native]
fzf --popup center        # centré, 50% largeur/hauteur
fzf --popup 80%           # centré, 80% largeur/hauteur
fzf --popup 100%,50%      # centré, pleine largeur, 50% hauteur
fzf --popup bottom,80%,40%

# --tmux : ancienne syntaxe (toujours valide)
fzf --tmux 80%,60%
```

### Preview Window
```bash
# Coloration syntaxique avec bat
fzf --preview 'bat --color=always {}' --preview-window '~3'

# Position / taille / bordure
fzf --preview 'file {}' --preview-window up,1,border-horizontal

# Faire défiler automatiquement (log tailing)
fzf --preview-window follow --preview 'tail -f /var/log/syslog'

# Rotation des modes preview avec Ctrl-/
fzf --bind 'ctrl-/:change-preview-window(50%|hidden|)'
```
> Ne pas ajouter `--preview` à `$FZF_DEFAULT_OPTS` : bat ne sait pas traiter `ps -ef | fzf` ou `seq 100 | fzf`.

## 4. Actions et Bindings (Avancé)

### Raccourcis de navigation dans fzf
| Touche | Action |
| :--- | :--- |
| `Ctrl-K` / `Ctrl-P` | Monter dans la liste |
| `Ctrl-J` / `Ctrl-N` | Descendre dans la liste |
| `Entrée` | Confirmer la sélection |
| `TAB` / `Shift-TAB` | Marquer/démarquer (multi-select `-m`) |
| `Ctrl-C` / `ESC` | Quitter |
| `Ctrl-/` | Rotation des modes preview (si configuré) |

### become(...)
Transforme le processus fzf en une autre commande — évite le fichier vide si annulé avec Ctrl-C.
```bash
fzf --bind 'enter:become(nvim {})'

# Gestion multi-sélection
fzf --multi --bind 'enter:become(nvim {+})'

# Plusieurs actions sur des touches différentes
fzf --bind 'enter:become(nvim {}),ctrl-e:become(emacs {})'
```

### execute / execute-silent
Lance une commande sans quitter fzf (retour à fzf après exécution).
```bash
# F1 : ouvrir dans less sans quitter fzf
# Ctrl-Y : copier dans le presse-papiers et quitter
fzf --bind 'f1:execute(less -f {}),ctrl-y:execute-silent(echo {} | wl-copy)+abort'
```

### reload(...)
Rafraîchit la liste sans quitter fzf.
```bash
# Ctrl-R pour rafraîchir la liste des processus
ps -ef | fzf --bind 'ctrl-r:reload(ps -ef)' \
             --header 'Ctrl-R : rafraîchir' --header-lines=1

# Basculer entre deux sources de données (Ctrl-D / Ctrl-F)
find * | fzf --prompt 'Tout> ' \
             --header 'Ctrl-D: Dossiers / Ctrl-F: Fichiers' \
             --bind 'ctrl-d:change-prompt(Dossiers> )+reload(find * -type d)' \
             --bind 'ctrl-f:change-prompt(Fichiers> )+reload(find * -type f)'
```

### --disabled (recherche déléguée à un outil externe)
Désactive le filtrage interne de fzf — utile pour déléguer à ripgrep.
```bash
# fzf affiche les résultats de rg sans filtrer lui-même
rg --color=always --line-number '' | fzf --ansi --disabled
```

### --scheme (algorithme de correspondance)
| Valeur | Usage |
| :--- | :--- |
| `default` | Usage général |
| `path` | Chemins de fichiers |
| `history` | Historique de commandes |
```bash
fzf --scheme=path
```

### Performance
- `--ansi` : ralentit le scan initial (parse les codes ANSI) — ne pas mettre dans `$FZF_DEFAULT_OPTS`
- `--nth` et `--with-nth` : ralentissent fzf (tokenisation)
- `--delimiter` : préférer une chaîne fixe à une regex
