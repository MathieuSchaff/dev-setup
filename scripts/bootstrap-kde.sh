#!/usr/bin/env bash
# KDE Plasma / Tuxedo OS — intégration système.
# À lancer APRÈS bootstrap.sh + install.sh. Idempotent.
#
# Ce que ça fait :
#   - installe ksshaskpass (prompt passphrase KDE intégré à KWallet)
#   - télécharge JetBrainsMono Nerd Font (si absente)
#   - déploie le profil Konsole "Zsh" (lance zsh + Nerd Font)
#   - configure konsolerc pour utiliser ce profil par défaut
#   - déploie un service systemd user `ssh-agent.service`
#   - déploie ~/.config/environment.d/10-ssh.conf (SSH_AUTH_SOCK + ksshaskpass)
#   - déploie ~/.config/autostart/ssh-add.desktop (charge les clés au login)
#   - masque gpg-agent-ssh.socket (Tuxedo OS fait de gpg-agent l'agent SSH par défaut)
#   - active ssh-agent.service
#   - crée ~/Mathieu/ (vault, projets, media, docs, tmp) + configure XDG user dirs
#
# Usage :
#   ./bootstrap-kde.sh              # installe tout
#   ./bootstrap-kde.sh --dry-run    # preview
#   ./bootstrap-kde.sh --force      # force l'exécution même hors KDE (déconseillé)

set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KDE_DIR="$DIR/kde"

# ── Helpers ──────────────────────────────────────────────────────────────────

green()  { printf "\033[32m%s\033[0m\n" "$*"; }
yellow() { printf "\033[33m%s\033[0m\n" "$*"; }
blue()   { printf "\033[34m%s\033[0m\n" "$*"; }
red()    { printf "\033[31m%s\033[0m\n" "$*"; }
installed() { command -v "$1" &>/dev/null; }
dry() { yellow "  [dry-run] would: $*"; }

# ── Flags ────────────────────────────────────────────────────────────────────

DRYRUN=0
FORCE=0
for arg in "$@"; do
    case "$arg" in
        --dry-run) DRYRUN=1 ;;
        --force)   FORCE=1 ;;
    esac
done

# ── Détection KDE ────────────────────────────────────────────────────────────

if [[ "$FORCE" != "1" ]]; then
    if [[ ! "${XDG_CURRENT_DESKTOP:-}" =~ (KDE|Plasma) ]] && ! installed plasmashell; then
        yellow "Skipped: pas de KDE détecté (XDG_CURRENT_DESKTOP=${XDG_CURRENT_DESKTOP:-unset})."
        yellow "  Ce script est spécifique à KDE Plasma / Tuxedo OS. Utiliser --force pour outrepasser."
        exit 0
    fi
fi

if [[ "$DRYRUN" == "1" ]]; then
    blue "=== Bootstrap KDE — DRY RUN (no changes will be made) ==="
else
    blue "=== Bootstrap KDE — configuring KDE integration ==="
fi
echo ""

# ── 1. Paquets apt KDE ───────────────────────────────────────────────────────

blue "[1/6] ksshaskpass (prompt passphrase KDE + KWallet)"
if ! dpkg -l ksshaskpass 2>/dev/null | grep -q "^ii"; then
    if [[ "$DRYRUN" == "1" ]]; then dry "sudo apt install ksshaskpass"
    else
        sudo apt install -y ksshaskpass
        green "  ksshaskpass installed"
    fi
else
    echo "  ksshaskpass already installed"
fi

# ── 2. Nerd Font ─────────────────────────────────────────────────────────────

blue "[2/6] JetBrainsMono Nerd Font"
FONT_DIR="$HOME/.local/share/fonts/JetBrainsMonoNF"
if [ ! -d "$FONT_DIR" ] || [ -z "$(ls -A "$FONT_DIR" 2>/dev/null)" ]; then
    if [[ "$DRYRUN" == "1" ]]; then dry "download + unzip JetBrainsMono Nerd Font → $FONT_DIR ; fc-cache -fv"
    else
        mkdir -p "$FONT_DIR"
        TMP=$(mktemp -d)
        curl -fsSL -o "$TMP/jbm.zip" \
            "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
        unzip -qo "$TMP/jbm.zip" -d "$FONT_DIR"
        rm -rf "$TMP"
        fc-cache -f "$FONT_DIR" >/dev/null
        green "  JetBrainsMono Nerd Font installed"
    fi
else
    echo "  JetBrainsMono Nerd Font already installed ($FONT_DIR)"
fi

# ── 3. Konsole — profil Zsh ─────────────────────────────────────────────────

blue "[3/6] Konsole profile (Zsh + Nerd Font)"
KONSOLE_PROFILE="$HOME/.local/share/konsole/Zsh.profile"
if [ ! -f "$KONSOLE_PROFILE" ]; then
    if [[ "$DRYRUN" == "1" ]]; then dry "cp $KDE_DIR/konsole/Zsh.profile → $KONSOLE_PROFILE"
    else
        mkdir -p "$(dirname "$KONSOLE_PROFILE")"
        cp "$KDE_DIR/konsole/Zsh.profile" "$KONSOLE_PROFILE"
        green "  Zsh.profile deployed"
    fi
else
    echo "  Zsh.profile already present"
fi

# Patch konsolerc pour DefaultProfile=Zsh.profile
KONSOLERC="$HOME/.config/konsolerc"
if [ -f "$KONSOLERC" ] && grep -q "^DefaultProfile=Zsh.profile" "$KONSOLERC"; then
    echo "  konsolerc already points to Zsh.profile"
