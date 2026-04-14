#!/usr/bin/env bash
# Install all tools and runtimes on a fresh Ubuntu/Debian machine.
# Idempotent — skips anything already installed.
#
# Usage:
#   ./bootstrap.sh              # install everything (interactive prompts for optional tools)
#   ./bootstrap.sh --all        # install everything including optional tools, no prompts
#   ./bootstrap.sh --dry-run    # preview what would be installed (no changes)

set -euo pipefail

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

ARCH=$(uname -m)
case "$ARCH" in
    x86_64)  ARCH_ALT="amd64"; ARCH_GH="x86_64" ;;
    aarch64) ARCH_ALT="arm64"; ARCH_GH="arm64"   ;;
    *)       printf "\033[31m%s\033[0m\n" "Architecture non supportée : $ARCH"; exit 1 ;;
esac

# ── Helpers ──────────────────────────────────────────────────────────────────

green()  { printf "\033[32m%s\033[0m\n" "$*"; }
yellow() { printf "\033[33m%s\033[0m\n" "$*"; }
blue()   { printf "\033[34m%s\033[0m\n" "$*"; }
red()    { printf "\033[31m%s\033[0m\n" "$*"; }

installed() { command -v "$1" &>/dev/null; }

dry() { yellow "  [dry-run] would: $*"; }

ask() {
    if [[ "${DRYRUN:-}" == "1" ]]; then return 0; fi
    if [[ "${AUTO:-}" == "1" ]]; then return 0; fi
    read -rp "$1 [Y/n] " answer
    [[ -z "$answer" || "$answer" =~ ^[Yy] ]]
}

# ── Flags ────────────────────────────────────────────────────────────────────

AUTO=0
DRYRUN=0
for arg in "$@"; do
    case "$arg" in
        --all)     AUTO=1 ;;
        --dry-run) DRYRUN=1 ;;
    esac
done

# ── Checks ───────────────────────────────────────────────────────────────────

if [[ "$DRYRUN" == "1" ]]; then
    blue "=== Bootstrap — DRY RUN (no changes will be made) ==="
else
    blue "=== Bootstrap — installing tools ==="
fi
echo ""

if ! command -v apt &>/dev/null; then
    red "Ce script nécessite apt (Ubuntu/Debian). OS détecté : $(uname -s) $(uname -m)"
    exit 1
fi

if [[ "$DRYRUN" != "1" ]] && ! curl -s https://github.com > /dev/null 2>&1; then
    red "No internet connection. Aborting."; exit 1
fi

# ── 1. Base system packages ─────────────────────────────────────────────────

blue "[1/10] Base system packages (apt)"
if [[ "$DRYRUN" == "1" ]]; then
    dry "apt update && apt upgrade + install zsh curl git build-essential tmux ripgrep fd-find zoxide tree neofetch xclip sqlite3 postgresql-client python3 python3-pip python3-dev python3-venv libssl-dev libsqlite3-dev libicu-dev clang libclang-dev cmake ninja-build pkg-config wget unzip ffmpeg xvfb"
else
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y \
        zsh curl git build-essential tmux \
        ripgrep fd-find zoxide tree neofetch \
        xclip sqlite3 postgresql-client \
        python3 python3-pip python3-dev python3-venv \
        libssl-dev libsqlite3-dev libicu-dev \
        clang libclang-dev \
        cmake ninja-build pkg-config wget unzip \
        ffmpeg xvfb
    green "  done"
fi

# ── 1b. GitHub CLI (gh) ──────────────────────────────────────────────────────

if ! installed gh; then
    if [[ "$DRYRUN" == "1" ]]; then dry "install GitHub CLI (official repository)"; else
    (type -p wget >/dev/null || (sudo apt update && sudo apt install wget -y)) \
    && sudo mkdir -p -m 755 /etc/apt/keyrings \
    && wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
    && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && sudo apt update \
    && sudo apt install gh -y
    green "  gh installed"; fi
else
    echo "  gh already installed"
fi

# ── 2. Oh My Zsh + plugins ──────────────────────────────────────────────────

blue "[2/10] Zsh + Oh My Zsh + plugins"

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    if [[ "$DRYRUN" == "1" ]]; then dry "install Oh My Zsh"; else
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    green "  Oh My Zsh installed"; fi
else
    echo "  Oh My Zsh already installed"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
