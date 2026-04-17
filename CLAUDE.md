# Contexte — Setup de schaff

## Qui
Mathieu Schaff. Environnement : Tuxedo OS (Ubuntu-based KDE, Linux natif). Machine précédente : WSL2 (Ubuntu) sur Windows — migration effectuée le 2026-04-14.

## Dotfiles et cheatsheet
Tout est dans `~/dev-setup/` — c'est le repo de référence pour la config.

| Fichier / Dossier                        | Contenu                                      |
|------------------------------------------|----------------------------------------------|
| `~/dev-setup/tools.md`                   | Inventaire complet de tous les outils installés, chemins, versions |
| `~/dev-setup/cheatsheet/README.md`       | Index du cheatsheet                          |
| `~/dev-setup/cheatsheet/git.md`          | Git — config delta, workflows, zdiff3, conventions |
| `~/dev-setup/cheatsheet/lazygit.md`      | Lazygit — panels, raccourcis, config, patterns |
| `~/dev-setup/cheatsheet/tmux.md`         | Tmux — sessions, splits, copy-mode, TPM, popup |
| `~/dev-setup/cheatsheet/tools.md`        | delta, eza, bat, glow, fzf, zoxide, rg, fd   |
| `~/dev-setup/cheatsheet/zsh.md`          | Aliases, navigation, updates                 |
| `~/dev-setup/cheatsheet/vi-mode.md`      | Vi-mode dans le terminal                     |
| `~/dev-setup/cheatsheet/navi.md`         | Navi — bindings, config, syntax cheat files  |
| `~/dev-setup/cheatsheet/zed.md`          | Zed — keymaps vim, LSP TS/Biome/vtsls, Ollama |
| `~/dev-setup/cheatsheet/dive.md`         | Dive — TUI d'exploration d'images Docker, config, mode CI |
| `~/dev-setup/cheatsheet/ghostty.md`      | Ghostty — config, raccourcis, thèmes, shell integration, pièges Wayland |
| `~/dev-setup/cheatsheet/update-tools.md` | Script `update-tools` — updater des CLI hors apt/cargo |
| `~/dev-setup/cheatsheet/plugins/`        | Cheatsheets plugins & MCP servers Claude Code |
| `~/dev-setup/scripts/`                   | Scripts : `setup.sh`, `bootstrap.sh`, `install.sh`, `bootstrap-kde.sh`, `update.sh`, `update-tools.sh` |
| `~/dev-setup/cheats/`                    | Cheatsheets navi (`.cheat`) — git, tools, docker, dive, linux, ssh, bun, npm, curl, navi |
| `~/dev-setup/config/.gitconfig`          | Config git de référence (symlink cible de `~/.gitconfig`) |
| `~/dev-setup/config/.zshrc`              | Zshrc de référence                           |
| `~/dev-setup/config/.tmux.conf`          | Tmux de référence                            |
| `~/dev-setup/config/.config/lazygit/config.yml` | Config lazygit de référence           |
| `~/dev-setup/config/.config/navi/config.yaml`   | Config navi (cheats path, couleurs, shell) |
| `~/dev-setup/config/.config/zed/settings.json`  | Config Zed (thème, LSP, Biome, Ollama) |
| `~/dev-setup/config/.config/zed/keymap.json`    | Keymaps Zed (vim normal/visual/insert) |
| `~/dev-setup/config/.config/ghostty/config`     | Config Ghostty (Catppuccin Macchiato, JetBrainsMono Nerd Font) |
| `~/dev-setup/config/.dive.yaml`          | Config dive de référence                     |
| `~/dev-setup/config/.config/starship.toml` | Config Starship (prompt Catppuccin macchiato, texte coloré sans bg) |

> Les fichiers "actifs" sont dans `~/.gitconfig`, `~/.zshrc`, etc. (sous `~/` via symlinks créés par `scripts/install.sh`).  
> `~/dev-setup/` sert de backup/référence versionné.  
> Note historique : sur l'ancienne machine WSL, Zed tournait côté Windows avec config dans `C:\Users\schaf\AppData\Roaming\Zed\`. Sur Tuxedo OS, Zed (s'il est installé) utilise `~/.config/zed/` directement.

