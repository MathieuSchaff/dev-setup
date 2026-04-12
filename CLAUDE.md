# Contexte — Setup de schaff

## Qui
Mathieu Schaff. Environnement : WSL2 (Ubuntu) sur Windows.

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
| `~/dev-setup/cheatsheet/update-tools.md` | Script `update-tools` — updater des CLI hors apt/cargo |
| `~/dev-setup/scripts/update-tools.sh`    | Script d'update des outils hors package manager (dive, lazygit, ctop, ...) |
| `~/dev-setup/cheats/`                    | Cheatsheets navi (`.cheat`) — git, tools, docker, dive, linux, ssh, bun, npm, curl, navi |
| `~/dev-setup/.gitconfig`                 | Config git de référence (à copier dans `~/.gitconfig`) |
| `~/dev-setup/.zshrc`                     | Zshrc de référence                           |
| `~/dev-setup/.tmux.conf`                 | Tmux de référence                            |
| `~/dev-setup/.config/lazygit/config.yml` | Config lazygit de référence                  |
| `~/dev-setup/.config/navi/config.yaml`   | Config navi (cheats path, couleurs, shell)   |
| `~/dev-setup/.config/zed/settings.json`  | Config Zed (thème, LSP, Biome, Ollama)       |
| `~/dev-setup/.config/zed/keymap.json`    | Keymaps Zed (vim normal/visual/insert)       |
| `~/dev-setup/.dive.yaml`                 | Config dive de référence (copie de `~/.dive.yaml`) |

> Les fichiers "actifs" sont dans `~/.gitconfig`, `~/.zshrc`, etc.  
> Les fichiers Zed actifs sont dans `C:\Users\schaf\AppData\Roaming\Zed\` (Windows).  
> `~/dev-setup/` sert de backup/référence versionné.

## Outils installés (résumé)
- **Shell** : zsh + Oh My Zsh, thème custom (`vcs_info`), plugins : `vi-mode`, `fzf-tab`, `zsh-autosuggestions`, `zsh-syntax-highlighting`, `zsh-history-substring-search`
- **Terminal multiplexer** : tmux + TPM, thème Catppuccin macchiato
- **Éditeur** : Neovim v0.12.1 (pre-built, `/opt/nvim-linux-x86_64/bin/nvim`), config AstroNvim dans `~/.config/nvim/`
- **Git TUI** : lazygit (`/usr/local/bin/lazygit`), alias `lg`, popup tmux via `Ctrl+g`
- **Diff** : delta (`~/.cargo/bin/delta`) — configuré dans `~/.gitconfig` et `~/.config/lazygit/config.yml`
- **ls** : eza (`~/.cargo/bin/eza`), aliases `l`, `ll`, `tree`
- **cat** : bat (`~/.cargo/bin/bat`), alias `cat`
- **Fuzzy** : fzf (`~/.fzf/`), zoxide (`z`)
- **Search** : ripgrep (`rg`), fd (`fdfind`, alias `fd`), ag
- **Runtimes** : Node v24 (nvm), Bun 1.3, Python (miniconda), Go 1.25, Rust 1.94
- **Package managers** : cargo, npm, pnpm, bun, uv, conda
- **AI CLIs** : claude (`~/.local/bin/claude`), gemini (npm global), kimi
- **Éditeur Windows** : Zed (config `C:\Users\schaf\AppData\Roaming\Zed\`), vim_mode + Biome + vtsls, backup dans `~/dev-setup/.config/zed/`

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
Pour déployer sur une nouvelle machine : `~/dev-setup/install.sh` (backup automatique des fichiers existants).
Repo distant : github.com/MathieuSchaff/dotfiles-2026

## PATH (ordre de priorité)
```
~/.local/bin → ~/miniconda3/bin → ~/.bun/bin → /opt/nvim-linux-x86_64/bin
→ ~/.local/share/pnpm → ~/.nvm/versions/node/v24.14.0/bin
→ ~/.cargo/bin → /usr/local/bin → /usr/bin → /usr/local/go/bin → ~/.fzf/bin
```