else
    if [[ "$DRYRUN" == "1" ]]; then dry "patch $KONSOLERC with DefaultProfile=Zsh.profile"
    else
        mkdir -p "$(dirname "$KONSOLERC")"
        if [ -f "$KONSOLERC" ] && grep -q "^\[Desktop Entry\]" "$KONSOLERC"; then
            # Section existante : ajouter/remplacer DefaultProfile dans [Desktop Entry]
            if grep -q "^DefaultProfile=" "$KONSOLERC"; then
                sed -i 's|^DefaultProfile=.*|DefaultProfile=Zsh.profile|' "$KONSOLERC"
            else
                sed -i '/^\[Desktop Entry\]/a DefaultProfile=Zsh.profile' "$KONSOLERC"
            fi
        else
            # Pas de section : ajouter à la fin
            printf '\n[Desktop Entry]\nDefaultProfile=Zsh.profile\n' >> "$KONSOLERC"
        fi
        green "  konsolerc patched (DefaultProfile=Zsh.profile)"
    fi
fi

# ── 4. ssh-agent (systemd user + environment.d + autostart) ─────────────────

blue "[4/6] ssh-agent systemd user + ksshaskpass + autostart"

deploy_file() {
    # $1: source dans le repo, $2: destination
    local src="$1" dest="$2"
    if [ -f "$dest" ]; then
        echo "  $dest already present"
        return
    fi
    if [[ "$DRYRUN" == "1" ]]; then dry "cp $src → $dest"; return; fi
    mkdir -p "$(dirname "$dest")"
    cp "$src" "$dest"
    green "  $dest deployed"
}

deploy_file "$KDE_DIR/systemd/ssh-agent.service"   "$HOME/.config/systemd/user/ssh-agent.service"
deploy_file "$KDE_DIR/environment.d/10-ssh.conf"   "$HOME/.config/environment.d/10-ssh.conf"
deploy_file "$KDE_DIR/autostart/ssh-add.desktop"   "$HOME/.config/autostart/ssh-add.desktop"

# ── 5. Activer ssh-agent.service + neutraliser gpg-agent-ssh.socket ─────────

blue "[5/6] Activation systemd user"

# Mask gpg-agent-ssh.socket (le preset Debian l'active globalement)
if [ -L "$HOME/.config/systemd/user/gpg-agent-ssh.socket" ]; then
    echo "  gpg-agent-ssh.socket already masked"
else
    if [[ "$DRYRUN" == "1" ]]; then dry "systemctl --user mask gpg-agent-ssh.socket"
    else
        systemctl --user mask gpg-agent-ssh.socket
        green "  gpg-agent-ssh.socket masked"
    fi
fi

# Enable ssh-agent.service
if systemctl --user is-enabled ssh-agent.service 2>/dev/null | grep -q "^enabled"; then
    echo "  ssh-agent.service already enabled"
else
    if [[ "$DRYRUN" == "1" ]]; then dry "systemctl --user daemon-reload && enable --now ssh-agent.service"
    else
        systemctl --user daemon-reload
        systemctl --user enable --now ssh-agent.service
        green "  ssh-agent.service enabled + started"
    fi
fi

# ── 6. Dossier personnel ~/Mathieu/ + XDG user dirs ─────────────────────────

blue "[6/6] Personal folder ~/Mathieu/ + XDG user dirs"

MATHIEU_DIRS=(
    "$HOME/Mathieu/vault"
    "$HOME/Mathieu/projets"
    "$HOME/Mathieu/media/videos"
    "$HOME/Mathieu/media/photos"
    "$HOME/Mathieu/media/musique"
    "$HOME/Mathieu/docs"
    "$HOME/Mathieu/tmp"
)
for d in "${MATHIEU_DIRS[@]}"; do
    if [ ! -d "$d" ]; then
        if [[ "$DRYRUN" == "1" ]]; then dry "mkdir -p $d"
        else
            mkdir -p "$d"
            green "  created $d"
        fi
    fi
done

XDG_CONF="$HOME/.config/user-dirs.dirs"
if grep -q 'Mathieu' "$XDG_CONF" 2>/dev/null; then
    echo "  user-dirs.dirs already points to ~/Mathieu/"
else
    if [[ "$DRYRUN" == "1" ]]; then dry "deploy $KDE_DIR/user-dirs.dirs → $XDG_CONF && xdg-user-dirs-update"
    else
        cp "$KDE_DIR/user-dirs.dirs" "$XDG_CONF"
        xdg-user-dirs-update
        green "  user-dirs.dirs deployed + updated"
    fi
fi

# ── Summary ──────────────────────────────────────────────────────────────────

echo ""
green "=== Bootstrap KDE complete ==="
echo ""
echo "Next steps:"
echo "  1. Logout then login KDE (or reboot) — environment.d + autostart prennent effet au prochain login"
echo "  2. Au premier login : ksshaskpass affichera un prompt passphrase pour chaque clé ~/.ssh/id_*"
echo "     → COCHER 'Mémoriser dans le portefeuille' pour ne plus être sollicité ensuite"
echo "  3. Vérifications après login :"
echo "     echo \$SSH_AUTH_SOCK       # doit pointer /run/user/<uid>/ssh-agent.socket"
echo "     ssh-add -l                  # doit lister les clés"
echo "     ssh -T git@github.com       # ne doit plus demander la passphrase"