declare -A ZSH_PLUGINS=(
    [zsh-autosuggestions]="https://github.com/zsh-users/zsh-autosuggestions"
    [zsh-syntax-highlighting]="https://github.com/zsh-users/zsh-syntax-highlighting"
    [zsh-history-substring-search]="https://github.com/zsh-users/zsh-history-substring-search"
    [fzf-tab]="https://github.com/Aloxaf/fzf-tab"
)

for plugin in "${!ZSH_PLUGINS[@]}"; do
    if [ ! -d "$ZSH_CUSTOM/plugins/$plugin" ]; then
        if [[ "$DRYRUN" == "1" ]]; then dry "clone $plugin"; else
        git clone "${ZSH_PLUGINS[$plugin]}" "$ZSH_CUSTOM/plugins/$plugin"
        green "  $plugin cloned"; fi
    else
        echo "  $plugin already installed"
    fi
done

# Set zsh as default shell
if [[ "$SHELL" != *"zsh"* ]]; then
    if [[ "$DRYRUN" == "1" ]]; then dry "chsh to zsh"; else
    chsh -s "$(which zsh)"
    green "  default shell changed to zsh"; fi
fi

# ── 3. Rust + cargo tools ───────────────────────────────────────────────────

blue "[3/10] Rust + cargo tools"

if ! installed rustc; then
    if [[ "$DRYRUN" == "1" ]]; then dry "install Rust via rustup"; else
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
    green "  Rust installed"; fi
else
    source "$HOME/.cargo/env" 2>/dev/null || true
    echo "  Rust already installed ($(rustc --version))"
fi

CARGO_TOOLS="bat delta eza tree-sitter-cli navi starship cargo-update tealdeer bottom"
for tool in $CARGO_TOOLS; do
    bin="$tool"
    # Mapping between tool/crate name and binary name
    [[ "$tool" == "tree-sitter-cli" ]] && bin="tree-sitter"
    [[ "$tool" == "cargo-update" ]] && bin="cargo-install-update"
    [[ "$tool" == "tealdeer" ]] && bin="tldr"
    [[ "$tool" == "bottom" ]] && bin="btm"

    if ! installed "$bin"; then
        crate="$tool"
        [[ "$tool" == "delta" ]] && crate="git-delta"
        if [[ "$DRYRUN" == "1" ]]; then dry "cargo install $crate"; else
        cargo install "$crate"
        green "  $tool installed"; fi
    else
        echo "  $tool already installed"
    fi
done

# ── 4. Glow ──────────────────────────────────────────────────────────────────

blue "[4/10] Glow (markdown reader)"

# Note: snap doesn't work in WSL2 — prefer go install
if ! installed glow; then
    if [[ "$DRYRUN" == "1" ]]; then dry "install glow (go install or snap)"; else
    if installed go; then
        go install github.com/charmbracelet/glow@latest
    elif installed snap; then
        sudo snap install glow
    else
        yellow "  skipped — install go or snap first, then: go install github.com/charmbracelet/glow@latest"
    fi; fi
else
    echo "  glow already installed"
fi

# ── 5. Node (nvm) + Bun ─────────────────────────────────────────────────────

blue "[5/10] Node (nvm) + Bun"

export NVM_DIR="$HOME/.nvm"
if [ ! -d "$NVM_DIR" ]; then
    if [[ "$DRYRUN" == "1" ]]; then dry "install nvm"; else
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
    green "  nvm installed"; fi
else
    echo "  nvm already installed"
fi

# Load nvm for this script
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"

if ! installed node; then
    if [[ "$DRYRUN" == "1" ]]; then dry "nvm install node"; else
    nvm install node
    nvm alias default node
    green "  Node installed ($(node --version))"; fi
else
    echo "  Node already installed ($(node --version))"
fi

if ! installed bun; then
    if [[ "$DRYRUN" == "1" ]]; then dry "install Bun"; else
    curl -fsSL https://bun.sh/install | bash
    green "  Bun installed"; fi
else
    echo "  Bun already installed ($(bun --version))"
fi

if ! installed pnpm; then
    if [[ "$DRYRUN" == "1" ]]; then dry "npm install -g pnpm"; else
    npm install -g pnpm
    green "  pnpm installed"; fi
else
    echo "  pnpm already installed"
fi

# ── 6. fzf ───────────────────────────────────────────────────────────────────

blue "[6/10] fzf"

if [ ! -d "$HOME/.fzf" ]; then
    if [[ "$DRYRUN" == "1" ]]; then dry "clone + install fzf"; else
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
    "$HOME/.fzf/install" --all --no-update-rc
    green "  fzf installed"; fi
else
    echo "  fzf already installed"
fi

# ── 7. Lazygit & Lazydocker ────────────────────────────────────────────────