## Outils installés (résumé)
- **Shell** : zsh + Oh My Zsh, prompt Starship (Catppuccin macchiato, texte coloré sans bg), plugins : `vi-mode`, `fzf-tab`, `zsh-autosuggestions`, `zsh-syntax-highlighting`, `zsh-history-substring-search`. Complétions custom dans `~/.oh-my-zsh/custom/completions/` pour : `bun`, `rustup`, `cargo`, `gh`, `starship`, `glow`, `pnpm`, `eza`, `delta`.
- **Terminal multiplexer** : tmux + TPM, thème Catppuccin **v2.3.0** macchiato (API v2 — pinned dans `.tmux.conf`). Plugins : `tpm`, `tmux-sensible`, `tmux-yank`, `vim-tmux-navigator`, `tmux-resurrect`, `tmux-continuum`, `catppuccin/tmux`.
- **Terminal émulateur** : **Ghostty** 1.3.1 (Wayland natif, GPU, GTK4). Config `~/.config/ghostty/` symlinkée vers `~/dev-setup/config/.config/ghostty/`. Thème Catppuccin Macchiato, JetBrainsMono Nerd Font 12pt. Aucun binding de split natif — tmux gère le multi-pane.
- **Éditeur** : Neovim (pre-built, `/opt/nvim/bin/nvim`), config AstroNvim v6 dans `~/.config/nvim/`
- **Git TUI** : lazygit (`/usr/local/bin/lazygit`), alias `lg`, popup tmux via `Ctrl+g`
- **Diff** : delta (`~/.cargo/bin/delta`) — configuré dans `~/.gitconfig` et `~/.config/lazygit/config.yml`
- **ls** : eza (`~/.cargo/bin/eza`), aliases `l`, `ll`, `tree`
- **cat** : bat (`~/.cargo/bin/bat`), alias `cat`
- **Fuzzy** : fzf (`~/.fzf/`), zoxide (`z`)
- **Search** : ripgrep (`rg`), fd (`fdfind`, alias `fd`), ag
- **Runtimes** : Node (nvm), Bun, Python (miniconda), Go (latest via go.dev), Rust (rustup)
- **Package managers** : cargo, npm, pnpm, bun, uv, conda
- **AI CLIs** : claude (`~/.local/bin/claude`), gemini (npm global), kimi
- **Éditeur additionnel** : Zed — vim_mode + Biome + vtsls. Sur Tuxedo OS, config dans `~/.config/zed/`. Backup référence dans `~/dev-setup/config/.config/zed/`.
- **Clipboard Wayland** : `wl-clipboard` (`wl-copy`/`wl-paste`) — utilisé par `tmux-yank` via auto-détection, fallback sur `xclip` via XWayland si absent.
- **ssh-agent** : real ssh-agent via systemd user (`~/.config/systemd/user/ssh-agent.service`), socket `$XDG_RUNTIME_DIR/ssh-agent.socket`. Passphrase gérée par **ksshaskpass + KWallet** (prompt une fois au login, stockée dans KWallet). Autostart : `~/.config/autostart/ssh-add.desktop`.

## Config lazygit (ce qu'on a fait)
- `~/.config/lazygit/config.yml` : pager = delta (`--dark --paging=never`), éditeur = nvim
- `~/.zshrc` : `lg()` fonction smart exit (terminal suit le dossier à la sortie)
- `~/.tmux.conf` : `bind -n C-g display-popup ... lazygit` (popup 90×90%)
- `~/.gitconfig` : delta activé comme pager, `side-by-side = true`, `navigate = true`

## Workflow dotfiles
Le hook `pre-commit` copie automatiquement les fichiers actifs dans le repo à chaque commit.
```bash
cd ~/dev-setup && git commit -m "update" && git push
```
Pour déployer sur une nouvelle machine : `~/dev-setup/scripts/install.sh` (backup automatique des fichiers existants).
Repo distant : github.com/MathieuSchaff/dev-setup

## Dossier personnel ~/Mathieu/

```
~/Mathieu/
├── vault/          # Obsidian vault
├── projets/        # projets perso
├── media/{videos,photos,musique}/
├── docs/
└── tmp/
```

XDG user dirs redirigent Documents/Music/Pictures/Videos vers `~/Mathieu/`. Déployé par `scripts/bootstrap-kde.sh`.

## PATH (ordre de priorité)
```
~/.local/bin → ~/miniconda3/bin → ~/.bun/bin → /opt/nvim/bin
→ ~/.local/share/pnpm → ~/.nvm/versions/node/<version>/bin
→ ~/.cargo/bin → /usr/local/bin → /usr/bin → /usr/local/go/bin → ~/.fzf/bin
```
