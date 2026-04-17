# Tmux

Multiplexeur de terminal — sessions persistantes, splits, copy-mode.
Config : `~/.tmux.conf` (symlink → `~/dev-setup/config/.tmux.conf`) · thème **Catppuccin macchiato** · préfixe **`Ctrl+b`**.

## Sommaire

- [Lancement](#lancement)
- [Sessions](#sessions)
- [Fenêtres (windows)](#fenêtres-windows)
- [Panes (splits)](#panes-splits)
- [Copy mode (vi)](#copy-mode-vi)
- [Popup & intégrations](#popup--intégrations-custom)
- [Config active](#config-active)
- [Plugins (TPM)](#plugins-via-tpm)
- [Thème Catppuccin](#thème-catppuccin-macchiato)
- [Recharger la config](#recharger-la-config)
- [Mode commande](#commandes-utiles-mode-commande-ctrlb-)
- [Pièges](#pièges)

---

## Lancement

| Commande                     | Effet                                                |
|------------------------------|------------------------------------------------------|
| `t`                          | Fonction zsh — crée `doc`/`dev`/`tests` ou attach    |
| `tn <nom>`                   | Créer une session en arrière-plan (pas de nesting)   |
| `tnew <nom>`                 | Créer **et** rejoindre une session                   |
| `tmux attach -t <nom>`       | Rejoindre une session existante                      |
| `tmux ls`                    | Lister les sessions                                  |
| `tmux kill-session -t <nom>` | Tuer une session                                     |
| `Ctrl+b d`                   | Détacher (session reste active en arrière-plan)      |

> Les 3 sessions par défaut créées par `t()` :
> `doc` (dans `~/dev-setup/cheatsheet` avec `cs` lancé), `dev`, `tests`.

---

## Sessions

| Raccourci        | Effet                              |
|------------------|------------------------------------|
| `Ctrl+b s`       | Liste interactive des sessions     |
| `Alt+s`          | **Popup fzf** — switcher floue entre sessions (sans préfixe, exclut la courante) |
| `Ctrl+b $`       | Renommer la session courante       |
| `Ctrl+b (` / `)` | Session précédente / suivante      |
| `Ctrl+b d`       | Détacher                           |
| `Ctrl+b D`       | Choisir une session à détacher     |

---

## Fenêtres (windows)

| Raccourci        | Effet                                  |
|------------------|----------------------------------------|
| `Ctrl+b c`       | Nouvelle fenêtre                       |
| `Ctrl+b ,`       | Renommer la fenêtre courante           |
| `Ctrl+b &`       | Tuer la fenêtre (demande confirmation) |
| `Ctrl+b n` / `p` | Fenêtre suivante / précédente          |
| `Ctrl+b 0`…`9`   | Aller à la fenêtre N                   |
| `Ctrl+b w`       | Liste interactive des fenêtres         |
| `Ctrl+b l`       | Dernière fenêtre utilisée              |
| `Ctrl+b f`       | Chercher dans toutes les fenêtres      |

> `base-index 1` + `renumber-windows on` → fenêtres numérotées à partir de **1**,
> renumérotation auto à la fermeture.

---

## Panes (splits)

| Raccourci          | Effet                                            |
|--------------------|--------------------------------------------------|
| `Ctrl+b %`         | Split **vertical** — démarre dans le cwd du pane |
| `Ctrl+b "`         | Split **horizontal** — démarre dans le cwd du pane |
| `Ctrl+h/j/k/l`     | Naviguer entre panes (sans préfixe, via vim-tmux-navigator) |
| `Ctrl+b ←↑↓→`      | Naviguer entre panes (fallback)                  |
| `Ctrl+b o`         | Pane suivant                                     |
| `Ctrl+b ;`         | Dernier pane utilisé                             |
| `Ctrl+b z`         | **Zoom** / dézoom sur le pane courant            |
| `Ctrl+b x`         | Fermer le pane (demande confirmation)            |
| `Ctrl+b !`         | Transformer le pane en fenêtre à part            |
| `Ctrl+b {` / `}`   | Permuter pane avec le précédent / suivant        |
| `Ctrl+b space`     | Changer la disposition (layout)                  |
| `Ctrl+b Ctrl+←↑↓→` | Redimensionner le pane courant                   |
| `Ctrl+b q`         | Afficher le numéro des panes (puis `N` pour aller)|

> Les splits (`%` et `"`) démarrent dans le **cwd du pane courant** (override des defaults tmux qui démarrent dans `$HOME`).
> `Ctrl+h/j/k/l` (sans préfixe) navigue de manière transparente entre panes tmux **et** splits Neovim via le plugin `vim-tmux-navigator`.

---

## Copy mode (vi)

`mode-keys vi` activé → navigation et sélection à la vim.

| Raccourci           | Effet                                       |
|---------------------|---------------------------------------------|
| `Ctrl+b [`          | **Entrer** en copy mode                     |
| `h j k l`           | Naviguer                                    |
| `w b e`             | Mot suivant / précédent / fin de mot        |
| `0 $ ^`             | Début / fin / premier non-espace            |
| `g G`               | Début / fin du buffer                       |
| `Ctrl+u` / `Ctrl+d` | Demi-page haut / bas                        |
| `/` / `?`           | Chercher en avant / arrière                 |
| `n` / `N`           | Résultat suivant / précédent                |
| `v`                 | Début de sélection                          |
| `Ctrl+v`            | Sélection **rectangulaire**                 |
| `y`                 | Copier dans le clipboard système (via `tmux-yank` → `wl-copy` sous Wayland) |
| `q` / `Esc`         | Quitter le copy mode                        |
| `Ctrl+b ]`          | Coller le dernier buffer                    |

> `tmux-yank` est installé → `y` copie directement dans le clipboard système. Sur Wayland, utilise `wl-copy` (paquet `wl-clipboard`). Fallback automatique sur `xclip`/`xsel` si absent.
> Souris : `mouse on` → tu peux aussi sélectionner à la souris.

---

## Popup & intégrations custom

| Raccourci | Effet                                                            |
|-----------|------------------------------------------------------------------|
| `Ctrl+g`    | **Popup lazygit** flottant (90×90%, sans préfixe)                |
| `Alt+N`     | **Popup navi** — fonctionne aussi en SSH, nvim, psql...          |
| `Alt+s`     | **Popup fzf sessions** — fuzzy-find + `Entrée` pour switcher (40×40%, sans préfixe) |

> Ces raccourcis fonctionnent depuis n'importe quel pane, dans n'importe quelle app.
> `Ctrl+g` hérite du `pane_current_path` → lazygit ouvre dans le bon repo.

---

## Config active

`~/.tmux.conf` :

| Option              | Valeur          | Raison                                  |
|---------------------|-----------------|-----------------------------------------|
| `escape-time`       | `10` ms         | Délai Esc réduit pour Neovim            |
| `focus-events`      | `on`            | Neovim détecte le focus                 |
| `default-terminal`  | `tmux-256color` | 256 couleurs + RGB (true color)         |
| `mouse`             | `on`            | Souris active                           |
| `base-index`        | `1`             | Fenêtres/panes numérotés à partir de 1  |
| `renumber-windows`  | `on`            | Renumérotation auto à la fermeture      |
| `mode-keys`         | `vi`            | Copy mode vim-like                      |
| `set-titles`        | `on`            | Titre de la fenêtre terminale dynamique |
| `history-limit`     | `50000`         | Scrollback large (défaut : 2000)        |
| `status-position`   | `top`           | Status bar en haut (défaut : `bottom`)  |

### Status-left — liste des sessions

Au lieu d'afficher juste la session courante, `status-left` itère sur **toutes** les sessions avec la courante en surbrillance (`reverse`) :

```tmux
set -g status-left "#[fg=#c6a0f6,bold] sessions: #[default]#{S:#{?session_attached,#[reverse] #S #[noreverse] , #S  }}"
```

- `#{S:format}` → itère sur chaque session, applique `format`
- `#{?session_attached,X,Y}` → conditionnel : `X` si la session est la courante, `Y` sinon
- `#[reverse]` / `#[noreverse]` → inverse fg/bg pour highlight

---

## Plugins (via TPM)

| Plugin                         | Rôle                                            |
|--------------------------------|-------------------------------------------------|
| `tmux-plugins/tpm`             | Gestionnaire de plugins (requis)                |
| `tmux-plugins/tmux-sensible`   | Defaults sensés (escape-time, history, utf8...) |
| `tmux-plugins/tmux-yank`       | Copie du copy-mode vers le clipboard système    |
| `christoomey/vim-tmux-navigator` | `Ctrl+h/j/k/l` navigue entre panes tmux ET splits Neovim (plugin requis aussi côté nvim) |
| `tmux-plugins/tmux-resurrect`  | Sauvegarde/restore manuel des sessions (`prefix + Ctrl+s` / `prefix + Ctrl+r`) |
| `tmux-plugins/tmux-continuum`  | Sauvegarde auto toutes les 15 min + restore au démarrage (`@continuum-restore 'on'`) |
| `catppuccin/tmux#v2.3.0`       | Thème Catppuccin (flavor macchiato) — **pinné en v2.3.0** car l'API a été réécrite en v2 mi-2024 |

### TPM — commandes

| Raccourci         | Effet                                              |
|-------------------|----------------------------------------------------|
| `Ctrl+b I` (maj)  | **Installer** les nouveaux plugins                 |
| `Ctrl+b U` (maj)  | **Update** les plugins installés                   |
| `Ctrl+b Alt+u`    | Désinstaller les plugins supprimés de `.tmux.conf` |

---

## Thème Catppuccin macchiato (API v2)

**Important :** catppuccin/tmux a été totalement réécrit en v2 mi-2024. L'API v1 (`@catppuccin_flavour`, `@catppuccin_window_left_separator`, `@catppuccin_status_modules_right`, `@catppuccin_status_fill`, `@catppuccin_window_default_fill` etc.) est **silencieusement ignorée** en v2. Pour rester prévisible, la version est **pinnée** dans `.tmux.conf` : `set -g @plugin 'catppuccin/tmux#v2.3.0'`.

### Options actives

| Option                                       | Valeur       | Effet                                                              |
|----------------------------------------------|--------------|--------------------------------------------------------------------|
| `@catppuccin_flavor`                         | `macchiato`  | Palette (note : **flavor**, spelling US — c'était `flavour` en v1) |
| `@catppuccin_window_status_style`            | `slanted`    | Séparateurs en biais (Powerline-like). Autres valeurs : `basic`, `rounded`, `custom`, `none` |
| `@catppuccin_window_number_position`         | `right`      | Numéro de window à droite du texte                                 |
| `@catppuccin_window_text`                    | `' #W'`      | Format tab inactive (`#W` = window name)                           |
| `@catppuccin_window_current_text`            | `' #W'`      | Format tab active                                                  |

### Modules status-right (v2 — assemblage explicite)

En v2, plus de `@catppuccin_status_modules_right` — il faut composer `status-right` toi-même avec les modules catppuccin comme format strings :

```tmux
set -g status-right '#{E:@catppuccin_status_directory}'
set -agF status-right '#{E:@catppuccin_status_user}'
set -agF status-right '#{E:@catppuccin_status_session}'
```

Modules dispo (fichiers dans `~/.tmux/plugins/tmux/status/`) : `application`, `battery`, `clima`, `cpu`, `date_time`, `directory`, `gitmux`, `host`, `kube`, `load`, `pomodoro_plus`, `ram`, `session`, `uptime`, `user`, `weather`.

### Chargement du plugin

En v2, il faut **explicitement** exécuter `catppuccin.tmux` dans la config (même avec TPM) :

```tmux
run '~/.tmux/plugins/tmux/catppuccin.tmux'
```

Ordre dans `.tmux.conf` : options `@catppuccin_*` → `run catppuccin.tmux` → `set -g status-right ...` → `run tpm` (en dernière ligne).

### Changer de flavor

Éditer `@catppuccin_flavor` (`latte` / `frappe` / `macchiato` / `mocha`) dans `.tmux.conf`, puis `tmux source ~/.tmux.conf`.

### Upgrade depuis v0.3.x

Si tu viens de la v1 : `~/.tmux/plugins/tpm/bin/clean_plugins && ~/.tmux/plugins/tpm/bin/install_plugins` pour forcer un nettoyage + réinstall du plugin.

---

## Recharger la config

```sh
# Depuis tmux, en mode commande
Ctrl+b :
source ~/.tmux.conf

# Depuis le shell
tmux source ~/.tmux.conf
```

---

## Commandes utiles (mode commande `Ctrl+b :`)

| Commande                    | Effet                                    |
|-----------------------------|------------------------------------------|
| `kill-server`               | Tuer tmux complètement (toutes sessions) |
| `list-keys`                 | Voir tous les bindings actifs            |
| `show-options -g`           | Voir toutes les options globales         |
| `display-message "hello"`   | Afficher un message dans la status bar   |
| `rename-session <nom>`      | Renommer la session                      |
| `move-window -t <n>`        | Déplacer la fenêtre à la position `n`    |
| `swap-window -s <a> -t <b>` | Échanger deux fenêtres                   |

---

## Pièges

### Nesting tmux

Lancer `tmux` dans tmux crée une session imbriquée. La fonction `t()` détecte les sessions
existantes pour l'éviter — utilise `tn <nom>` pour créer en arrière-plan.

### `escape-time 10` requis pour Neovim

Sans ça, le passage en mode NORMAL après `Esc` a un délai perceptible.

### Clipboard Wayland (Tuxedo OS / KDE)

Installer **`wl-clipboard`** (`sudo apt install wl-clipboard`) pour `wl-copy`/`wl-paste`. `tmux-yank` détecte auto l'outil présent et fallback sur `xclip` (XWayland) si absent. `wl-copy` natif est préféré.

### Resurrect + Continuum

- **Sauvegarde auto** toutes les 15 min dans `~/.tmux/resurrect/` (continuum).
- **Restore auto** au démarrage de tmux (flag `@continuum-restore 'on'`).
- **Manuel** : `prefix + Ctrl+s` (save) / `prefix + Ctrl+r` (restore).
- Contenu des panes capturé (`@resurrect-capture-pane-contents 'on'`) — buffer visible restauré après reboot.

### `Ctrl+g` sans préfixe

S'il y a un conflit avec une app qui utilise `Ctrl+g` (ex. emacs), adapter le binding
dans `.tmux.conf`.