blue "[7/10] Lazygit & Lazydocker"

if ! installed lazygit; then
    if [[ "$DRYRUN" == "1" ]]; then dry "install lazygit (GitHub release)"; else
    LAZYGIT_VERSION=$(curl -s --max-time 30 "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" \
        | grep -Po '"tag_name": "v\K[^"]*')
    curl --max-time 60 -Lo "$TMP/lazygit.tar.gz" \
        "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_${ARCH_GH}.tar.gz"
    tar xf "$TMP/lazygit.tar.gz" -C "$TMP" lazygit
    sudo install "$TMP/lazygit" /usr/local/bin
    green "  lazygit installed ($LAZYGIT_VERSION)"; fi
else
    echo "  lazygit already installed"
fi

if ! installed lazydocker; then
    if [[ "$DRYRUN" == "1" ]]; then dry "install lazydocker (official script)"; else
    curl -fsSL https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
    green "  lazydocker installed"; fi
else
    echo "  lazydocker already installed"
fi

# ── 8. Neovim & Other tools ──────────────────────────────────────────────────

blue "[8/10] Neovim, Dive, Ctop"

if ! installed nvim; then
    if [[ "$DRYRUN" == "1" ]]; then dry "install Neovim (GitHub release → /opt/)"; else
    curl --max-time 60 -Lo "$TMP/nvim-linux-${ARCH_GH}.tar.gz" "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${ARCH_GH}.tar.gz"
    sudo rm -rf /opt/nvim
    sudo mkdir -p /opt/nvim
    sudo tar -C /opt/nvim --strip-components=1 -xzf "$TMP/nvim-linux-${ARCH_GH}.tar.gz"
    green "  Neovim installed ($(/opt/nvim/bin/nvim --version | head -1))"; fi
else
    echo "  Neovim already installed ($(nvim --version | head -1))"
fi

