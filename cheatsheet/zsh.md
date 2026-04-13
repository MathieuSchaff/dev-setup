# ZSH — Aliases & Navigation

Tu es en mode INSERT par défaut (vi-mode). `Esc` bascule en NORMAL — voir [vi-mode.md](./vi-mode.md).
Raccourcis fzf détaillés dans [tools.md](./tools.md#fzf--fuzzy-finder).

## Aliases Git

| Alias | Commande                                        |
|-------|-------------------------------------------------|
| `g`   | `git`                                           |
| `gs`  | `git status`                                    |
| `ga`  | `git add`                                       |
| `gc`  | `git commit`                                    |
| `gp`  | `git push`                                      |
| `gpl` | `git pull`                                      |
| `gco` | `git checkout`                                  |
| `gcb` | `git checkout -b`                               |
| `gbr` | `git branch`                                    |
| `lg`  | `lazygit` — smart exit (terminal suit le dossier)|

## Aliases Fichiers

| Alias  | Commande                       |
|--------|--------------------------------|
| `l`    | `eza -l --icons --git`         |
| `ll`   | `eza -la --icons --git`        |
| `tree` | `eza --tree --icons`           |
| `lh`   | `ls -lah`                      |
| `cat`  | `bat` (syntax highlighting)    |
| `c`    | `clear`                        |

## Aliases Docker

| Alias | Commande      | Cheatsheet                          |
|-------|---------------|-------------------------------------|
| `lzd` | `lazydocker`  | [lazydocker.md](./lazydocker.md)    |

> `ctop` et `dive` sont lancés par leur binaire direct — pas d'alias.
> Voir [ctop.md](./ctop.md) et [dive.md](./dive.md).

## Navigation

### Dossiers (zoxide)

| Commande  | Effet                                                             |
|-----------|-------------------------------------------------------------------|
| `z <nom>` | Sauter vers un dossier visité (zoxide — apprend l'historique)     |
| `zdf` / `Ctrl+F` | Fuzzy cd avec preview arborescence (fd + fzf + eza tree + zoxide) |

### Cheatsheets (glow)

| Commande            | Effet                                                                   |
|---------------------|-------------------------------------------------------------------------|
| `Ctrl+E`            | Parcourir `cheatsheet/` en fzf + preview glow (accès direct)           |
| `cs`                | Parcourir `cheatsheet/` en fzf + preview glow (loop, `q` pour quitter) |
| `mdp <fichier.md>`  | Ouvrir n'importe quel `.md` dans glow en mode pager                     |

> `mdp` = `glow -p` — uniquement pour fichiers Markdown. Pas lié à git.

### Navi

| Commande | Effet                                       |
|----------|---------------------------------------------|
| `Ctrl+N` | navi — cheatsheet interactif (widget shell) |
| `Ctrl+E` | parcourir cheatsheets markdown (fzf + glow) |

> Les raccourcis `Ctrl+T` / `Ctrl+R` / `Alt+C` / `Tab` (fzf et fzf-tab) sont dans
> [tools.md](./tools.md#fzf--fuzzy-finder).
> `↑ / ↓` filtrent l'historique par ce qui est tapé (history-substring-search).

## Tmux

> Cheatsheet tmux complet → [tmux.md](./tmux.md). Ci-dessous, ce qui passe par zsh.

| Alias / Commande       | Effet                                            |
|------------------------|--------------------------------------------------|
| `t`                    | Lancer tmux (crée sessions `doc`/`dev`/`tests`)  |
| `tn <nom>`             | Créer session en arrière-plan                    |
| `tnew <nom>`           | Créer une session nommée (`tmux new -s`)         |
| `tmux attach -t <nom>` | Rejoindre une session existante                  |
| `Ctrl+g`               | Ouvrir lazygit en popup flottant (sans préfixe)  |
| `Alt+N`                | Ouvrir navi en popup flottant (sans préfixe)     |

## Updates

Une seule commande : `update`. Tab-completion activée (flags + catégories).

| Commande             | Effet                                                  |
|----------------------|--------------------------------------------------------|
| `update`             | Tout safe : apt, omz, zsh-plugins, rust, cargo, go, uv, tools |
| `update --all`       | Tout (safe + runtime : node, bun, pnpm, conda)        |
| `update rust go`     | Sélectif — une ou plusieurs catégories                 |
| `update --list`      | Affiche toutes les catégories disponibles              |

**Catégories safe** (incluses dans `update` sans argument) :

| Catégorie      | Ce que ça met à jour                                    |
|----------------|---------------------------------------------------------|
| `apt`          | `sudo apt update && sudo apt upgrade`                   |
| `omz`          | Oh My Zsh                                               |
| `zsh-plugins`  | Plugins custom (git pull sur chaque)                    |
| `rust`         | `rustup update` (toolchain + rustc)                     |
| `cargo`        | Outils cargo : bat, delta, eza, tree-sitter-cli         |
| `go`           | Go (tarball depuis go.dev, comparaison de version)      |
| `uv`           | `uv self update`                                        |
| `tools`        | Binaires manuels via `update-tools.sh` (dive, lazygit, lazydocker, ctop, nvim, fzf) |

**Catégories runtime** (sélectif uniquement — risque de casser des projets) :

| Catégorie | Ce que ça met à jour                                      |
|-----------|-----------------------------------------------------------|
| `node`    | Node (nvm) + npm packages globaux                         |
| `bun`     | `bun upgrade`                                             |
| `pnpm`    | `corepack prepare pnpm@latest --activate`                 |
| `conda`   | `conda update -n base -c defaults conda`                  |
