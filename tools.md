# WSL Tools & CLI

Documentation des outils et CLI disponibles sur ce WSL.

---

## Installés via `apt`

### Outils CLI du quotidien

| Outil | Commande | Chemin | Description |
|-------|----------|--------|-------------|
| [bottom](https://github.com/ClementTsang/bottom) | `btm` | `/usr/bin/btm` | Moniteur système (CPU, RAM, processus) |
| [fd](https://github.com/sharkdp/fd) | `fdfind` | `/usr/bin/fdfind` | Alternative rapide à `find` |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | `rg` | `/usr/bin/rg` | Alternative rapide à `grep` |
| [The Silver Searcher](https://github.com/ggreer/the_silver_searcher) | `ag` | `/usr/bin/ag` | Recherche dans le code (comme `grep`) |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | `z` | `/usr/bin/zoxide` | Navigation rapide dans les dossiers (`cd` intelligent) |
| [tmux](https://github.com/tmux/tmux) | `tmux` | `/usr/bin/tmux` | Multiplexeur de terminal |
| [tree](https://linux.die.net/man/1/tree) | `tree` | `/usr/bin/tree` | Affiche l'arborescence des dossiers |
| [neofetch](https://github.com/dylanaraps/neofetch) | `neofetch` | `/usr/bin/neofetch` | Infos système dans le terminal |
| [xclip](https://github.com/astrand/xclip) | `xclip` | `/usr/bin/xclip` | Copier/coller depuis le terminal |
| [zsh](https://www.zsh.org/) | `zsh` | `/usr/bin/zsh` | Shell principal |
| [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) | (plugin zsh) | `/usr/share/zsh-syntax-highlighting/` | Coloration syntaxique dans zsh |

### Dev / Build

| Outil | Commande | Chemin | Description |
|-------|----------|--------|-------------|
| [git](https://git-scm.com/) | `git` | `/usr/bin/git` | Contrôle de version |
| [curl](https://curl.se/) | `curl` | `/usr/bin/curl` | Requêtes HTTP en ligne de commande |
| [cmake](https://cmake.org/) | `cmake` | `/usr/bin/cmake` | Système de build C/C++ |
| [ffmpeg](https://ffmpeg.org/) | `ffmpeg` | `/usr/bin/ffmpeg` | Traitement audio/vidéo |
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
| [tree-sitter](https://github.com/tree-sitter/tree-sitter) | `tree-sitter` | Parser de code (utilisé par les éditeurs) |
| [rust-analyzer](https://rust-analyzer.github.io/) | `rust-analyzer` | LSP pour Rust |
| rustup | `rustup` | Gestionnaire de versions Rust |
| cargo | `cargo` | Gestionnaire de paquets Rust |

**Versions Rust :** `rustc 1.94.1`

---

## Installés via `nvm` (Node.js)

> Chemin : `~/.nvm/versions/node/v24.14.0/bin/`  
> Version active : **Node v24.14.0**

| Outil | Commande | Description |
|-------|----------|-------------|
| node | `node` | Runtime JavaScript |
| npm | `npm` | Gestionnaire de paquets Node |
| [gemini-cli](https://github.com/google-gemini/gemini-cli) | `gemini` | CLI pour Gemini (Google AI) |

---

## Installés via `bun`

> Chemin : `~/.bun/bin/`  
> Version : **bun 1.3.11**

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

| Langage | Commande | Chemin | Version |
|---------|----------|--------|---------|
| Go | `go` | `/usr/local/go/bin/go` | 1.25.6 |
| Rust | `rustc` | `~/.cargo/bin/rustc` | 1.94.1 |
| Node.js | `node` | `~/.nvm/versions/node/v24.14.0/bin/node` | v24.14.0 |
| Python 3 | `python3` | `/usr/bin/python3` | (apt) |

---

## Installés manuellement (hors gestionnaires)

| Outil | Commande | Chemin | Description |
|-------|----------|--------|-------------|
| [lazygit](https://github.com/jesseduffield/lazygit) | `lg` | `/usr/local/bin/lazygit` | TUI git (installé via script curl) |
| [neovim](https://neovim.io/) | `nvim` | `~/neovim/build/bin/nvim` | Éditeur (compilé depuis les sources) |
| [fzf](https://github.com/junegunn/fzf) | `fzf` | `~/.fzf/` | Fuzzy finder interactif |
| [miniconda](https://docs.conda.io/en/latest/miniconda.html) | `conda` | `~/miniconda3/bin/conda` | Gestionnaire d'environnements Python |
| [pnpm](https://pnpm.io/) | `pnpm` | `~/.local/share/pnpm/` | Gestionnaire de paquets Node alternatif |

---

## Shell : Zsh + Oh My Zsh

> Chemin config : `~/.zshrc`  
> Framework : [Oh My Zsh](https://ohmyz.sh/)  
> Thème : aucun (prompt custom avec `vcs_info`)

### Mise à jour des plugins

Oh My Zsh s'update automatiquement tous les 13 jours. Les plugins custom (`~/.oh-my-zsh/custom/plugins/`) sont des repos git clonés manuellement — ils ne se mettent **pas** à jour automatiquement.

```bash
alias update-zsh-plugins='for d in ~/.oh-my-zsh/custom/plugins/*/; do echo "Updating $(basename $d)..." && git -C "$d" pull; done'
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
| `cat` | `batcat` | Remplace cat par bat |
| `l` | `eza -l --icons --git` | Liste avec icons et statut git |
| `ll` | `eza -la --icons --git` | Liste longue + fichiers cachés |
| `tree` | `eza --tree --icons` | Arborescence avec icons |
| `lh` | `ls -lah` | Liste human-readable |
| `fd` | `fdfind` | Alias pour fd (conflit apt) |
| `lg` | `lazygit` | TUI git |
| `t` | `tmux` | Raccourci tmux |
| `tnew` | `tmux new -s` | Nouvelle session tmux nommée |
| `g` | `git` | Raccourci git |
| `gs` | `git status` | |
| `ga` | `git add` | |
| `gc` | `git commit` | |
| `gp` | `git push` | |
| `gpl` | `git pull` | |
| `gco` | `git checkout` | |
| `gcb` | `git checkout -b` | |
| `gbr` | `git branch` | |
| `config` | `git --git-dir=~/.dotfiles/ --work-tree=~` | Gestion des dotfiles (bare repo) |
| `cheat` | `cd ~/cheatsheet && ls` | Accès au dossier cheatsheet |
| `zdf` | `fd -t d \| fzf \| z` | Navigation fuzzy dans les dossiers |

### Config FZF

```sh
FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --preview "batcat --color=always {}"'
FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
```

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
~/neovim/build/bin                    # nvim
~/.local/share/pnpm                   # pnpm
~/.nvm/versions/node/v24.14.0/bin     # node, npm, gemini
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
| Zed | `/mnt/c/Users/schaf/.../Zed/bin/zed` |
| Warp | `/mnt/c/Users/schaf/.../Warp/bin/warp` |
| Ollama | `/mnt/c/Users/schaf/.../Ollama/ollama.exe` |
| Docker Desktop | `/mnt/c/Program Files/Docker/Docker/resources/bin/` |
| Node.js (Windows) | `/mnt/c/Program Files/nodejs/node.exe` |

> Ces binaires sont accessibles depuis le terminal WSL mais tournent côté Windows.

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

> Dépôt : `~/dotfiles-new/` → github.com/MathieuSchaff/dotfiles-2026  
> Méthode : copie manuelle (pas de bare repo actif)  
> Note : les fichiers sont cachés (`.zshrc`, `.tmux.conf`...) — utiliser `ls -la` pour les voir

### Fichiers trackés

| Fichier | Dernier push |
|---------|-------------|
| `~/dotfiles-new/.zshrc` | 21 jan 2026 |
| `~/dotfiles-new/.bashrc` | 21 jan 2026 |
| `~/dotfiles-new/.tmux.conf` | 21 jan 2026 |
| `~/dotfiles-new/.vimrc` | 21 jan 2026 |
| `~/dotfiles-new/.gitconfig` | 21 jan 2026 |
| `~/dotfiles-new/.config/nvim/` | 21 jan 2026 |
| `~/dotfiles-new/.config/lazygit/` | 21 jan 2026 |

### Workflow de mise à jour

```bash
cd ~/dotfiles-new
cp ~/.zshrc ~/.bashrc ~/.tmux.conf ~/.vimrc ~/.gitconfig .
cp -r ~/.config/{nvim,lazygit} .config/
git add . && git commit -m "Update" && git push
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
| `tmux-plugins/tmux-yank` | Copie dans le clipboard système |
| `catppuccin/tmux` | Thème Catppuccin |

### Copy mode (vi)

| Raccourci | Action |
|-----------|--------|
| `v` | Début de sélection |
| `C-v` | Sélection rectangulaire |
| `y` | Copie dans le clipboard (`xclip`) |

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
- `bottom` se lance avec `btm` (pas `bottom`)
- `uv` est le remplaçant moderne de `pip` + `venv` + `pyenv` en un seul outil