if ! installed dive; then
    if [[ "$DRYRUN" == "1" ]]; then dry "install dive (GitHub .deb)"; else
    DIVE_VERSION=$(curl -s --max-time 30 "https://api.github.com/repos/wagoodman/dive/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl --max-time 60 -Lo "$TMP/dive.deb" "https://github.com/wagoodman/dive/releases/download/v${DIVE_VERSION}/dive_${DIVE_VERSION}_linux_${ARCH_ALT}.deb"
    sudo apt install -y "$TMP/dive.deb"
    green "  dive installed ($DIVE_VERSION)"; fi
else
    echo "  dive already installed"
fi

if ! installed ctop; then
    if [[ "$DRYRUN" == "1" ]]; then dry "install ctop (GitHub binary)"; else
    CTOP_VERSION=$(curl -s --max-time 30 "https://api.github.com/repos/bcicen/ctop/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    sudo curl --max-time 60 -fsSLo /usr/local/bin/ctop "https://github.com/bcicen/ctop/releases/download/v${CTOP_VERSION}/ctop-${CTOP_VERSION}-linux-${ARCH_ALT}"
    sudo chmod +x /usr/local/bin/ctop
    green "  ctop installed ($CTOP_VERSION)"; fi
else
    echo "  ctop already installed"
fi

# ── 9. Tmux TPM ─────────────────────────────────────────────────────────────

blue "[9/10] Tmux TPM"

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    if [[ "$DRYRUN" == "1" ]]; then dry "clone TPM (tmux plugin manager)"; else
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    green "  TPM installed"
    yellow "  -> Launch tmux and press Ctrl+b + I to install plugins"; fi
else
    echo "  TPM already installed"
fi

# ── 10. Zsh completions ─────────────────────────────────────────────────────
# Génère les complétions zsh manquantes dans ~/.oh-my-zsh/custom/completions/
# (déjà dans le fpath par défaut d'oh-my-zsh, compinit les charge au prochain shell).
# Chaque complétion est skippée si le binaire source n'est pas installé, ou si
# le fichier est déjà présent → idempotent.

blue "[10/10] Zsh completions"

COMPDIR="$HOME/.oh-my-zsh/custom/completions"
mkdir -p "$COMPDIR"

gen_completion() {
    # $1: nom de la complétion (fichier _<nom>), $2: binaire à vérifier, $3: commande
    local name="$1" bin="$2" cmd="$3"
    local target="$COMPDIR/_$name"
    if [ -s "$target" ]; then echo "  _$name already present"; return; fi
    if ! installed "$bin"; then yellow "  skipped _$name ($bin not installed)"; return; fi
    if [[ "$DRYRUN" == "1" ]]; then dry "$cmd > $target"; return; fi
    eval "$cmd" > "$target"
    green "  _$name generated"
}

dl_completion() {
    # $1: nom, $2: binaire à vérifier, $3: URL upstream
    local name="$1" bin="$2" url="$3"
    local target="$COMPDIR/_$name"
    if [ -s "$target" ]; then echo "  _$name already present"; return; fi
    if ! installed "$bin"; then yellow "  skipped _$name ($bin not installed)"; return; fi
    if [[ "$DRYRUN" == "1" ]]; then dry "curl -fsSL $url -o $target"; return; fi
    curl -fsSL "$url" -o "$target"
    green "  _$name downloaded"
}

# Auto-générées par le binaire source
gen_completion rustup   rustup   "rustup completions zsh"
gen_completion cargo    rustup   "rustup completions zsh cargo"
gen_completion gh       gh       "gh completion -s zsh"
gen_completion starship starship "starship completions zsh"
gen_completion glow     glow     "glow completion zsh"
gen_completion pnpm     pnpm     "pnpm completion zsh"

# Téléchargées depuis le repo upstream (pas de sous-commande `completions`)
dl_completion eza   eza   "https://raw.githubusercontent.com/eza-community/eza/main/completions/zsh/_eza"
dl_completion delta delta "https://raw.githubusercontent.com/dandavison/delta/main/etc/completion/completion.zsh"

# bun — cas spécial : dumpe dans ~/.bun/_bun, sourcé directement par .zshrc (pas via fpath)
if installed bun; then
    if [ ! -s "$HOME/.bun/_bun" ]; then
        if [[ "$DRYRUN" == "1" ]]; then dry "bun completions"
        else
            bun completions >/dev/null 2>&1 || true
            green "  _bun installed (~/.bun/_bun)"
        fi
    else
        echo "  _bun already present (~/.bun/_bun)"
    fi
else
    yellow "  skipped _bun (bun not installed)"
fi

# bat : upstream ne publie pas de complétion zsh (seulement bash/fish/powershell).
# La version apt de bat dépose _bat dans /usr/share/zsh/vendor-completions/. Ici
# bat vient de cargo, donc pas de _bat. À écrire à la main ou installer la version
# apt en parallèle si besoin.

# ── Optional tools ───────────────────────────────────────────────────────────

echo ""
blue "=== Optional tools ==="

# Go
if ! installed go; then
    if ask "Install Go?"; then
        if [[ "$DRYRUN" == "1" ]]; then dry "install Go (latest from go.dev)"; else
        GO_VERSION=$(curl -fsSL --max-time 30 "https://go.dev/VERSION?m=text" | head -1 | sed 's/^go//')
        wget -q "https://go.dev/dl/go${GO_VERSION}.linux-${ARCH_ALT}.tar.gz" -O "$TMP/go.tar.gz"
        sudo rm -rf /usr/local/go
        sudo tar -C /usr/local -xzf "$TMP/go.tar.gz"
        green "  Go $GO_VERSION installed"; fi
    fi
else
    echo "  Go already installed ($(go version))"
fi

# uv
if ! installed uv; then
    if ask "Install uv (Python package manager)?"; then
        if [[ "$DRYRUN" == "1" ]]; then dry "install uv (astral.sh)"; else
        curl -LsSf https://astral.sh/uv/install.sh | sh
        green "  uv installed"; fi
    fi
else
    echo "  uv already installed"
fi

# Miniconda
if [ ! -d "$HOME/miniconda3" ]; then
    if ask "Install Miniconda?"; then
        if [[ "$DRYRUN" == "1" ]]; then dry "install Miniconda → ~/miniconda3/"; else
        wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-${ARCH}.sh -O "$TMP/miniconda.sh"
        bash "$TMP/miniconda.sh" -b -p "$HOME/miniconda3"
        green "  Miniconda installed"; fi
    fi
else
    echo "  Miniconda already installed"
fi

# ── Summary ──────────────────────────────────────────────────────────────────

echo ""
green "=== Bootstrap complete ==="
echo ""
echo "Next steps:"
echo "  1. Run ./install.sh to deploy configs (symlinks)"
echo "  2. exec zsh to reload your shell (picks up new custom completions)"
echo "  3. In tmux: Ctrl+b + I to install tmux plugins"
echo "  4. Generate SSH key: ssh-keygen -t ed25519"
echo "  5. On KDE/Plasma: ./bootstrap-kde.sh for ssh-agent+KWallet+ksshaskpass+Konsole"
