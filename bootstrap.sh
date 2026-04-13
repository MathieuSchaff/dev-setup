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

blue "[1/9] Base system packages (apt)"
if [[ "$DRYRUN" == "1" ]]; then
    dry "apt update && apt upgrade + install zsh curl git build-essential tmux ripgrep fd-find zoxide tree neofetch xclip sqlite3 postgresql-client python3 python3-pip python3-dev libssl-dev cmake wget unzip"
else
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y \
        zsh curl git build-essential tmux \
        ripgrep fd-find zoxide tree neofetch \
        xclip sqlite3 postgresql-client \
        python3 python3-pip python3-dev \
        libssl-dev cmake wget unzip
    green "  done"
fi

# ── 2. Oh My Zsh + plugins ──────────────────────────────────────────────────

blue "[2/9] Zsh + Oh My Zsh + plugins"

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

blue "[3/9] Rust + cargo tools"

if ! installed rustc; then
    if [[ "$DRYRUN" == "1" ]]; then dry "install Rust via rustup"; else
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
    green "  Rust installed"; fi
else
    source "$HOME/.cargo/env" 2>/dev/null || true
    echo "  Rust already installed ($(rustc --version))"
fi

CARGO_TOOLS="bat delta eza tree-sitter-cli navi starship cargo-update"
for tool in $CARGO_TOOLS; do
    bin="$tool"
    # Mapping between tool/crate name and binary name
    [[ "$tool" == "tree-sitter-cli" ]] && bin="tree-sitter"
    [[ "$tool" == "cargo-update" ]] && bin="cargo-install-update"

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

blue "[4/9] Glow (markdown reader)"

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

blue "[5/9] Node (nvm) + Bun"

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

blue "[6/9] fzf"

if [ ! -d "$HOME/.fzf" ]; then
    if [[ "$DRYRUN" == "1" ]]; then dry "clone + install fzf"; else
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
    "$HOME/.fzf/install" --all --no-update-rc
    green "  fzf installed"; fi
else
    echo "  fzf already installed"
fi

# ── 7. Lazygit & Lazydocker ────────────────────────────────────────────────

blue "[7/9] Lazygit & Lazydocker"

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

blue "[8/9] Neovim, Dive, Ctop"

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

blue "[9/9] Tmux TPM"

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    if [[ "$DRYRUN" == "1" ]]; then dry "clone TPM (tmux plugin manager)"; else
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    green "  TPM installed"
    yellow "  -> Launch tmux and press Ctrl+b + I to install plugins"; fi
else
    echo "  TPM already installed"
fi

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
echo "  2. exec zsh to reload your shell"
echo "  3. In tmux: Ctrl+b + I to install tmux plugins"
echo "  4. Generate SSH key: ssh-keygen -t ed25519"
