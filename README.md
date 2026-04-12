# dev-setup

Configuration Linux / macOS (environnement actuel : WSL2 Ubuntu x86_64).

---

## Comment ça marche

Ce repo contient deux choses distinctes :

1. **Les dotfiles** — copies des fichiers de config actifs (`~/.zshrc`, `~/.gitconfig`, etc.)
2. **La documentation** — guide d'install, inventaire des outils, cheatsheet

Le hook `pre-commit` copie automatiquement les fichiers actifs depuis `~/` dans ce repo à chaque commit. Le repo est donc toujours en sync avec la machine.

---

## Nouvelle machine

Voir **[SETUP.md](./SETUP.md)** pour la séquence complète d'installation.

Une fois les outils installés, déployer les configs en une commande :

```bash
git clone https://github.com/MathieuSchaff/dotfiles-2026 ~/dev-setup
chmod +x ~/dev-setup/install.sh
~/dev-setup/install.sh
exec zsh
```

### Ce que fait `install.sh`

- Copie chaque dotfile à son emplacement (`~/.zshrc`, `~/.gitconfig`, `~/.tmux.conf`...)
- Si un fichier existe déjà et est **différent** → backup horodaté dans `~/.dotfiles-backup/` avant d'écraser
- Si un fichier est déjà **identique** → ignoré
- Affiche un résumé de ce qui a changé

---

## Mettre à jour depuis une machine existante

Le hook `pre-commit` se charge de tout — il suffit de committer :

```bash
cd ~/dev-setup
git commit -m "update"
git push
```

Pour mettre à jour les outils eux-mêmes :

```bash
update-all     # apt, omz, plugins zsh, rust/cargo, uv, lazygit, fzf
update-nvim    # Neovim (pre-built → /opt/nvim-linux-x86_64/)
update-node    # Node via nvm
update-bun     # Bun
```

---

## Contenu

| Fichier / Dossier        | Contenu                                                        |
|--------------------------|----------------------------------------------------------------|
| `SETUP.md`               | Guide d'installation complet — nouvelle machine                |
| `install.sh`             | Script de déploiement des dotfiles (avec backup automatique)   |
| `CLAUDE.md`              | Contexte pour Claude Code — outils, config, chemins            |
| `tools.md`               | Inventaire complet des outils installés, chemins, versions     |
| `cheatsheet/`            | Référence rapide lisible : zsh, lazygit, vi-mode, delta, fzf   |
| `cheats/`                | Cheatsheets navi (`.cheat`) — git, tools, docker, linux, ssh, bun, npm, curl, navi |
| `.zshrc`                 | Shell : aliases, fonctions, plugins Oh My Zsh                  |
| `.gitconfig`             | Git : delta comme pager, side-by-side, nvim comme éditeur      |
| `.tmux.conf`             | Tmux : Catppuccin macchiato, `Ctrl+g` lazygit, `prefix+Ctrl+g` navi |
| `.config/lazygit/`       | Lazygit : delta comme pager, nvim comme éditeur                |
| `.config/nvim/`          | Neovim : config AstroNvim + syntax `.cheat`                    |
| `.config/navi/`          | Navi : cheats path, couleurs, shell zsh                        |

---

## Stack

| Outil | Version | Installé via |
|-------|---------|-------------|
| zsh + Oh My Zsh | — | apt |
| tmux | — | apt |
| Neovim | v0.12.1 | pre-built → `/opt/nvim-linux-x86_64/` |
| lazygit | latest | curl GitHub releases |
| delta | 0.19.2 | cargo |
| eza | latest | cargo |
| bat | latest | cargo |
| navi | latest | cargo |
| glow | latest | `sudo snap install glow` ou `go install` |
| fzf | latest | git |
| Node | v24 | nvm |
| Bun | 1.3 | curl |
| Rust | 1.94 | rustup |
