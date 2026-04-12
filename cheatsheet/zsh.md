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
| `cat`  | `batcat` (syntax highlighting) |
| `c`    | `clear`                        |

## Aliases Docker

| Alias | Commande      | Cheatsheet                          |
|-------|---------------|-------------------------------------|
| `lzd` | `lazydocker`  | [lazydocker.md](./lazydocker.md)    |

> `ctop` et `dive` sont lancés par leur binaire direct — pas d'alias.
> Voir [ctop.md](./ctop.md) et [dive.md](./dive.md).

## Navigation

| Commande       | Effet                                         |
|----------------|-----------------------------------------------|
| `z <nom>`      | Sauter vers un dossier visité (zoxide)        |
| `zdf`          | Fuzzy find + jump via fzf + zoxide            |
| `cs`           | fzf sur `cheatsheet/` + preview glow (loop, `q` pour revenir) |
| `gl <fichier>` | Rendre un `.md` avec glow (pager)             |
| `Ctrl+N`       | navi — cheatsheet interactif (widget shell)   |

> Les raccourcis `Ctrl+T` / `Ctrl+R` / `Alt+C` / `Tab` (fzf et fzf-tab) sont dans
> [tools.md](./tools.md#fzf--fuzzy-finder).
> `↑ / ↓` filtrent l'historique par ce qui est tapé (history-substring-search).

## Tmux

> Cheatsheet tmux complet → [tmux.md](./tmux.md). Ci-dessous, ce qui passe par zsh.

| Alias / Commande       | Effet                                            |
|------------------------|--------------------------------------------------|
| `t`                    | Lancer tmux (crée sessions `doc`/`dev`/`tests`)  |
| `tn <nom>`             | Créer session en arrière-plan                    |
| `tnew <nom>`           | Créer et rejoindre session                       |
| `tmux attach -t <nom>` | Rejoindre une session existante                  |
| `Ctrl+g`               | Ouvrir lazygit en popup flottant (sans préfixe)  |

## Updates

| Commande             | Effet                                                  |
|----------------------|--------------------------------------------------------|
| `update-all`         | apt, omz, plugins zsh, rust, uv, lazygit, fzf          |
| `update-node`        | Node (nvm) + packages npm globaux                      |
| `update-bun`         | bun                                                    |
| `update-conda`       | conda                                                  |
| `update-nvim`        | neovim (pre-built)                                     |
| `update-zsh-plugins` | plugins Oh My Zsh custom                               |
| `update-lazygit`     | lazygit                                                |
