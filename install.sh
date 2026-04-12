#!/usr/bin/env bash
# Deploy dotfiles from ~/dev-setup to the right locations.
# Creates timestamped backups of any existing files before overwriting.
#
# Requirements: bash, cp, diff, mkdir, date — standard on any Unix system.
# No need for cargo, node, rust or any other tool.

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"
CHANGED=0

# ── Helpers ──────────────────────────────────────────────────────────────────

green()  { echo -e "\033[32m$*\033[0m"; }
yellow() { echo -e "\033[33m$*\033[0m"; }
blue()   { echo -e "\033[34m$*\033[0m"; }

backup_and_copy() {
    local src="$1"
    local dest="$2"

    # Create destination directory if needed
    mkdir -p "$(dirname "$dest")"

    # Recursive diff for directories, simple diff for files.
    # Exclude runtime junk (logs, lockfiles) so install stays idempotent.
    local diff_opts="-q"
    [ -d "$src" ] && diff_opts="-rq --exclude=*.log"

    # Backup if destination already exists and differs
    if [ -e "$dest" ]; then
        if diff $diff_opts "$src" "$dest" > /dev/null 2>&1; then
            echo "  unchanged  $dest"
            return
        fi
        mkdir -p "$BACKUP_DIR"
        cp -r "$dest" "$BACKUP_DIR/$(basename "$dest")"
        yellow "  backed up  $dest  →  $BACKUP_DIR/$(basename "$dest")"
    fi

    # -T prevents nesting when dest already exists as a directory
    # (without -T, `cp -r src dst/` creates dst/src-basename/)
    if [ -d "$src" ]; then
        mkdir -p "$dest"
        cp -rT "$src" "$dest"
    else
        cp "$src" "$dest"
    fi
    green "  copied     $src  →  $dest"
    CHANGED=$((CHANGED + 1))
}

# ── Files ─────────────────────────────────────────────────────────────────────

blue "\n=== Deploying dotfiles from $DOTFILES_DIR ===\n"

backup_and_copy "$DOTFILES_DIR/CLAUDE.md"           "$HOME/CLAUDE.md"
backup_and_copy "$DOTFILES_DIR/.zshrc"              "$HOME/.zshrc"
backup_and_copy "$DOTFILES_DIR/.bashrc"             "$HOME/.bashrc"
backup_and_copy "$DOTFILES_DIR/.gitconfig"          "$HOME/.gitconfig"
backup_and_copy "$DOTFILES_DIR/.tmux.conf"          "$HOME/.tmux.conf"
backup_and_copy "$DOTFILES_DIR/.vimrc"              "$HOME/.vimrc"
backup_and_copy "$DOTFILES_DIR/.config/lazygit/config.yml" "$HOME/.config/lazygit/config.yml"
backup_and_copy "$DOTFILES_DIR/.config/nvim"        "$HOME/.config/nvim"
backup_and_copy "$DOTFILES_DIR/.config/bat"         "$HOME/.config/bat"
backup_and_copy "$DOTFILES_DIR/.config/eza"         "$HOME/.config/eza"
backup_and_copy "$DOTFILES_DIR/.config/navi"        "$HOME/.config/navi"
backup_and_copy "$DOTFILES_DIR/.config/glow"        "$HOME/.config/glow"
[ -f "$DOTFILES_DIR/.config/starship.toml" ] && \
backup_and_copy "$DOTFILES_DIR/.config/starship.toml" "$HOME/.config/starship.toml"

# ── Zed (WSL only — config lives on Windows side) ────────────────────────────
# Auto-detect the Windows Zed directory by scanning /mnt/c/Users/*/AppData/Roaming/Zed.
# On pure Linux or a WSL machine without Zed installed, this section is skipped.

ZED_WIN_DIR=""
for candidate in /mnt/c/Users/*/AppData/Roaming/Zed; do
    if [ -d "$candidate" ]; then
        ZED_WIN_DIR="$candidate"
        break
    fi
done

if [ -n "$ZED_WIN_DIR" ]; then
    blue "  → Zed detected at $ZED_WIN_DIR"
    backup_and_copy "$DOTFILES_DIR/.config/zed/settings.json" "$ZED_WIN_DIR/settings.json"
    backup_and_copy "$DOTFILES_DIR/.config/zed/keymap.json"   "$ZED_WIN_DIR/keymap.json"
else
    yellow "  skipped    Zed (no Windows Zed install found under /mnt/c/Users/*/AppData/Roaming/Zed)"
fi

# ── Summary ───────────────────────────────────────────────────────────────────

echo ""
if [ "$CHANGED" -eq 0 ]; then
    green "Everything is already up to date."
else
    green "$CHANGED file(s) updated."
    if [ -d "$BACKUP_DIR" ]; then
        yellow "Backups saved in $BACKUP_DIR"
    fi
    echo ""
    blue "Reload your shell:  exec zsh"
fi
