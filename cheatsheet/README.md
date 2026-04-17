# Cheatsheet CLI

Référence rapide pour l'environnement terminal.
La table des fichiers est dans [`~/dev-setup/CLAUDE.md`](../CLAUDE.md) ; ce dossier contient les détails par outil.

## Accès rapide

| Méthode     | Commande          | Description                                  |
|-------------|-------------------|----------------------------------------------|
| apps       | `gl apps.md`      | Gestion des paquets & formats (OS)           |
| navi widget | `Ctrl+N`          | Sélection interactive, insère dans le shell  |
| navi popup  | `Alt+N`           | Popup tmux — fonctionne dans vim, psql, SSH  |
| navi direct | `navi`            | Interface complète                           |
| doc popup   | `Ctrl+E`          | Popup tmux fzf+glow sur les cheatsheets      |
| doc inline  | `Alt+P`           | Même chose mais inline dans le shell         |
| glow pager  | `gl <fichier>`    | Rend un `.md` dans le pager                  |

## Conventions de ce cheatsheet

- `>` — note neutre
- `### Piège` — gotcha à éviter
- `### Astuce` — tip pratique
- Tables `| col | col |` — la colonne de gauche est toujours la touche / commande / option
- Cross-link entre fichiers via `[texte](./autre.md)`

## Voir aussi

- [plugins/](./plugins/) — Cheatsheets plugins & MCP servers Claude Code ([index](./plugins/README.md))

## Plugins zsh installés

- `zsh-autosuggestions` — suggestions grises basées sur l'historique, `→` pour accepter
- `zsh-syntax-highlighting` — commandes valides en vert, invalides en rouge
- `vi-mode` — navigation vim dans le terminal (`Esc` pour basculer)
- `fzf-tab` — complétion `Tab` fuzzy interactive
- `zsh-history-substring-search` — `↑/↓` filtrent l'historique par ce qui est tapé
