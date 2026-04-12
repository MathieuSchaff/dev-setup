# Cheatsheet CLI

Référence rapide pour l'environnement terminal.
La table des fichiers est dans [`~/dev-setup/CLAUDE.md`](../CLAUDE.md) ; ce dossier contient les détails par outil.

## Accès rapide

| Méthode     | Commande          | Description                                  |
|-------------|-------------------|----------------------------------------------|
| navi widget | `Ctrl+N`          | Sélection interactive, insère dans le shell  |
| navi tmux   | `prefix + Ctrl+g` | Fonctionne dans vim, psql, SSH...            |
| navi direct | `navi`            | Interface complète                           |
| glow TUI    | `cs`              | Browser multi-fichiers sur ce dossier        |
| glow pager  | `gl <fichier>`    | Rend un `.md` dans le pager                  |
| fzf + glow  | `cheat`           | fzf sur les cheatsheets, preview glow        |

## Conventions de ce cheatsheet

- `>` — note neutre
- `### Piège` — gotcha à éviter
- `### Astuce` — tip pratique
- Tables `| col | col |` — la colonne de gauche est toujours la touche / commande / option
- Cross-link entre fichiers via `[texte](./autre.md)`

## Plugins zsh installés

- `zsh-autosuggestions` — suggestions grises basées sur l'historique, `→` pour accepter
- `zsh-syntax-highlighting` — commandes valides en vert, invalides en rouge
- `vi-mode` — navigation vim dans le terminal (`Esc` pour basculer)
- `fzf-tab` — complétion `Tab` fuzzy interactive
- `zsh-history-substring-search` — `↑/↓` filtrent l'historique par ce qui est tapé
