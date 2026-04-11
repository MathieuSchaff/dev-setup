# 🛠️ Dev Setup - Mathieu's Configuration

---

## 📋 Table des matières

- [Tout mettre à jour](#-tout-mettre-à-jour)
- [Quick Start](#-quick-start)
- [Système d'exploitation](#%EF%B8%8F-syst%C3%A8me-dop%C3%A9ration)
- [Shell & Terminal](#-shell--terminal)
- [Développement JavaScript/TypeScript](#-développement-javascripttypescript)
- [Rust & Compilation](#-rust--compilation)
- [Contrôle de version](#-contrôle-de-version)
- [Édition de code](#-édition-de-code)
- [Utilitaires système](#-utilitaires-système)
- [Navigation & Recherche](#-navigation--recherche)
- [DevOps & Containers](#-devops--containers)
- [Configuration système](#-configuration-système)
- [Ressources](#-ressources)

---

## 🔄 Tout mettre à jour

### `update-all` — safe, lancer quand tu veux

Met à jour tout ce qui ne risque pas de casser des projets :

```bash
update-all()  # apt, omz, plugins zsh, rustup + cargo tools, uv, lazygit, fzf
```

| Outil | Méthode |
|-------|---------|
| apt (paquets système) | `apt update && upgrade` |
| Oh My Zsh | `omz update` |
| Plugins zsh custom | `git pull` sur chaque plugin |
| Rust + rustc + cargo | `rustup update` |
| bat, delta, eza, tree-sitter | `cargo install` |
| uv | `uv self update` |
| lazygit | script curl GitHub releases |
| fzf | `git pull + ./install --all` |

---

### Commandes séparées — lancer manuellement

> ⚠️ Ces outils peuvent casser des projets existants si mis à jour sans précaution.

| Commande | Ce qu'elle fait |
|----------|----------------|
| `update-node` | Node via nvm + npm packages globaux (`gemini-cli`, `corepack`) |
| `update-bun` | bun |
| `update-conda` | conda/miniconda |
| `update-nvim` | Neovim via pre-built archive (`/opt/nvim-linux-x86_64/`) |

#### `uv` — c'est quoi ?

[uv](https://github.com/astral-sh/uv) est un remplaçant moderne de `pip` + `venv` + `pyenv`, écrit en Rust. Ultra-rapide. Installé dans `~/.local/bin/uv`.

```bash
uv venv          # créer un environnement virtuel
uv pip install   # installer des packages Python
uv self update   # se mettre à jour
```

#### npm packages globaux installés

| Package | Version |
|---------|---------|
| `@google/gemini-cli` | 0.37.1 |
| `corepack` | 0.34.6 |
| `npm` | 11.9.0 |

---

## 🚀 Quick Start

```bash
# 1. Update système
sudo apt update && sudo apt upgrade -y

# 2. Installer dépendances de base
sudo apt install -y \
  zsh curl git build-essential \
  zsh-syntax-highlighting \
  tree ripgrep fd-find unzip bat \
  python3-dev python3-pip \
  libssl-dev libsqlite3-dev bison \
  wget neofetch mlocate

# 3. Installer les gestionnaires de version
# → Voir sections spécifiques ci-dessous

# 4. Cloner dotfiles
git clone <ton-repo> ~/.config/dotfiles

# 5. Lancer installation complète
# → Voir chaque section pour détails
```

---

## 🖥️ Système d'exploitation

**OS** : WSL Ubuntu (sur Windows)  
**Architecture** : x86_64  
**Distribution** : Ubuntu 22.04 LTS (ou plus récent)

### Maintenance système

```bash
# Update & Upgrade
sudo apt update && sudo apt upgrade -y

# Nettoyer les packages non utilisés
sudo apt autoremove -y && sudo apt autoclean -y

# Vérifier l'espace disque
df -h

# Voir les gros dossiers
du -sh /var/* | sort -hr | head -10
```

---

## 🐚 Shell & Terminal

### **ZSH** - Shell principal

[GitHub: ohmyzsh/ohmyzsh](https://github.com/ohmyzsh/ohmyzsh)  
[Docs: https://ohmyz.sh/](https://ohmyz.sh/)

```bash
# Installer zsh
sudo apt install -y zsh

# Installer Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Changer le shell par défaut
chsh -s $(which zsh)
```

**Config** : `~/.zshrc`

---

### **Zsh Syntax Highlighting** - Coloration syntaxe en temps réel

[GitHub: zsh-users/zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)

```bash
# Installation via Oh My Zsh (méthode utilisée)
git clone https://github.com/zsh-users/zsh-syntax-highlighting \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Ajouter dans plugins=() dans ~/.zshrc :
# plugins=(... zsh-syntax-highlighting)
```

**Localisation** : `~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/`

### **Mise à jour des plugins Oh My Zsh custom**

Les plugins custom ne se mettent pas à jour automatiquement.

```bash
# Alias à ajouter dans ~/.zshrc
alias update-zsh-plugins='for d in ~/.oh-my-zsh/custom/plugins/*/; do echo "Updating $(basename $d)..." && git -C "$d" pull; done'
```

---

### **Tmux** - Multiplexeur terminal

[GitHub: tmux/tmux](https://github.com/tmux/tmux)  
[Wiki: tmux](https://github.com/tmux/tmux/wiki)

```bash
# Installation
sudo apt install -y tmux

# Configuration
~/.tmux.conf
```

**Utilité** : Gérer plusieurs sessions, splitter l'écran, persister les sessions.

---

### **Bottom (btm)** - Moniteur système

[GitHub: ClementTsang/bottom](https://github.com/ClementTsang/bottom)

```bash
# Installation via Cargo
cargo install bottom

# Ou via APT
sudo apt install -y bottom

# Utilisation
btm
```

**Alias** : `tt` pour basculer dans le terminal Neovim

---

## 🎯 Développement JavaScript/TypeScript

### **Bun** - Runtime JS/TS rapide

[Official: bun.sh](https://bun.sh/)  
[GitHub: oven-sh/bun](https://github.com/oven-sh/bun)

```bash
# Installation (curl)
curl -fsSL https://bun.sh/install | bash

# Ajouter à PATH
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
```

**Localisation** : `~/.bun/bin/bun`  
**Utilité** : Runtime JS/TS ultra-rapide, bundler, package manager

---

### **Node.js & NVM** - JavaScript runtime

[Official: nodejs.org](https://nodejs.org/)  
[GitHub: nvm-sh/nvm](https://github.com/nvm-sh/nvm)

```bash
# Installer NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash

# Recharger le shell
exec zsh

# Installer Node.js
nvm install node      # Version LTS
nvm install 24.14.0   # Version actuelle (avril 2026)
nvm use node

# Voir les versions installées
nvm list

# Définir la version par défaut
nvm alias default node
```

**Localisation** : `~/.nvm/versions/node/`  
**Utilité** : Gérer plusieurs versions de Node.js

---

### **npm** - Package manager Node

Inclus avec Node.js

```bash
# Packages globaux
npm install -g <package>

# Voir les packages globaux installés
npm list -g --depth=0

# Localisation
~/.npm-global/lib/node_modules/
```

---

### **pnpm** - Package manager alternatif

[Official: pnpm.io](https://pnpm.io/)  
[GitHub: pnpm/pnpm](https://github.com/pnpm/pnpm)

```bash
# Installation
npm install -g pnpm

# Ou via Bun
bun install -g pnpm

# Utilisation
pnpm install
pnpm add <package>
```

**Avantage** : Plus rapide qu'npm, gestion d'espace disque optimisée

---

### **Python 3** - Langage de programmation

```bash
# Installation
sudo apt install -y python3 python3-pip python3-dev

# Vérifier
python3 --version
pip3 --version

# Localisation
which python3  # Généralement /usr/bin/python3
```

---

## 🦀 Rust & Compilation

### **Rust** - Langage de programmation compilé

[Official: rustup.rs](https://rustup.rs/)  
[GitHub: rust-lang/rust](https://github.com/rust-lang/rust)

```bash
# Installation via rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Ajouter à PATH
source $HOME/.cargo/env

# Vérifier
rustc --version
cargo --version
```

**Localisation** : `~/.cargo/bin/`

---

### **Cargo** - Package manager Rust

Inclus avec Rust

```bash
# Créer un nouveau projet
cargo new mon-projet

# Compiler
cargo build

# Exécuter
cargo run

# Installer un binaire
cargo install <crate>
```

---

### **Rustfmt** - Formateur de code Rust

Inclus avec Rust (ou installer)

```bash
# Formater un fichier
rustfmt main.rs

# Formater le projet entier
cargo fmt
```

---

### **Clippy** - Linter Rust

Inclus avec Rust (ou installer)

```bash
# Vérifier le code
cargo clippy
```

---

### **Rust Analyzer** - LSP pour Rust

[GitHub: rust-lang/rust-analyzer](https://github.com/rust-lang/rust-analyzer)

Utilisé pour l'auto-complétion et diagnostiques dans Neovim/VS Code.

```bash
# Installation via rustup
rustup component add rust-analyzer
```

---

## 📚 Contrôle de version

### **Git** - Contrôle de version décentralisé

[Official: git-scm.com](https://git-scm.com/)

```bash
# Installation
sudo apt install -y git

# Configuration
git config --global user.name "Mathieu"
git config --global user.email "mathieu@example.com"

# Générer clés SSH
ssh-keygen -t ed25519 -C "mathieu@example.com"
cat ~/.ssh/id_ed25519.pub  # Copier dans GitHub/GitLab

# Test connexion
ssh -T git@github.com
```

**Config globale** : `~/.gitconfig`  
**Localisation** : `/usr/bin/git`

---

### **Lazygit** - UI Git interactive

[GitHub: jesseduffield/lazygit](https://github.com/jesseduffield/lazygit)

```bash
# Installation via script curl (méthode utilisée)
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*') \
  && curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" \
  && tar xf /tmp/lazygit.tar.gz -C /tmp lazygit \
  && sudo install /tmp/lazygit /usr/local/bin

# Mise à jour : utiliser l'alias update-lazygit dans .zshrc

# Utilisation
lazygit  # ou alias: lg
```

**Localisation** : `/usr/local/bin/lazygit`  
**Utilité** : Interface interactive pour git (stage, commit, push, résoudre conflits)

---

### **GitHub CLI (gh)** - Interagir avec GitHub depuis terminal

[Official: cli.github.com](https://cli.github.com/)  
[GitHub: cli/cli](https://github.com/cli/cli)

```bash
# Installation
sudo apt install gh

# Authentification
gh auth login

# Créer un repo
gh repo create mon-repo

# Créer une PR
gh pr create

# Voir les issues
gh issue list
```

---

## ✏️ Édition de code

### **Neovim** - Éditeur modal ultra-personnalisable

[Official: neovim.io](https://neovim.io/)  
[GitHub: neovim/neovim](https://github.com/neovim/neovim)

```bash
# Installation
sudo apt install -y neovim

# Ou compiler depuis source (plus récent)
git clone https://github.com/neovim/neovim
cd neovim && make CMAKE_BUILD_TYPE=Release
sudo make install

# Vérifier
nvim --version
```

**Config** : `~/.config/nvim/`  
**Utilité** : Éditeur ultra-rapide, hautement configurable avec Lua

---

### **LSP (Language Server Protocol)** - Auto-complétion intelligente

Nécessaire pour Neovim. Configuration via Lua (`~/.config/nvim/`).

**LSPs recommandés** :

- `rust-analyzer` - Rust
- `ts_ls` - TypeScript/JavaScript
- `pyright` - Python
- `gopls` - Go
- `svelte` - Svelte
- `eslint` - ESLint

Installation via Mason (Neovim plugin) ou manuellement.

---

### **Tree-sitter** - Parser syntaxe générique

[GitHub: tree-sitter/tree-sitter](https://github.com/tree-sitter/tree-sitter)

```bash
# Installation
npm install -g tree-sitter-cli

# Ou via Cargo
cargo install tree-sitter-cli

# Utilité : Coloration syntaxe et navigation dans Neovim
```

---

### **VS Code** - IDE léger (optionnel)

[Official: code.visualstudio.com](https://code.visualstudio.com/)

```bash
# Installation
sudo apt install code

# Configuration
~/.config/Code/
```

**Localisation des extensions** : `~/.vscode/extensions/`

---

## 🔍 Navigation & Recherche

### **FZF** - Fuzzy finder interactif

[GitHub: junegunn/fzf](https://github.com/junegunn/fzf)

```bash
# Installation
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
cd ~/.fzf && ./install

# Intégration Shell
# Ajouter à ~/.zshrc :
# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
```

**Utilité** : Recherche interactive de fichiers, commandes, historique

---

### **fd** - Alternative à `find` (plus rapide)

[GitHub: sharkdp/fd](https://github.com/sharkdp/fd)

```bash
# Installation via APT
sudo apt install -y fd-find

# Créer un alias
echo "alias fd='fdfind'" >> ~/.zshrc

# Utilisation
fd pattern          # Trouver fichiers
fd -x ls -lh {}     # Exécuter commande sur résultats
```

**Localisation** : `/usr/bin/fdfind`

---

### **Zoxide** - Jump rapide entre dossiers

[GitHub: ajeetdsouza/zoxide](https://github.com/ajeetdsouza/zoxide)  
[Docs: zoxide.rs](https://zoxide.rs/)

```bash
# Installation via Cargo
cargo install zoxide

# Ou via APT
sudo apt install zoxide

# Initialiser dans ~/.zshrc :
# eval "$(zoxide init zsh)"

# Utilisation
z mon-projet    # Jump vers dossier (fuzzy matching)
z -i            # Mode interactif
```

**Alias personnel** : `zdf` = `fd` + `fzf` + `zoxide`

---

### **Ripgrep** - Better grep

[GitHub: BurntSushi/ripgrep](https://github.com/BurntSushi/ripgrep)

```bash
# Installation
sudo apt install -y ripgrep

# Utilisation
rg pattern                  # Chercher pattern récursivement
rg pattern -t js            # Chercher dans fichiers JS uniquement
rg -C 2 pattern             # Contexte (2 lignes avant/après)
```

**Alias** : Généralement intégré dans Telescope (Neovim) avec `fw`

---

### **Bat** - Cat amélioré (coloration + numéros)

[GitHub: sharkdp/bat](https://github.com/sharkdp/bat)

```bash
# Installation via cargo (recommandé)
cargo install bat

# Créer alias (apt installe sous le nom batcat)
echo "alias cat='batcat'" >> ~/.zshrc

# Utilisation
bat fichier.js
```

**Localisation** : `~/.cargo/bin/bat` (cargo, prioritaire sur apt)

---

## 💾 Utilitaires système

### **Neofetch** - Afficher infos système

```bash
# Installation
sudo apt install -y neofetch

# Utilisation
neofetch
```

---

### **gdu (Disk Usage)** - Analyser espace disque

[GDU : go disk usage](https://github.com/dundee/gdu)

```bash
# Voir utilisation top-level
```

---

### **Bottom** - Moniteur système (déjà listé plus haut)

Alternative à `top`/`htop` avec meilleure UI

---

### **Chafa** - Afficher images en terminal

[GitHub: hpjansson/chafa](https://github.com/hpjansson/chafa)

```bash
# Installation
sudo apt install -y chafa

# Utilisation
chafa image.png
```

---

### **Caca-utils** - Utilitaires ASCII art

[GitHub: cacalabs/libcaca](https://github.com/cacalabs/libcaca)

```bash
# Installation
sudo apt install -y caca-utils

# Utilitaires
img2txt image.png       # Convertir image en ASCII
cacaplay animation.asf  # Jouer animation en ASCII
```

---

## 🐳 DevOps & Containers

### **Docker** - Containerisation

[Official: docker.com](https://www.docker.com/)

```bash
# Installation
sudo apt-get install docker.io

# Ajouter utilisateur au groupe docker
sudo usermod -aG docker $USER
newgrp docker

# Test
docker --version
docker run hello-world
```

---

### **Kubectl** - Client Kubernetes

[Official: kubernetes.io](https://kubernetes.io/docs/reference/kubectl/)

```bash
# Installation
sudo apt install -y kubectl

# Ou via Cargo
cargo install kubectl

# Utilisation
kubectl get pods
kubectl apply -f deployment.yaml
```

---

### **Claude CLI** - CLI Anthropic

[GitHub: anthropics/claude-cli](https://github.com/anthropics/claude-cli)

```bash
# Installation (via npm)
npm install -g @anthropic-ai/claude-cli

# Authentification
claude auth

# Utilisation
claude chat "Ma question"
```

---

### **Cursor Agent** - Agent Cursor

Intégration avec éditeur Cursor

---

### **Cagent** - Docker agent

Utilitaire pour gérer agents Docker

---

## ⚙️ Configuration système

### **Dotfiles** - Gestion des fichiers de configuration

Structure recommandée :

```
~/.config/dotfiles/
├── .zshrc               ← Configuration Zsh
├── .tmux.conf           ← Configuration Tmux
├── nvim/                ← Configuration Neovim
│   ├── init.lua
│   ├── lua/
│   │   ├── config/
│   │   └── plugins/
│   └── after/
├── git/
│   └── .gitconfig       ← Configuration Git globale
├── vscode/              ← Configuration VS Code
└── scripts/             ← Scripts utilitaires
```

**Gestion** : Bare Git repository (config alias)

```bash
# Initialiser
git init --bare ~/.config/dotfiles-repo

# Créer alias
git config --global alias.config '!git --git-dir=$HOME/.config/dotfiles-repo --work-tree=$HOME'

# Cloner
git config config status.showUntrackedFiles no
```

---

### **SSH** - Clés et configuration

```bash
# Localisation
~/.ssh/

# Générer clé
ssh-keygen -t ed25519 -C "comment"

# Voir clé publique
cat ~/.ssh/id_ed25519.pub

# Config SSH
~/.ssh/config

# Permissions
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
```

---

### **Sudo** - Escalade de privilèges

```bash
# Configuration
sudo visudo

# Ou éditer
sudo nano /etc/sudoers.d/mon-user
```

---

## 📦 Package Managers Résumé

| Manager   | Langage               | Commande              | Localisation     |
| --------- | --------------------- | --------------------- | ---------------- |
| **apt**   | Système               | `sudo apt install`    | `/usr/bin/`      |
| **npm**   | JavaScript            | `npm install -g`      | `~/.npm-global/` |
| **cargo** | Rust                  | `cargo install`       | `~/.cargo/bin/`  |
| **pip**   | Python                | `pip3 install --user` | `~/.local/bin/`  |
| **bun**   | JavaScript/TypeScript | `bun install`         | `~/.bun/`        |
| **pnpm**  | JavaScript            | `pnpm install -g`     | Divers           |

---

## 🔗 Ressources essentielles

### Documentation

- [Linux Directory Structure](https://tldp.org/LDP/Linux-Filesystem-Hierarchy-Standard/html/)
- [Bash Manual](https://www.gnu.org/software/bash/manual/)
- [Zsh Manual](https://zsh.sourceforge.io/Doc/Release/)
- [Neovim Docs](https://neovim.io/doc/user/)
- [Rust Book](https://doc.rust-lang.org/book/)

### Communities

- [r/Linux](https://reddit.com/r/linux)
- [r/neovim](https://reddit.com/r/neovim)
- [r/rust](https://reddit.com/r/rust)
- [Arch Linux Wiki](https://wiki.archlinux.org/) - Excellente doc même si on n'utilise pas Arch

## ✅ Checklist nouvelle machine

- [ ] Mettre à jour système : `sudo apt update && sudo apt upgrade -y`
- [ ] Installer dépendances : Voir section Quick Start
- [ ] Installer ZSH + Oh My Zsh
- [ ] Installer NVM + Node.js
- [ ] Installer Rust + Cargo
- [ ] Installer outils CLI : fzf, fd, zoxide, ripgrep, bat
- [ ] Configurer Git + SSH
- [ ] Cloner dotfiles
- [ ] Configurer Neovim
- [ ] Configurer Tmux
- [ ] Tester tous les alias/outils

---

## 📝 Notes

- **WSL Ubuntu** : Certains outils peuvent nécessiter des configs spéciales (X11, Display, etc.)
- **Mises à jour** : Mettre à jour ce README régulièrement
- **Versions** : Les versions des outils changent, adapter les commandes si nécessaire
- **Performance** : Préférer `fd` à `find`, `ripgrep` à `grep`, `bat` à `cat`

---
