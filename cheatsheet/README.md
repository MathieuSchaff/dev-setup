# Cheatsheet CLI

Référence rapide pour l'environnement terminal.

## Fichiers

| Fichier         | Contenu                                     |
|-----------------|---------------------------------------------|
| `zsh.md`        | Aliases git, navigation, tmux               |
| `vi-mode.md`    | Raccourcis vi-mode dans le terminal         |
| `tools.md`      | lazygit, eza, bat, fzf, zoxide, delta       |

## Accès rapide

Ajoute cet alias dans `~/.zshrc` pour ouvrir ce dossier directement :

```zsh
alias cheatsheet='cat ~/cheatsheet/README.md'
alias cs='cd ~/cheatsheet && ls'
```

Ou pour chercher dans tous les fichiers :
```zsh
alias csf='grep -r "" ~/cheatsheet/ | fzf'
```

## Plugins installés

- `zsh-autosuggestions` — suggestions grises basées sur l'historique, `→` pour accepter
- `zsh-syntax-highlighting` — commandes valides en vert, invalides en rouge
- `vi-mode` — navigation vim dans le terminal (`Esc` pour basculer)
- `fzf-tab` — complétion `Tab` fuzzy interactive
- `zsh-history-substring-search` — `↑/↓` filtrent l'historique par ce qui est tapé

## Outils à installer (si pas encore fait)

```zsh
sudo apt install eza bat lazygit git-delta
```
