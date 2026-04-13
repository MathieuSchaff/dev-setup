# Outils CLI

Référence pour les outils du quotidien : eza, bat, glow, fzf, zoxide, delta, ripgrep, fd, bottom.
Ce fichier est aussi la **source canonique** pour les raccourcis fzf et pour la navigation `less`/pager — les autres cheatsheets renvoient ici.

## Sommaire

- [eza — ls amélioré](#eza--ls-amélioré)
- [bat — cat amélioré](#bat--cat-amélioré)
- [glow — lecteur markdown](#glow--lecteur-markdown)
- [fzf — fuzzy finder](#fzf--fuzzy-finder)
- [zoxide — cd intelligent](#zoxide--cd-intelligent)
- [delta — pager git](#delta--pager-git)
- [Pager `less` — touches communes](#pager-less--touches-communes)
- [ripgrep — grep rapide](#ripgrep--grep-rapide)
- [fd — find rapide](#fd--find-rapide)
- [bottom — moniteur système](#bottom--moniteur-système)

---

## eza — ls amélioré

### Aliases configurés

| Alias  | Effet                              |
|--------|------------------------------------|
| `l`    | liste avec icônes + statut git     |
| `ll`   | liste longue avec fichiers cachés  |
| `tree` | arborescence avec icônes           |

### Affichage

| Option                       | Effet                                        |
|------------------------------|----------------------------------------------|
| `-1, --oneline`              | une entrée par ligne                         |
| `-G, --grid`                 | affichage en grille (défaut)                 |
| `-l, --long`                 | vue longue (détails + attributs)             |
| `-R, --recurse`              | récursion dans les sous-dossiers             |
| `-T, --tree`                 | récursion en arborescence                    |
| `-x, --across`               | trier la grille horizontalement              |
| `-F, --classify=(when)`      | indicateur de type (always/auto/never)       |
| `--colour=(when)`            | couleurs (always/auto/never)                 |
| `--colour-scale=(field)`     | niveaux distincts (all/age/size)             |
| `--colour-scale-mode=(mode)` | gradient ou fixed                            |
| `--icons=(when)`             | icônes (always/auto/never)                   |
| `--hyperlink=(when)`         | entrées en hyperliens                        |
| `--absolute=(mode)`          | chemin absolu (on/follow/off)                |
| `-w, --width=(cols)`         | largeur d'écran en colonnes                  |

### Filtrage

| Option                      | Effet                                         |
|-----------------------------|-----------------------------------------------|
| `-a, --all`                 | cachés et dotfiles (`-aa` pour `.` et `..`)   |
| `-d, --treat-dirs-as-files` | lister les dossiers comme des fichiers        |
| `-L, --level=(depth)`       | limiter la profondeur de récursion            |
| `-r, --reverse`             | inverser l'ordre de tri                       |
| `-s, --sort=(field)`        | trier par champ (voir valeurs ci-dessous)     |
| `--group-directories-first` | dossiers en premier                           |
| `--group-directories-last`  | dossiers en dernier                           |
| `-D, --only-dirs`           | dossiers uniquement                           |
| `-f, --only-files`          | fichiers uniquement                           |
| `--no-symlinks`             | masquer les liens symboliques                 |
| `--show-symlinks`           | forcer l'affichage des liens symboliques      |
| `--git-ignore`              | ignorer les fichiers du `.gitignore`          |
| `-I, --ignore-glob=(globs)` | ignorer par pattern (séparés par `\|`)        |

### Vue longue (`-l`) — colonnes

| Option              | Effet                                          |
|---------------------|------------------------------------------------|
| `-b, --binary`      | taille en KiB / MiB                            |
| `-B, --bytes`       | taille en octets bruts                         |
| `-g, --group`       | afficher le groupe                             |
| `--smart-group`     | groupe seulement si différent du propriétaire  |
| `-h, --header`      | ligne d'en-tête pour chaque colonne            |
| `-H, --links`       | nombre de liens durs                           |
| `-i, --inode`       | numéro d'inode                                 |
| `-m, --modified`    | timestamp de modification                      |
| `-M, --mounts`      | détails des points de montage                  |
| `-S, --blocksize`   | taille des blocs alloués                       |
| `-t, --time=(field)`| champ timestamp à utiliser                     |
| `-u, --accessed`    | timestamp d'accès                              |
| `-U, --created`     | timestamp de création                          |
| `-X, --dereference` | déréférencer les symlinks                      |
| `-Z, --context`     | contexte SELinux                               |
| `-@, --extended`    | attributs étendus                              |
| `--changed`         | timestamp de changement                        |

### Vue longue — git & masquage

| Option                    | Effet                                          |
|---------------------------|------------------------------------------------|
| `--git`                   | statut git de chaque fichier                   |
| `--git-repos`             | statut git de chaque dossier                   |
| `--git-repos-no-status`   | indique si c'est un repo (sans statut, rapide) |
| `--no-git`                | supprimer le statut git                        |
| `--time-style=(style)`    | format des timestamps (voir valeurs)           |
| `--total-size`            | taille récursive des dossiers                  |
| `--no-permissions`        | masquer les permissions                        |
| `-o, --octal-permissions` | permissions en octal                           |
| `--no-filesize`           | masquer la taille                              |
| `--no-user`               | masquer l'utilisateur                          |
| `--no-time`               | masquer le timestamp                           |
| `--stdin`                 | lire les noms depuis stdin                     |

### Valeurs valides

`--sort` — `accessed`, `changed`, `created`, `extension`, `Extension`, `inode`,
`modified` (alias `date`/`time`/`newest`), `name`, `Name`, `size`, `type`, `none`

`--time` — `modified`, `changed`, `accessed`, `created`

`--time-style` — `default`, `iso`, `long-iso`, `full-iso`, `relative`, `+<FORMAT>`

### Exemples utiles

| Commande                       | Effet                                        |
|--------------------------------|----------------------------------------------|
| `eza -l --sort=modified`       | trier par date de modification               |
| `eza -l --git --git-ignore`    | vue longue + git, sans les ignorés           |
| `eza -T -L 2`                  | arborescence limitée à 2 niveaux             |
| `eza -l --total-size -D`       | taille récursive des dossiers uniquement     |
| `eza -l --time-style=relative` | timestamps en durée relative                 |

---

## bat — cat amélioré

Aliasé sur `cat`. S'intègre automatiquement avec fzf pour les previews.

| Commande                | Effet                          |
|-------------------------|--------------------------------|
| `cat <fichier>`         | afficher avec syntax highlight |
| `cat <fichier> -n`      | avec numéros de ligne          |
| `cat <fichier> --plain` | sans décorations               |
| `bat --list-themes`     | voir les thèmes disponibles    |

---

## glow — lecteur markdown

Glow rend le markdown dans le terminal — titres, tables, listes, code highlight.
Config : `~/.config/glow/glow.yml` (style dark, pager, width 90, mouse).

> Aliases zsh (`cs`, `mdp`) → [zsh.md — Cheatsheets (glow)](./zsh.md#cheatsheets-glow).

| Commande                            | Effet                                        |
|-------------------------------------|----------------------------------------------|
| `glow <fichier>`                    | Rendre un fichier (ou stdin avec `-`)        |
| `glow github.com/<user>/<repo>`     | Fetch et rendre un README distant            |

### TUI — raccourcis

| Touche      | Effet                          |
|-------------|--------------------------------|
| `↑ / ↓`     | Naviguer dans la liste         |
| `Enter`     | Ouvrir un fichier              |
| `Esc` / `q` | Revenir à la liste / quitter   |
| `/`         | Filtrer la liste               |
| `?`         | Afficher toutes les touches    |

### Pager

Navigation type `less` — voir [Pager `less`](#pager-less--touches-communes).

### Options utiles

| Flag              | Effet                                        |
|-------------------|----------------------------------------------|
| `-s dark / light` | Forcer un style                              |
| `-w <n>`          | Word-wrap à `n` colonnes                     |
| `-p`              | Afficher dans le pager                       |
| `-`               | Lire depuis stdin (`echo "..." \| glow -`)   |
| `glow config`     | Ouvrir le fichier de config dans `$EDITOR`   |

---

## fzf — fuzzy finder

### Raccourcis shell

| Raccourci    | Effet                                              |
|--------------|----------------------------------------------------|
| `Ctrl+T`     | chercher fichier + preview bat, insérer le chemin  |
| `Ctrl+R`     | chercher dans l'historique (`Ctrl+Y` = copier)     |
| `Ctrl+F`     | fuzzy cd avec preview arborescence (remplace Alt+C)|
| `zdf`        | idem en commande (fd + fzf + eza tree + zoxide)    |
| `Tab`        | fzf-tab — complétion fuzzy (popup tmux si actif)   |
| `Ctrl+Space` | fzf-tab — sélection multiple                       |
| `F1` / `F2`  | fzf-tab — changer de groupe de suggestions         |
| `<` / `>`    | fzf-tab — changer de groupe (alternate)            |
| `/`          | fzf-tab — complétion continue sur un chemin profond|

### Dans l'interface fzf

| Touche      | Effet                          |
|-------------|--------------------------------|
| `↑` / `↓`  | naviguer                       |
| `Tab`       | sélection multiple             |
| `Enter`     | valider                        |
| `Ctrl+C`    | annuler                        |
| `Ctrl+/`    | toggle / déplacer la preview   |
| `Ctrl+D`    | scroll preview bas (demi-page) |
| `Ctrl+U`    | scroll preview haut (demi-page)|

### Config

- Thème : **Catppuccin Macchiato** (cohérent avec starship/tmux)
- Popup tmux automatique si dans tmux, sinon `--height`
- `Ctrl+T` : preview bat, skip `.git/node_modules/target/.venv`
- `Ctrl+R` : `Ctrl+Y` copie la commande dans le clipboard

---

## zoxide — cd intelligent

Aliasé sur `z`. Apprend automatiquement depuis tes `cd` habituels.

| Commande          | Effet                                       |
|-------------------|---------------------------------------------|
| `z <nom>`         | sauter vers le dossier le plus fréquent     |
| `z <partiel>`     | fonctionne avec un sous-dossier partiel     |
| `zi`              | mode interactif via fzf                     |
| `z -`             | dossier précédent                           |
| `zoxide query -l` | voir tous les dossiers enregistrés          |

---

## delta — pager git

Delta est un **pager** : il intercepte la sortie de git et l'embellit.
Activé **automatiquement** pour toutes les commandes git qui affichent un diff.
Config active dans `~/.gitconfig` : `side-by-side = true`, `navigate = true`, thème sombre.

### Dans le terminal

| Commande                    | Ce que tu vois                                  |
|-----------------------------|-------------------------------------------------|
| `git diff`                  | Diff côte-à-côte, syntax highlighting           |
| `git diff --staged`         | Diff de ce qui est stagé                        |
| `git show <hash>`           | Contenu complet d'un commit, formaté            |
| `git log --patch`           | Historique avec le diff de chaque commit inline |
| `git log --oneline --graph` | Graphe de branches coloré                       |

### Astuce — désactiver delta ponctuellement

```sh
git --no-pager diff       # sortie brute
GIT_PAGER=cat git diff    # idem via variable d'env
git diff | cat            # bypass pager
```

### Dans lazygit

Delta est configuré dans `~/.config/lazygit/config.yml` avec `--paging=never`.
Tout n'est pas supporté à l'identique :

- **Syntax highlighting** — fonctionne, delta colore les diffs dans les panels.
- **Side-by-side** — panel souvent trop étroit, delta bascule en vue unifiée auto.
- **Navigation `n`/`N`** — pas dispo, c'est lazygit qui gère le scroll.
- **`--paging=never`** — requis, sinon delta ouvrirait `less` dans le panel et ferait crasher lazygit.

---

## Pager `less` — touches communes

Source canonique pour les touches du pager `less`.
Utilisées par delta, glow `-p`, git log et `man`.

| Touche     | Effet                                       |
|------------|---------------------------------------------|
| `n` / `N`  | (delta) fichier suivant / précédent         |
| `j` / `k`  | scroller ligne par ligne                    |
| `d` / `u`  | scroller demi-page bas / haut               |
| `g` / `G`  | début / fin du document                     |
| `/<texte>` | chercher en avant                           |
| `?<texte>` | chercher en arrière                         |
| `q`        | quitter                                     |

---

## ripgrep — grep rapide

| Commande                | Effet                                   |
|-------------------------|-----------------------------------------|
| `rg <pattern>`          | chercher récursivement                  |
| `rg <pattern> -t js`    | dans les fichiers JS uniquement         |
| `rg <pattern> -C 2`     | avec 2 lignes de contexte               |
| `rg <pattern> -l`       | afficher seulement les noms de fichiers |
| `rg <pattern> --hidden` | inclure les fichiers cachés             |

---

## fd — find rapide

| Commande            | Effet                          |
|---------------------|--------------------------------|
| `fd <pattern>`      | chercher fichiers par nom      |
| `fd -t d <pattern>` | chercher dossiers uniquement   |
| `fd -t f <pattern>` | chercher fichiers uniquement   |
| `fd -e ts`          | chercher par extension         |
| `fd --hidden`       | inclure les fichiers cachés    |

---

## bottom — moniteur système

Aliasé sur `btm`.

| Touche    | Effet                       |
|-----------|-----------------------------|
| `?`       | aide                        |
| `q`       | quitter                     |
| `↑` / `↓` | naviguer entre processus    |
| `d` `d`   | kill un processus           |
| `Ctrl+c`  | quitter                     |
