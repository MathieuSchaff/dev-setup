# Tools & CLI

Documentation des outils et CLI installés (Tuxedo OS — Linux natif, précédemment WSL2 Ubuntu).

---

## Installés via `apt`

### Outils CLI du quotidien

| Outil | Commande | Chemin | Description |
|-------|----------|--------|-------------|
| [fd](https://github.com/sharkdp/fd) | `fdfind` | `/usr/bin/fdfind` | Alternative rapide à `find` |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | `rg` | `/usr/bin/rg` | Alternative rapide à `grep` |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | `z` | `/usr/bin/zoxide` | Navigation rapide dans les dossiers (`cd` intelligent) |
| [tmux](https://github.com/tmux/tmux) | `tmux` | `/usr/bin/tmux` | Multiplexeur de terminal |
| [tree](https://linux.die.net/man/1/tree) | `tree` | `/usr/bin/tree` | Affiche l'arborescence des dossiers |
| [neofetch](https://github.com/dylanaraps/neofetch) | `neofetch` | `/usr/bin/neofetch` | Infos système dans le terminal |
| [xclip](https://github.com/astrand/xclip) | `xclip` | `/usr/bin/xclip` | Copier/coller depuis le terminal (X11, fallback sous Wayland via XWayland) |
| [wl-clipboard](https://github.com/bugaevc/wl-clipboard) | `wl-copy` / `wl-paste` | `/usr/bin/wl-copy` | Clipboard natif Wayland (utilisé par `tmux-yank`) |
| [zsh](https://www.zsh.org/) | `zsh` | `/usr/bin/zsh` | Shell principal |
| [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) | (plugin zsh) | `/usr/share/zsh-syntax-highlighting/` | Coloration syntaxique dans zsh |

### Dev / Build

| Outil | Commande | Chemin | Description |
|-------|----------|--------|-------------|
| [git](https://git-scm.com/) | `git` | `/usr/bin/git` | Contrôle de version (PPA `git-core/ppa` — dernière version stable) |
| [curl](https://curl.se/) | `curl` | `/usr/bin/curl` | Requêtes HTTP en ligne de commande |
| [cmake](https://cmake.org/) | `cmake` | `/usr/bin/cmake` | Système de build C/C++ |
| [sqlite3](https://sqlite.org/) | `sqlite3` | `/usr/bin/sqlite3` | Base de données SQLite en CLI |
| [postgresql-client](https://www.postgresql.org/) | `psql` | `/usr/bin/psql` | Client PostgreSQL |
| [python3](https://www.python.org/) | `python3` | `/usr/bin/python3` | Python 3 |
| [pip](https://pip.pypa.io/) | `pip3` | `/usr/bin/pip3` | Gestionnaire de paquets Python |
| build-essential | `gcc`, `g++`, `make` | `/usr/bin/` | Outils de compilation C/C++ |

---

## Installés via `cargo` (Rust)

> Chemin : `~/.cargo/bin/`  
> Géré par : `rustup`

| Outil | Commande | Description |
|-------|----------|-------------|
| [bat](https://github.com/sharkdp/bat) | `bat` | `cat` avec coloration syntaxique (prioritaire sur apt) |
| [delta](https://github.com/dandavison/delta) | `delta` | Diff amélioré pour git |
| [eza](https://github.com/eza-community/eza) | `eza` | Alternative moderne à `ls` |
| [starship](https://starship.rs/) | `starship` | Prompt cross-shell — config `~/.config/starship.toml` |
| [tree-sitter](https://github.com/tree-sitter/tree-sitter) | `tree-sitter` | Parser de code (utilisé par les éditeurs) |
| rustup | `rustup` | Gestionnaire de versions Rust |
| cargo | `cargo` | Gestionnaire de paquets Rust |

---

## Installés via `nvm` (Node.js)

> Chemin : `~/.nvm/versions/node/<version>/bin/`  
> Géré par : nvm (`nvm install node` pour la dernière version)

| Outil | Commande | Description |
|-------|----------|-------------|
| node | `node` | Runtime JavaScript |
| npm | `npm` | Gestionnaire de paquets Node |
| [gemini-cli](https://github.com/google-gemini/gemini-cli) | `gemini` | CLI pour Gemini (Google AI) |

---

## Installés via `bun`

> Chemin : `~/.bun/bin/`  
> Géré par : `bun upgrade`

| Outil | Commande | Description |
|-------|----------|-------------|
| bun | `bun` | Runtime JS + gestionnaire de paquets ultra-rapide |
| bunx | `bunx` | Exécute des packages sans installation (comme `npx`) |

---

## Installés via `~/.local/bin/`

| Outil | Commande | Description |
|-------|----------|-------------|
| [claude](https://claude.ai/code) | `claude` | Claude Code CLI (Anthropic) |
| cursor-agent | `cursor-agent` | Agent Cursor |
| kimi / kimi-cli | `kimi` | CLI Kimi AI |
| [uv](https://github.com/astral-sh/uv) | `uv` | Gestionnaire de paquets Python ultra-rapide (remplace pip) |
| uvx | `uvx` | Exécute des outils Python sans installation |

---

## Langages installés globalement

| Langage | Commande | Chemin | Géré par |
|---------|----------|--------|----------|
| Go | `go` | `/usr/local/go/bin/go` | `bootstrap.sh` / `update` (latest depuis go.dev) |
| Rust | `rustc` | `~/.cargo/bin/rustc` | rustup |
| Node.js | `node` | `~/.nvm/versions/node/` | nvm |
| Python 3 | `python3` | `/usr/bin/python3` | apt |

---

## Installés manuellement (hors gestionnaires)

| Outil | Commande | Chemin | Description |
|-------|----------|--------|-------------|
| [lazygit](https://github.com/jesseduffield/lazygit) | `lg` | `/usr/local/bin/lazygit` | TUI git (installé via script curl) |
| [neovim](https://neovim.io/) | `nvim` | `/opt/nvim/bin/nvim` | Éditeur (pre-built officiel) |
| [fzf](https://github.com/junegunn/fzf) | `fzf` | `~/.fzf/` | Fuzzy finder interactif |
| [navi](https://github.com/denisidoro/navi) | `navi` | `~/.cargo/bin/navi` | Cheatsheet interactif — commandes avec variables fzf |
| [miniconda](https://docs.conda.io/en/latest/miniconda.html) | `conda` | `~/miniconda3/bin/conda` | Gestionnaire d'environnements Python |
| [pnpm](https://pnpm.io/) | `pnpm` | `~/.local/share/pnpm/` | Gestionnaire de paquets Node alternatif |

---

## Shell : Zsh + Oh My Zsh

> Chemin config : `~/.zshrc`  
> Framework : [Oh My Zsh](https://ohmyz.sh/)  
> Prompt : [Starship](https://starship.rs/) — config `~/.config/starship.toml`, palette Catppuccin macchiato, texte coloré sans background

### Mise à jour des plugins

Oh My Zsh s'update automatiquement tous les 13 jours. Les plugins custom (`~/.oh-my-zsh/custom/plugins/`) sont des repos git clonés manuellement — ils ne se mettent **pas** à jour automatiquement.

```bash
update zsh-plugins   # git pull sur chaque plugin custom
```

### Plugins Oh My Zsh actifs

| Plugin | Description |
|--------|-------------|
| `git` | Aliases git intégrés |
| `vi-mode` | Keybindings vim dans le terminal |
| `fzf-tab` | Complétion tab avec fuzzy finder |
| `zsh-autosuggestions` | Suggestions basées sur l'historique |
| `zsh-syntax-highlighting` | Coloration syntaxique des commandes |
| `zsh-history-substring-search` | Recherche dans l'historique avec ↑↓ |

### Aliases définis

| Alias | Commande | Description |
|-------|----------|-------------|
| `c` | `clear` | Vider le terminal |
| `cat` | `bat` | Remplace cat par bat |
| `l` | `eza -l --icons --git` | Liste avec icons et statut git |
| `ll` | `eza -la --icons --git` | Liste longue + fichiers cachés |
| `tree` | `eza --tree --icons` | Arborescence avec icons |
| `lh` | `ls -lah` | Liste human-readable |
| `fd` | `fdfind` | Alias pour fd (conflit apt) |
| `lg` | lazygit (smart exit — terminal suit le dossier) | TUI git |
| `lzd` | `lazydocker` | TUI Docker / Compose |
| `t` | fonction | Crée sessions doc/dev/tests au démarrage, sinon attach |
| `tn <nom>` | fonction | Crée une session tmux en arrière-plan |
| `tnew` | `tmux new -s` | Crée une session nommée |
| `gl <fichier>` | `glow -p` | Render Markdown avec glow (pager) |
| `cs` | fonction | fzf sur `cheatsheet/` + preview glow (loop, `q` pour revenir) |
| `g` | `git` | Raccourci git |
| `gs` | `git status` | |
| `ga` | `git add` | |
| `gc` | `git commit` | |
| `gp` | `git push` | |
| `gpl` | `git pull` | |
| `gco` | `git checkout` | |
| `gcb` | `git checkout -b` | |
| `gbr` | `git branch` | |
| `config` | `git --git-dir=$HOME/dotfiles/ --work-tree=$HOME` | Gestion des dotfiles (bare repo) |
| `zdf` | `fd -t d \| fzf \| z` | Navigation fuzzy dans les dossiers |

### Config FZF

```sh
FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
```

### navi — Cheatsheet interactif

Config : `~/.config/navi/config.yaml`  
Cheats : `~/dev-setup/cheats/` (versionnés dans ce repo)

| Raccourci | Contexte | Effet |
|-----------|----------|-------|
| `Ctrl+N` | Shell zsh | Widget — insère la commande choisie dans le buffer |
| `prefix + Ctrl+g` | Tmux (partout) | Split temporaire — colle dans le pane précédent |
| `navi` | Terminal | Lance l'interface complète |

### Historique

```sh
HISTSIZE=50000
SAVEHIST=50000
# Sans doublons, partagé entre sessions
```

---

## Variables d'environnement clés

| Variable | Valeur |
|----------|--------|
| `SHELL` | `/usr/bin/zsh` |
| `TERM` | `xterm-256color` |
| `LANG` / `LC_ALL` | `en_US.UTF-8` |
| `BUN_INSTALL` | `~/.bun` |
| `NVM_DIR` | `~/.nvm` |
| `PNPM_HOME` | `~/.local/share/pnpm` |

---

## `$PATH` — Ordre de résolution

Les binaires sont cherchés dans cet ordre (priorité décroissante) :

```
~/.local/bin                          # claude, uv, uvx, cursor-agent, kimi
~/miniconda3/bin                      # conda, python
~/.bun/bin                            # bun, bunx
/opt/nvim/bin                          # nvim
~/.local/share/pnpm                   # pnpm
~/.nvm/versions/node/<version>/bin    # node, npm, gemini
~/.cargo/bin                          # rustc, cargo, bat, delta, eza...
/usr/local/bin + /usr/bin + /bin      # outils système apt
/usr/local/go/bin                     # go, gofmt
~/.fzf/bin                            # fzf
```

> Note : `~/.local/bin` apparaît plusieurs fois dans le PATH (doublon dans `.zshrc`).

---

## Outils Windows accessibles depuis WSL (`/mnt/c/...`)

| Outil | Chemin Windows (via `/mnt/c/`) |
|-------|-------------------------------|
| Git (Windows) | `/mnt/c/Program Files/Git/cmd/git.exe` |
| GitHub CLI | `/mnt/c/Program Files/GitHub CLI/gh.exe` |
| VS Code | `/mnt/c/Users/schaf/.../Microsoft VS Code/bin/code` |
| Cursor | `/mnt/c/Users/schaf/.../cursor/resources/app/bin/cursor` |
| Zed | `/mnt/c/Users/schaf/AppData/Local/Programs/Zed/bin/zed` |
| Warp | `/mnt/c/Users/schaf/.../Warp/bin/warp` |
| Ollama | `/mnt/c/Users/schaf/.../Ollama/ollama.exe` |
| Docker Desktop | `/mnt/c/Program Files/Docker/Docker/resources/bin/` |
| Node.js (Windows) | `/mnt/c/Program Files/nodejs/node.exe` |

> Ces binaires sont accessibles depuis le terminal WSL mais tournent côté Windows.

---

## Zed — Éditeur (Windows)

> Cheatsheet complet (keymaps, LSP, Biome, Ollama, pièges) → **[cheatsheet/zed.md](./cheatsheet/zed.md)**

- **Config source :** `C:\Users\schaf\AppData\Roaming\Zed\`
- **Backup versionné :** `~/dev-setup/config/.config/zed/` (syncé automatiquement via le hook pre-commit, déployé par `install.sh` avec auto-détection WSL)
- **Stack :** vim_mode + base_keymap VSCode, Catppuccin Mocha, vtsls + Biome pour TS/TSX/JS/JSX, format_on_save, Ollama (Qwen Coder 7B)

---

## Terminal émulateur — Ghostty

> Cheatsheet complet → **[cheatsheet/ghostty.md](./cheatsheet/ghostty.md)**

- **Binaire** : `/usr/bin/ghostty` (version 1.3.1)
- **Config source** : `~/.config/ghostty/` → symlink vers `~/dev-setup/config/.config/ghostty/`
- **Stack** : Catppuccin Macchiato, JetBrainsMono Nerd Font 12pt, Wayland natif (KWin), `window-decoration = client` (requis GTK/Wayland), blur KDE, `copy-on-select`, scrollback 100k lignes.
- **Pas de splits/tabs bindés** : tmux prend en charge toute la gestion multi-pane.

---

## Claude Code — Plugins installés

> Chemin : `~/.claude/plugins/cache/claude-plugins-official/`

| Plugin | Version |
|--------|---------|
| superpowers | 5.0.7 |
| frontend-design | — |
| feature-dev | — |
| code-review | — |
| code-simplifier | 1.0.0 |
| claude-md-management | 1.0.0 |
| ralph-loop | 1.0.0 |
| typescript-lsp | 1.0.0 |
| firecrawl | 1.0.8 |
| claude-code-setup | 1.0.0 |

---

## Dotfiles

> Dépôt : `~/dev-setup/` → github.com/MathieuSchaff/dev-setup  
> Méthode : `install.sh` crée des **symlinks** — les fichiers actifs pointent directement vers le repo

### Fichiers symlinkés

| Symlink | Pointe vers |
|---------|-------------|
| `~/.zshrc` | `~/dev-setup/config/.zshrc` |
| `~/.bashrc` | `~/dev-setup/config/.bashrc` |
| `~/.gitconfig` | `~/dev-setup/config/.gitconfig` |
| `~/.tmux.conf` | `~/dev-setup/config/.tmux.conf` |
| `~/.vimrc` | `~/dev-setup/config/.vimrc` |
| `~/.dive.yaml` | `~/dev-setup/config/.dive.yaml` |
| `~/.config/lazygit/` | `~/dev-setup/config/.config/lazygit/` |
| `~/.config/nvim/` | `~/dev-setup/config/.config/nvim/` |
| `~/.config/bat/` | `~/dev-setup/config/.config/bat/` |
| `~/.config/eza/` | `~/dev-setup/config/.config/eza/` |
| `~/.config/navi/` | `~/dev-setup/config/.config/navi/` |
| `~/.config/glow/` | `~/dev-setup/config/.config/glow/` |
| `~/.config/starship.toml` | `~/dev-setup/config/.config/starship.toml` |
| `~/.config/ghostty/` | `~/dev-setup/config/.config/ghostty/` |

> Configs Zed et `~/CLAUDE.md` sont copiés (pas symlinkés) via le hook `pre-commit`.

### Workflow de mise à jour

```bash
cd ~/dev-setup
git commit -m "update"   # les dotfiles sont déjà dans le repo (symlinks)
git push                  # le pre-commit sync Zed + CLAUDE.md automatiquement
```

---

## Config tmux (`~/.tmux.conf`)

### Général

| Option | Valeur | Description |
|--------|--------|-------------|
| `default-terminal` | `tmux-256color` | Couleurs 256 + RGB |
| `escape-time` | `10ms` | Délai Escape réduit (pour neovim) |
| `focus-events` | on | Événements focus (pour neovim) |
| `mouse` | on | Souris activée |
| `base-index` | `1` | Fenêtres et panes numérotés à partir de 1 |
| `renumber-windows` | on | Renumérotation auto après fermeture |
| `mode-keys` | `vi` | Mode vi dans le copy mode |

### Thème : Catppuccin Macchiato

Plugin `catppuccin/tmux` avec le flavour **macchiato**.  
Barre de statut affiche : `répertoire · user · session`

### Plugins (via TPM)

| Plugin | Description |
|--------|-------------|
| `tmux-plugins/tpm` | Gestionnaire de plugins tmux |
| `tmux-plugins/tmux-sensible` | Defaults sensibles |
| `tmux-plugins/tmux-yank` | Copie dans le clipboard système (détecte wl-copy/xclip) |
| `christoomey/vim-tmux-navigator` | Navigation transparente tmux ↔ Neovim (`Ctrl+h/j/k/l`) |
| `tmux-plugins/tmux-resurrect` | Sauvegarde/restore manuel des sessions |
| `tmux-plugins/tmux-continuum` | Sauvegarde auto + restore au démarrage |
| `catppuccin/tmux#v2.3.0` | Thème Catppuccin (pinné en v2.3.0) |

### Bindings personnalisés

| Raccourci | Effet |
|-----------|-------|
| `Ctrl+g` | Ouvrir lazygit en popup flottant (sans préfixe) |
| `Alt+n` | Ouvrir navi dans un split temporaire |
| `Ctrl+h/j/k/l` | Naviguer panes tmux / splits Neovim (vim-tmux-navigator) |
| `prefix + "` / `%` | Split démarrant dans le cwd du pane courant |

### Copy mode (vi)

| Raccourci | Action |
|-----------|--------|
| `v` | Début de sélection |
| `C-v` | Sélection rectangulaire |
| `y` | Copie dans le clipboard (via `tmux-yank` → `wl-copy` sous Wayland) |

---

## Config git (`~/.gitconfig`)

```ini
[user]
  name  = schaff
  email = schaff.mathieu93@gmail.com
[init]
  defaultBranch = main
[core]
  editor = nvim
```

---

## Notes

- `fdfind` est la commande apt pour `fd` (conflit de nom). Alias recommandé : `alias fd=fdfind`
- `bat` apt vs cargo : le binaire cargo (`~/.cargo/bin/bat`) est prioritaire si `~/.cargo/bin` est en tête de `$PATH`
- `uv` est le remplaçant moderne de `pip` + `venv` + `pyenv` en un seul outil
