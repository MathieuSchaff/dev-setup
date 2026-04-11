# ZSH — Aliases & Navigation

## Aliases Git
| Alias | Commande           |
|-------|--------------------|
| `g`   | git                |
| `gs`  | git status         |
| `ga`  | git add            |
| `gc`  | git commit         |
| `gp`  | git push           |
| `gpl` | git pull           |
| `gco` | git checkout       |
| `gcb` | git checkout -b    |
| `gbr` | git branch         |
| `lg`  | lazygit (TUI git)  |

## Aliases Fichiers
| Alias | Commande           |
|-------|--------------------|
| `l`   | eza -l --icons --git       |
| `ll`  | eza -la --icons --git      |
| `tree`| eza --tree --icons         |
| `cat` | batcat (syntax highlighting) |

## Navigation
| Commande         | Effet                                      |
|------------------|--------------------------------------------|
| `z <nom>`        | Sauter vers un dossier visité (zoxide)     |
| `zdf`            | Fuzzy find + jump via fzf + zoxide         |
| `Ctrl+T`         | fzf — chercher un fichier dans le dossier  |
| `Ctrl+R`         | fzf — chercher dans l'historique           |
| `Alt+C`          | fzf — cd dans un sous-dossier              |
| `Tab`            | fzf-tab — complétion fuzzy interactive     |
| `↑ / ↓`          | history-substring-search (filtre par ce qui est tapé) |

## Tmux
| Alias / Commande     | Effet                                   |
|----------------------|-----------------------------------------|
| `t`                  | tmux                                    |
| `tn <nom>`           | Créer session en arrière-plan           |
| `tnew <nom>`         | Créer et rejoindre session              |
| `Ctrl+b s`           | Choisir une session                     |
| `Ctrl+b d`           | Détacher (session reste active)         |
| `tmux attach -t <nom>` | Rejoindre une session existante       |
