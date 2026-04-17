# dev-setup

Configuration Linux en dual-boot — **Tuxedo OS** (Ubuntu-based KDE, Linux natif) et **WSL2 Ubuntu** sur Windows. Mêmes dotfiles sur les deux.

---

## Comment ça marche

Ce repo contient deux choses distinctes :

1. **Les dotfiles** — fichiers de config source (`config/.zshrc`, `config/.gitconfig`, etc.)
2. **La documentation** — guide d'install, inventaire des outils, cheatsheet

`install.sh` crée des **symlinks** depuis `~/` vers les fichiers du repo. Exemple : `~/.zshrc → ~/dev-setup/config/.zshrc`. Toute modification est donc immédiatement active — pas besoin de copie.

---

## Nouvelle machine

Voir **[SETUP.md](./SETUP.md)** pour la séquence complète d'installation.

```bash
git clone https://github.com/MathieuSchaff/dev-setup ~/dev-setup
chmod +x ~/dev-setup/scripts/*.sh

# Tout d'un coup (outils + configs)
./scripts/setup.sh

# Ou séparément :
./scripts/bootstrap.sh    # installe les outils uniquement
./scripts/install.sh      # déploie les configs (symlinks) uniquement

exec zsh
```

### Ce que fait `scripts/install.sh`

- Crée des **symlinks** de chaque dotfile vers le repo (`~/.zshrc → ~/dev-setup/config/.zshrc`, etc.)
- Si un fichier existe déjà → backup horodaté dans `~/.dotfiles-backup/` avant remplacement par le symlink
- Si le symlink est déjà en place → ignoré ("link ok")
- Affiche un résumé de ce qui a changé

---

## Mettre à jour depuis une machine existante

Les dotfiles sont des symlinks — toute modification de `~/.zshrc` (par exemple) modifie directement le fichier dans le repo. Il suffit de committer :

```bash
cd ~/dev-setup
git commit -m "update"
git push
```

Pour mettre à jour les outils eux-mêmes :

```bash
update             # safe : apt, omz, zsh-plugins, rust, cargo, go, uv, tools
update --all       # tout, y compris runtimes (node, bun, pnpm, conda)
update <category>  # catégorie précise (apt, rust, node, bun...)
update --list      # voir les catégories disponibles

update-tools       # CLI hors apt/cargo (dive, lazygit, lazydocker, ctop, neovim, fzf)
update-tools --check  # vérifier ce qui est obsolète sans rien changer
```

---

## Contenu

| Fichier / Dossier        | Contenu                                                        |
|--------------------------|----------------------------------------------------------------|
| `SETUP.md`               | Guide d'installation complet — nouvelle machine                |
| `scripts/`               | Scripts : `setup.sh`, `bootstrap.sh`, `install.sh`, `bootstrap-kde.sh`, `update.sh`, `update-tools.sh` |
| `CLAUDE.md`              | Contexte pour Claude Code — outils, config, chemins            |
| `tools.md`               | Inventaire complet des outils installés, chemins, versions     |
| `cheatsheet/`            | Référence rapide en markdown : zsh, tmux, git, lazygit, tools, navi, zed, ghostty, dive, ctop, lazydocker, apps, vi-mode, update-tools, plugins/ |
| `cheats/`                | Cheatsheets navi (`.cheat`) : git, tools, dev-setup, docker, docker-compose, dive, linux, ssh, curl, bun, npm, navi |
| `config/.zshrc`                 | Shell : aliases, fonctions, plugins Oh My Zsh                  |
| `config/.gitconfig`             | Git : delta comme pager, side-by-side, nvim comme éditeur      |
| `config/.tmux.conf`             | Tmux : Catppuccin macchiato, `Ctrl+g` lazygit, `Alt+N` navi, `Alt+U` sessions, `Ctrl+e` cheatsheets |
| `config/.config/lazygit/`       | Lazygit : delta comme pager, nvim comme éditeur                |
| `config/.config/nvim/`          | Neovim : config AstroNvim + syntax `.cheat`                    |
| `config/.config/navi/`          | Navi : cheats path, couleurs, shell zsh                        |
| `config/.config/starship.toml`  | Starship : prompt Catppuccin macchiato, texte coloré sans bg   |

---

## Stack

| Outil | Installé via |
|-------|-------------|
| zsh + Oh My Zsh | apt |
| tmux | apt |
| Neovim (AstroNvim v6) | pre-built → `/opt/nvim/` |
| lazygit | curl GitHub releases |
| delta, eza, bat, navi, starship | cargo |
| glow | `go install` ou snap |
| fzf | git clone |
| Node | nvm |
| Bun | curl |
| Rust | rustup |
| Go | `scripts/bootstrap.sh` (latest depuis go.dev) |
