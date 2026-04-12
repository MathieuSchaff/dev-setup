# Tmux

Multiplexeur de terminal — sessions persistantes, splits, copy-mode.
Config : `~/.tmux.conf` · thème **Catppuccin macchiato** · préfixe **`Ctrl+b`**.

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
| `Ctrl+b %`         | Split **vertical** (nouveau pane à droite)       |
| `Ctrl+b "`         | Split **horizontal** (nouveau pane en bas)       |
| `Ctrl+b ←↑↓→`      | Naviguer entre panes                             |
| `Ctrl+b o`         | Pane suivant                                     |
| `Ctrl+b ;`         | Dernier pane utilisé                             |
| `Ctrl+b z`         | **Zoom** / dézoom sur le pane courant            |
| `Ctrl+b x`         | Fermer le pane (demande confirmation)            |
| `Ctrl+b !`         | Transformer le pane en fenêtre à part            |
| `Ctrl+b {` / `}`   | Permuter pane avec le précédent / suivant        |
| `Ctrl+b space`     | Changer la disposition (layout)                  |
| `Ctrl+b Ctrl+←↑↓→` | Redimensionner le pane courant                   |
| `Ctrl+b q`         | Afficher le numéro des panes (puis `N` pour aller)|

> Tes splits n'ont **pas** de binding `|` / `-` custom — utilise les defaults `%` et `"`.

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
| `y`                 | Copier dans le clipboard système (xclip)    |
| `q` / `Esc`         | Quitter le copy mode                        |
| `Ctrl+b ]`          | Coller le dernier buffer                    |

> `tmux-yank` est installé → `y` copie directement dans le clipboard Windows/Linux.
> Souris : `mouse on` → tu peux aussi sélectionner à la souris.

---

## Popup & intégrations custom

| Raccourci         | Effet                                                     |
|-------------------|-----------------------------------------------------------|
| `Ctrl+g`          | **Popup lazygit** flottant (90×90%, sans préfixe)         |
| `prefix + Ctrl+g` | **Navi** — split temporaire, colle dans le pane précédent |

> `Ctrl+g` fonctionne depuis n'importe quel pane tmux, dans n'importe quelle app.
> Le popup hérite du `pane_current_path` → lazygit ouvre dans le bon repo.

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

---

## Plugins (via TPM)

| Plugin                       | Rôle                                            |
|------------------------------|-------------------------------------------------|
| `tmux-plugins/tpm`           | Gestionnaire de plugins (requis)                |
| `tmux-plugins/tmux-sensible` | Defaults sensés (escape-time, history, utf8...) |
| `tmux-plugins/tmux-yank`     | Copie du copy-mode vers le clipboard système    |
| `catppuccin/tmux`            | Thème Catppuccin (flavour macchiato)            |

### TPM — commandes

| Raccourci         | Effet                                              |
|-------------------|----------------------------------------------------|
| `Ctrl+b I` (maj)  | **Installer** les nouveaux plugins                 |
| `Ctrl+b U` (maj)  | **Update** les plugins installés                   |
| `Ctrl+b Alt+u`    | Désinstaller les plugins supprimés de `.tmux.conf` |

---

## Thème Catppuccin macchiato

Flavour forcé dans `.tmux.conf` (les 2 autres lignes `latte`/`frappe`/`mocha` en haut sont surchargées par la dernière).

Barre de statut à droite : `directory · user · session`.
Séparateurs : `window_left_separator ""`, `window_right_separator " "`, `window_middle_separator " █"`.

> Pour changer de flavour : éditer la dernière ligne `@catppuccin_flavour` dans `~/.tmux.conf`,
> puis recharger la config.

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

### Clipboard WSL

`xclip` doit être installé (`sudo apt install xclip`) pour que `y` fonctionne.

### `Ctrl+g` sans préfixe

S'il y a un conflit avec une app qui utilise `Ctrl+g` (ex. emacs), adapter le binding
dans `.tmux.conf`.
