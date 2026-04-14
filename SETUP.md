# Setup — Nouvelle machine

Séquence complète pour reproduire l'environnement sur Linux (Ubuntu/Debian) ou macOS.

> **Environnement actuel :** WSL2 (Ubuntu 22.04) sur Windows — mais le setup fonctionne sur n'importe quel Linux Debian-based ou macOS avec adaptations mineures.

---

## Prérequis

Avant de commencer, vérifie que ces éléments sont en place.

### OS supportés

| OS | Support | Notes |
|----|:-------:|-------|
| Ubuntu / Debian (natif ou WSL2) | ✅ | Référence — commandes telles quelles |
| Autres distros Linux | ⚠️ | Remplacer `apt` par `pacman`, `dnf`, etc. |
| macOS | ⚠️ | Remplacer `apt` par `brew`, quelques chemins différents |
| Windows natif | ❌ | Non supporté |

```bash
lsb_release -a    # vérifier la distro Linux
uname -m          # doit afficher x86_64
```

**WSL2 uniquement** — si tu pars de Windows :
```powershell
# Dans PowerShell admin
wsl --install
wsl --set-default-version 2
```

---

### Git

Git doit être disponible pour cloner `dev-setup`. Il est généralement préinstallé sur Ubuntu.

```bash
git --version          # vérifier
sudo apt install git   # installer si absent
```

---

### Connexion internet

Toutes les étapes nécessitent internet (`apt`, `curl`, `git clone`...).  
Vérifie avant de commencer :
```bash
curl -s https://github.com > /dev/null && echo "OK" || echo "Pas de connexion"
```

---

### Droits sudo

Plusieurs étapes nécessitent `sudo`. Vérifie que ton utilisateur est dans le groupe sudo :
```bash
sudo echo "OK"         # doit afficher OK sans erreur
```

---

## Table des matières

