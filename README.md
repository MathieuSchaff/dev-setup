# dev-setup

Configuration Linux (environnement actuel : Tuxedo OS, Ubuntu-based KDE).

---

## Comment ça marche

Ce repo contient deux choses distinctes :

1. **Les dotfiles** — fichiers de config source (`config/.zshrc`, `config/.gitconfig`, etc.)
2. **La documentation** — guide d'install, inventaire des outils, cheatsheet

`install.sh` crée des **symlinks** depuis `~/` vers les fichiers du repo. Exemple : `~/.zshrc → ~/dev-setup/config/.zshrc`. Toute modification est donc immédiatement active — pas besoin de copie.

Le hook `pre-commit` sync uniquement les fichiers qui ne peuvent pas être symlinkés : configs Zed (côté Windows) et `~/CLAUDE.md`.

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

> Le hook `pre-commit` sync automatiquement les configs Zed (Windows) et `~/CLAUDE.md` dans le repo.

Pour mettre à jour les outils eux-mêmes :

```bash
update-all     # apt, omz, plugins zsh, rust/cargo, uv, lazygit, fzf
update-nvim    # Neovim (pre-built → /opt/nvim/)
update-node    # Node via nvm
update-bun     # Bun
```

---

## Contenu

| Fichier / Dossier        | Contenu                                                        |
|--------------------------|----------------------------------------------------------------|
| `SETUP.md`               | Guide d'installation complet — nouvelle machine                |
| `scripts/`               | Scripts : `setup.sh`, `bootstrap.sh`, `install.sh`, `bootstrap-kde.sh`, `update.sh`, `update-tools.sh` |
| `CLAUDE.md`              | Contexte pour Claude Code — outils, config, chemins            |
| `tools.md`               | Inventaire complet des outils installés, chemins, versions     |
| `cheatsheet/`            | Référence rapide lisible : zsh, lazygit, vi-mode, delta, fzf   |
| `cheats/`                | Cheatsheets navi (`.cheat`) — git, tools, docker, linux, ssh, bun, npm, curl, navi |
| `config/.zshrc`                 | Shell : aliases, fonctions, plugins Oh My Zsh                  |
| `config/.gitconfig`             | Git : delta comme pager, side-by-side, nvim comme éditeur      |
| `config/.tmux.conf`             | Tmux : Catppuccin macchiato, `Ctrl+g` lazygit, `prefix+Ctrl+g` navi |
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
