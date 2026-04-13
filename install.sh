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

green()  { echo -ne "\033[32m$*\033[0m"; }
yellow() { echo -ne "\033[33m$*\033[0m"; }
blue()   { echo -ne "\033[34m$*\033[0m"; }

backup_and_link() {
    local src="$1"
    local dest="$2"

    # Create destination directory if needed
    mkdir -p "$(dirname "$dest")"

    # If destination is already a symlink pointing to the right place, skip
    if [ -L "$dest" ] && [ "$(readlink -f "$dest")" == "$(readlink -f "$src")" ]; then
        echo "  link ok    $dest"
        return
    fi

    # Backup if destination already exists (and is NOT a symlink to the right place)
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        mkdir -p "$BACKUP_DIR"
        cp -r "$dest" "$BACKUP_DIR/$(basename "$dest")"
        rm -rf "$dest"
        yellow "  backed up  " ; echo "$dest  →  $BACKUP_DIR/$(basename "$dest")"
    fi

    ln -sf "$src" "$dest"
    green "  linked     " ; echo "$src  →  $dest"
    CHANGED=$((CHANGED + 1))
}

backup_and_copy() {
    local src="$1"
    local dest="$2"

    # Create destination directory if needed
    mkdir -p "$(dirname "$dest")"

    # Backup if destination already exists
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        mkdir -p "$BACKUP_DIR"
        cp -r "$dest" "$BACKUP_DIR/$(basename "$dest")"
        rm -rf "$dest"
        yellow "  backed up  " ; echo "$dest  →  $BACKUP_DIR/$(basename "$dest")"
    fi

    cp "$src" "$dest"
    green "  copied     " ; echo "$src  →  $dest"
    CHANGED=$((CHANGED + 1))
}

# ── Files ─────────────────────────────────────────────────────────────────────

blue "\n=== Deploying dotfiles (symlinks) from $DOTFILES_DIR ===\n\n"

CFG="$DOTFILES_DIR/config"

# Dotfiles de base
backup_and_link "$CFG/.zshrc"                       "$HOME/.zshrc"
backup_and_link "$CFG/.bashrc"                      "$HOME/.bashrc"
backup_and_link "$CFG/.gitconfig"                   "$HOME/.gitconfig"
backup_and_link "$CFG/.tmux.conf"                   "$HOME/.tmux.conf"
backup_and_link "$CFG/.vimrc"                       "$HOME/.vimrc"
backup_and_link "$CFG/.dive.yaml"                    "$HOME/.dive.yaml"

# Configs XDG
backup_and_link "$CFG/.config/lazygit"             "$HOME/.config/lazygit"
backup_and_link "$CFG/.config/nvim"                "$HOME/.config/nvim"
backup_and_link "$CFG/.config/bat"                 "$HOME/.config/bat"
backup_and_link "$CFG/.config/eza"                 "$HOME/.config/eza"
backup_and_link "$CFG/.config/navi"                "$HOME/.config/navi"
backup_and_link "$CFG/.config/glow"                "$HOME/.config/glow"
backup_and_link "$CFG/.config/starship.toml"       "$HOME/.config/starship.toml"

# ── Local / Secrets ───────────────────────────────────────────────────────────
# Création automatique de fichiers locaux vides s'ils n'existent pas.
# Ces fichiers sont sourcés dans vos configs mais IGNORÉS par git.

if [ ! -f "$HOME/.zshrc.local" ]; then
    touch "$HOME/.zshrc.local"
    blue "  created    $HOME/.zshrc.local (place your secrets here)\n"
fi

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
    backup_and_copy "$CFG/.config/zed/settings.json" "$ZED_WIN_DIR/settings.json"
    backup_and_copy "$CFG/.config/zed/keymap.json"   "$ZED_WIN_DIR/keymap.json"
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