1. [Base système](#1-base-système)
2. [Zsh + Oh My Zsh + plugins](#2-zsh--oh-my-zsh--plugins)
3. [Rust + outils cargo](#3-rust--outils-cargo)
4. [Node (nvm) + Bun](#4-node-nvm--bun)
5. [fzf](#5-fzf)
6. [Lazygit](#6-lazygit)
7. [Neovim](#7-neovim)
8. [Cloner dev-setup et copier les configs](#8-cloner-dev-setup-et-copier-les-configs)
9. [Tmux + TPM](#9-tmux--tpm)
10. [SSH pour GitHub](#10-ssh-pour-github)
11. [Outils optionnels](#11-outils-optionnels)
12. [Complétions zsh avancées](#12-complétions-zsh-avancées)
13. [KDE / Tuxedo OS — intégration système](#13-kde--tuxedo-os--intégration-système)
14. [Checklist finale](#14-checklist-finale)

---

## 1. Base système

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y \
  zsh curl git build-essential tmux \
  ripgrep fd-find zoxide tree neofetch \
  xclip sqlite3 postgresql-client \
  python3 python3-pip python3-dev \
  libssl-dev cmake wget unzip \
  clang libclang-dev
```

---

## 2. Zsh + Oh My Zsh + plugins

```bash
# Installer Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

> ⚠️ **L'installeur Oh My Zsh ouvre automatiquement un nouveau shell zsh à la fin.**  
> Tape `exit` pour revenir à ton shell bash, puis continue les commandes ci-dessous.

```bash
# Plugins custom (cloner dans ~/.oh-my-zsh/custom/plugins/)
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

git clone https://github.com/zsh-users/zsh-history-substring-search \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search

git clone https://github.com/Aloxaf/fzf-tab \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab

# Changer le shell par défaut
chsh -s $(which zsh)
```

> Les plugins sont activés via `~/.zshrc` (copié à l'étape 8).

---

## 3. Rust + outils cargo

```bash
# Installer Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env

# Outils CLI installés via cargo
cargo install bat git-delta eza tree-sitter-cli navi starship
```

| Outil | Commande | Description |
|-------|----------|-------------|
| bat | `cat` (alias) | cat avec syntax highlighting |
| delta | `delta` | diff amélioré pour git |
| eza | `l`, `ll`, `tree` (alias) | ls moderne |
| tree-sitter | `tree-sitter` | parser (utilisé par neovim) |
| navi | `navi`, `Ctrl+N` | cheatsheet interactif — `~/dev-setup/cheats/` |
| starship | `starship` | prompt cross-shell — config `~/.config/starship.toml` |

### Glow — lecteur markdown (`cs`, `gl`, `cheat`)

`glow` n'est pas sur cargo. Installer via snap (le plus simple) ou Go :

```bash
# Option 1 — snap (recommandé)
sudo snap install glow

# Option 2 — via Go (si tu as Go installé)
go install github.com/charmbracelet/glow@latest
```

Utilisé par les alias `cs` (TUI sur `~/dev-setup/cheatsheet/`), `gl` (pager), `cheat` (fzf + preview).

---

## 4. Node (nvm) + Bun

```bash
# nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
```

> ⚠️ **`exec zsh` redémarre le shell** — les commandes suivantes doivent être tapées dans le nouveau shell.

```bash
exec zsh
nvm install node
nvm alias default node

# Bun
curl -fsSL https://bun.sh/install | bash

# pnpm (optionnel)
npm install -g pnpm
```

---

## 5. fzf

```bash
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all
```

> `--all` active les keybindings (`Ctrl+R`, `Ctrl+T`, `Alt+C`) et la complétion automatiquement.

---

## 6. Lazygit

```bash
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" \
  | grep -Po '"tag_name": "v\K[^"]*') \
  && curl -Lo /tmp/lazygit.tar.gz \
  "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" \
  && tar xf /tmp/lazygit.tar.gz -C /tmp lazygit \
  && sudo install /tmp/lazygit /usr/local/bin
```

---

## 7. Neovim

```bash
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo mkdir -p /opt/nvim
sudo tar -C /opt/nvim --strip-components=1 -xzf nvim-linux-x86_64.tar.gz
rm nvim-linux-x86_64.tar.gz

# Vérifier
/opt/nvim/bin/nvim --version
```

> Le PATH `/opt/nvim/bin` est dans le `.zshrc` — il sera actif après `exec zsh` à l'étape 8.  
> La config nvim est copiée à l'étape suivante depuis `~/dev-setup/config/.config/nvim/`.

---

## 8. Cloner dev-setup et déployer les configs

C'est l'étape centrale — elle applique tous les fichiers de configuration.

```bash
# Cloner le repo de dotfiles
# HTTPS ici car SSH n'est pas encore configuré (clés générées à l'étape 10)
git clone https://github.com/MathieuSchaff/dev-setup ~/dev-setup

# Rendre les scripts exécutables
chmod +x ~/dev-setup/setup.sh ~/dev-setup/bootstrap.sh ~/dev-setup/install.sh

# Déployer les configs (symlinks)
~/dev-setup/install.sh

# Recharger le shell
exec zsh
```

> **Note :** si tu pars d'une machine vierge, `./setup.sh` fait tout (outils + configs).
> Les étapes 1 à 7 ci-dessus sont déjà couvertes par `./bootstrap.sh`.

Le script `install.sh` :
- Crée des **symlinks** de chaque dotfile vers le repo (`~/.zshrc → ~/dev-setup/config/.zshrc`, etc.)
- Si un fichier existe déjà, il est sauvegardé dans `~/.dotfiles-backup/<timestamp>/` avant remplacement par le symlink
- Si le symlink est déjà en place, il est ignoré ("link ok")
- Copie les configs Zed vers Windows (symlinks non supportés sur `/mnt/c/`)
- Affiche un résumé de ce qui a changé

### Ce que ça configure automatiquement

| Fichier | Effet |
|---------|-------|
| `~/.gitconfig` | delta comme pager, side-by-side, navigate, nvim comme éditeur |
| `~/.config/lazygit/config.yml` | delta dans lazygit (`--paging=never`), nvim comme éditeur |
| `~/.zshrc` | tous les alias, fonction `lg` smart exit, `t` tmux, `update-all`... |
| `~/.tmux.conf` | Catppuccin macchiato, `Ctrl+g` popup lazygit, vi copy mode |

---

## 9. Tmux + TPM

```bash
# Installer TPM (gestionnaire de plugins tmux)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Lancer tmux, puis installer les plugins
tmux
# Dans tmux : Ctrl+b + I
```

Plugins installés : `catppuccin/tmux#v2.3.0` (pinné — l'API v2 est incompatible avec v0.3/v1, voir [cheatsheet/tmux.md](./cheatsheet/tmux.md#thème-catppuccin-macchiato-api-v2)), `tmux-sensible`, `tmux-yank`.

---

## 10. SSH pour GitHub

```bash
# Générer une clé
ssh-keygen -t ed25519 -C "schaff.mathieu93@gmail.com"

# Afficher la clé publique (à coller dans GitHub → Settings → SSH keys)
cat ~/.ssh/id_ed25519.pub

# Vérifier la connexion
ssh -T git@github.com
```

---

## 11. Outils optionnels

```bash
# uv — gestionnaire Python moderne (remplace pip + venv)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Miniconda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh

# Go (télécharger la dernière version depuis go.dev)
GO_VERSION=$(curl -fsSL "https://go.dev/VERSION?m=text" | head -1)
wget "https://go.dev/dl/${GO_VERSION}.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "${GO_VERSION}.linux-amd64.tar.gz"
rm "${GO_VERSION}.linux-amd64.tar.gz"
# Ajouter au PATH : export PATH=$PATH:/usr/local/go/bin

# bottom (moniteur système)
sudo apt install bottom   # ou : cargo install bottom
```

---

## 12. Complétions zsh avancées

Une fois les outils installés (cargo, go, bun, pnpm…), certains ne déposent pas automatiquement leur complétion zsh dans `/usr/share/zsh/vendor-completions/` (c'est le cas dès qu'on installe hors apt — via `cargo install`, `curl | bash`, `go install`…). On génère les manquantes dans `~/.oh-my-zsh/custom/completions/` (déjà dans le fpath par défaut, `compinit` les charge au prochain shell).

### Auto-générées par le binaire

```bash
mkdir -p ~/.oh-my-zsh/custom/completions
cd ~/.oh-my-zsh/custom/completions

rustup completions zsh        > _rustup
rustup completions zsh cargo  > _cargo      # wrapper → $(rustc --print sysroot)/share/zsh/site-functions/_cargo
gh completion -s zsh          > _gh
starship completions zsh      > _starship
glow completion zsh           > _glow
pnpm completion zsh           > _pnpm
bun completions                              # dépose ~/.bun/_bun, déjà sourcé par .zshrc
```

### Téléchargées depuis le repo upstream (pas de sous-commande `completions`)

```bash
curl -fsSL https://raw.githubusercontent.com/eza-community/eza/main/completions/zsh/_eza \
  -o ~/.oh-my-zsh/custom/completions/_eza

curl -fsSL https://raw.githubusercontent.com/dandavison/delta/main/etc/completion/completion.zsh \
  -o ~/.oh-my-zsh/custom/completions/_delta
```

### Activation

Rien à ajouter dans `.zshrc` — le dossier `~/.oh-my-zsh/custom/completions/` est déjà dans le fpath. Ouvrir un nouveau shell suffit. Si une complétion ne prend pas : `rm ~/.zcompdump*` et relancer zsh.

### Non couvert par cette liste

- **`bat`** : le repo upstream (sharkdp/bat) ne publie pas de complétion zsh (seulement bash/fish/powershell). La version apt de bat dépose `_bat` dans `/usr/share/zsh/vendor-completions/`, à installer en parallèle si besoin.
- **`docker`** : sa complétion arrive automatiquement via le paquet apt `docker-ce-cli` si/quand docker est installé.

---

## 13. KDE / Tuxedo OS — intégration système

Section **spécifique à Tuxedo OS / KDE Plasma**. À ignorer sur WSL ou autre DE (GNOME, i3, etc.) — le setup diffère.

### 13.1 ssh-agent + KWallet + ksshaskpass (une seule saisie de passphrase)

**Objectif :** ne plus retaper la passphrase à chaque `git push`. Stockage dans KWallet, déverrouillé automatiquement via PAM au login KDE.

```bash
# 1. Installer le prompt KDE (si pas déjà présent)
sudo apt install -y ksshaskpass

# 2. Neutraliser gpg-agent en tant qu'agent SSH (Tuxedo OS l'active par défaut
#    via le preset global gpg-agent-ssh.socket)
systemctl --user mask gpg-agent-ssh.socket
```

Écrire `~/.config/systemd/user/ssh-agent.service` :

```ini
[Unit]
Description=SSH Agent
After=graphical-session-pre.target

[Service]
Type=simple
Environment=SSH_AUTH_SOCK=%t/ssh-agent.socket
ExecStart=/usr/bin/ssh-agent -D -a $SSH_AUTH_SOCK

[Install]
WantedBy=default.target
```

Écrire `~/.config/environment.d/10-ssh.conf` :

```
SSH_AUTH_SOCK=${XDG_RUNTIME_DIR}/ssh-agent.socket
SSH_ASKPASS=/usr/bin/ksshaskpass
SSH_ASKPASS_REQUIRE=prefer
```

Écrire `~/.config/autostart/ssh-add.desktop` (remplacer le chemin de la clé si besoin) :

```ini
[Desktop Entry]
Type=Application
Name=ssh-add
Comment=Load ssh key into the agent at KDE login
Exec=ssh-add /home/USER/.ssh/id_rsa
X-KDE-AutostartScript=true
OnlyShowIn=KDE;
Terminal=false
```

Activer :

```bash
systemctl --user daemon-reload
systemctl --user enable --now ssh-agent.service
```

**Puis logout/login KDE** (ou reboot). Au premier login, ksshaskpass affiche un prompt passphrase — **cocher "Mémoriser dans le portefeuille"**. Aux logins suivants : zéro prompt tant que KWallet reste déverrouillé (ce qui est le cas par défaut si le mot de passe KWallet = le mot de passe login Linux, configuré via PAM).

**Vérifications :**
```bash
echo $SSH_AUTH_SOCK   # doit pointer /run/user/<uid>/ssh-agent.socket
ssh-add -l            # doit lister la clé
ssh -T git@github.com # doit saluer sans prompt
```

**Si ça déconne :**
- Prompt à chaque login = KWallet pas déverrouillé automatiquement → System Settings → KDE Wallet → mot de passe Wallet = mot de passe login + activer déverrouillage PAM.
- Pas de fenêtre ksshaskpass = vérifier que l'autostart est actif (System Settings → Autostart) et `env | grep SSH`.

### 13.2 Konsole — profil zsh + Nerd Font

**Problème sur installation fraîche :** Konsole lance `bash` par défaut (même avec `chsh -s /usr/bin/zsh` appliqué, car la session KDE a souvent démarré avant `chsh` et hérite d'un `$SHELL` figé), et utilise une font non-Nerd (icônes eza/starship illisibles).

#### Fonts

```bash
# JetBrainsMono Nerd Font (recommandée pour Konsole)
mkdir -p ~/.local/share/fonts/JetBrainsMonoNF
cd ~/.local/share/fonts/JetBrainsMonoNF
curl -fsSL -o JetBrainsMono.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
unzip -o JetBrainsMono.zip && rm JetBrainsMono.zip

# Rebuild du cache fontconfig
fc-cache -fv
```

#### Profil Konsole

Écrire `~/.local/share/konsole/Zsh.profile` :

```ini
[Appearance]
ColorScheme=Breeze
Font=JetBrainsMono Nerd Font,12,-1,5,50,0,0,0,0,0

[General]
Command=/usr/bin/zsh
Name=Zsh
Parent=FALLBACK/
```

Dans `~/.config/konsolerc`, ajouter (ou éditer si section existe) :

```ini
[Desktop Entry]
DefaultProfile=Zsh.profile
```

Redémarrer Konsole → les nouveaux onglets lancent zsh directement (plus besoin de `exec zsh`), avec les icônes Nerd Font.

**Note sur `$SHELL` :** même après ça, `$SHELL` reste `/bin/bash` jusqu'au prochain logout/login KDE complet (variable figée par la session manager). Pour corriger immédiatement : `export SHELL=/usr/bin/zsh` dans le `.zshrc` (déjà présent dans `~/dev-setup/config/.zshrc`). Sinon `fzf` et autres outils spawneraient des sous-shells bash et ne chargeraient pas le `.zshrc` → cassure des alias/fonctions (`cs`, `lg`, etc.).

---

## 14. Checklist finale

- [ ] Linux (Ubuntu/Debian) ou macOS disponible
- [ ] Git disponible (`git --version`)
- [ ] Connexion internet OK
- [ ] Droits sudo OK
- [ ] `sudo apt update && apt upgrade`
- [ ] Zsh + Oh My Zsh installés
- [ ] Plugins custom zsh clonés (autosuggestions, syntax-highlighting, history-substring-search, fzf-tab)
- [ ] Rust + cargo installés (`bat`, `delta`, `eza`, `starship`)
- [ ] nvm + Node installés
- [ ] Bun installé
- [ ] fzf installé (`~/.fzf/`)
- [ ] Lazygit installé (`/usr/local/bin/lazygit`)
- [ ] Neovim installé
- [ ] `~/dev-setup/` cloné depuis GitHub
- [ ] `chmod +x ~/dev-setup/install.sh`
- [ ] `install.sh` exécuté — configs déployées (`.zshrc`, `.gitconfig`, `.tmux.conf`, lazygit, nvim)
- [ ] Shell rechargé (`exec zsh`)
- [ ] TPM installé + plugins tmux (`Ctrl+b + I`)
- [ ] Clé SSH générée et ajoutée à GitHub
- [ ] `lg` fonctionne (lazygit avec smart exit)
- [ ] `Ctrl+g` ouvre lazygit en popup tmux
- [ ] `git diff` utilise delta (côte-à-côte + syntax highlighting)
- [ ] Complétions zsh avancées générées (`gh <TAB>`, `cargo <TAB>`, `eza --<TAB>`, etc. — voir section 12)
- [ ] (Tuxedo OS / KDE uniquement) ssh-agent + KWallet : `git push` ne demande plus la passphrase (voir section 13.1)
- [ ] (Tuxedo OS / KDE uniquement) Konsole lance zsh directement + icônes Nerd Font lisibles (voir section 13.2)

---

## Mise à jour d'une installation existante

```bash
update-all   # apt, omz, plugins zsh, rust/cargo, uv, lazygit, fzf
```

Commandes séparées (risque de casser des projets) :
```bash
update-node    # Node via nvm
update-bun     # Bun
update-conda   # Conda
update-nvim    # Neovim
```
