#!/usr/bin/env bash
# update-tools.sh — met à jour les CLI installés manuellement (hors apt / cargo)
#
# Usage:
#   update-tools               # update tous les outils connus
#   update-tools dive lazygit  # update sélectif
#   update-tools --check       # affiche seulement ce qui est outdated
#   update-tools --list        # liste les outils supportés
#
# Outils gérés : dive, lazygit, lazydocker, ctop, neovim, fzf
#
# Note : les outils cargo (delta, eza, bat) se mettent à jour via
#   `cargo install-update -a` (après `cargo install cargo-update`).
# Les outils apt (ripgrep, fd, glow, ...) via `sudo apt upgrade`.

set -euo pipefail

C_B=$'\e[1;34m'; C_G=$'\e[32m'; C_Y=$'\e[33m'; C_R=$'\e[31m'; C_D=$'\e[2m'; C_0=$'\e[0m'

ALL_TOOLS=(dive lazygit lazydocker ctop neovim fzf)

usage() {
  sed -n '2,14p' "$0" | sed 's/^# \{0,1\}//'
}

section() { printf "\n${C_B}==> %s${C_0}\n" "$1"; }
info()    { printf "    %s\n" "$*"; }
ok()      { printf "    ${C_G}✓${C_0} %s\n" "$*"; }
skip()    { printf "    ${C_D}= %s${C_0}\n" "$*"; }
warn()    { printf "    ${C_Y}!${C_0} %s\n" "$*"; }
fail()    { printf "    ${C_R}✗${C_0} %s\n" "$*"; }

# gh_latest owner/repo -> prints the latest release tag (without leading 'v')
gh_latest() {
  curl -fsSL "https://api.github.com/repos/$1/releases/latest" \
    | grep -oP '"tag_name":\s*"v?\K[^"]+'
}

# ---------- version detectors (echo empty string if not installed) ----------

v_dive()       { command -v dive       >/dev/null && dive --version 2>/dev/null | grep -oP '^dive \K\S+'; }
v_lazygit()    { command -v lazygit    >/dev/null && lazygit --version 2>/dev/null | grep -oP ', version=\K[^,]+'; }
v_lazydocker() { command -v lazydocker >/dev/null && lazydocker --version 2>/dev/null | grep -oP 'Version:\s*\K\S+' | head -1; }
v_ctop()       { command -v ctop       >/dev/null && ctop -v 2>&1 | grep -oP 'version \K[^,]+'; }
v_nvim()       { command -v nvim       >/dev/null && nvim --version | head -1 | grep -oP 'v\K\S+'; }
v_fzf()        { command -v fzf        >/dev/null && fzf --version | awk '{print $1}'; }

# ---------- updaters ----------

update_dive() {
  local latest cur
  latest=$(gh_latest wagoodman/dive)
  cur=$(v_dive || true)
  if [[ "$cur" == "$latest" ]]; then skip "dive $cur up-to-date"; return; fi
  info "dive ${cur:-<none>} → $latest"
  [[ $CHECK -eq 1 ]] && return
  local tmp; tmp=$(mktemp -d)
  trap "rm -rf $tmp" RETURN
  ( cd "$tmp" && curl -fsSLO "https://github.com/wagoodman/dive/releases/download/v${latest}/dive_${latest}_linux_amd64.deb" )
  sudo apt install -y "$tmp/dive_${latest}_linux_amd64.deb"
  ok "dive → $(v_dive)"
}

update_lazygit() {
  local latest cur
  latest=$(gh_latest jesseduffield/lazygit)
  cur=$(v_lazygit || true)
  if [[ "$cur" == "$latest" ]]; then skip "lazygit $cur up-to-date"; return; fi
  info "lazygit ${cur:-<none>} → $latest"
  [[ $CHECK -eq 1 ]] && return
  local tmp; tmp=$(mktemp -d)
  trap "rm -rf $tmp" RETURN
  ( cd "$tmp" \
      && curl -fsSLo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${latest}/lazygit_${latest}_Linux_x86_64.tar.gz" \
      && tar xf lazygit.tar.gz lazygit \
      && sudo install lazygit /usr/local/bin )
  ok "lazygit → $(v_lazygit)"
}

update_lazydocker() {
  # Le script d'install fait lui-même le diff de version
  local cur; cur=$(v_lazydocker || true)
  info "lazydocker ${cur:-<none>} — via script officiel"
  [[ $CHECK -eq 1 ]] && { warn "lazydocker : --check non supporté (le script décide)"; return; }
  curl -fsSL https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
  ok "lazydocker → $(v_lazydocker)"
}

update_ctop() {
  local latest cur
  latest=$(gh_latest bcicen/ctop)
  cur=$(v_ctop || true)
  if [[ "$cur" == "$latest" ]]; then skip "ctop $cur up-to-date"; return; fi
  info "ctop ${cur:-<none>} → $latest"
  [[ $CHECK -eq 1 ]] && return
  sudo curl -fsSLo /usr/local/bin/ctop "https://github.com/bcicen/ctop/releases/download/v${latest}/ctop-${latest}-linux-amd64"
  sudo chmod +x /usr/local/bin/ctop
  ok "ctop → $(v_ctop)"
}

update_neovim() {
  local latest cur
  latest=$(gh_latest neovim/neovim)
  cur=$(v_nvim || true)
  if [[ "$cur" == "$latest" ]]; then skip "neovim $cur up-to-date"; return; fi
  # Si l'installé est > latest stable (ex. nightly), on saute
  if [[ -n "$cur" && "$(printf '%s\n%s' "$latest" "$cur" | sort -V | tail -1)" == "$cur" && "$cur" != "$latest" ]]; then
    warn "neovim $cur > latest stable $latest — probablement une nightly, skip"
    return
  fi
  info "neovim ${cur:-<none>} → $latest"
  [[ $CHECK -eq 1 ]] && return
  local tmp; tmp=$(mktemp -d)
  trap "rm -rf $tmp" RETURN
  ( cd "$tmp" \
      && curl -fsSLo nvim.tar.gz "https://github.com/neovim/neovim/releases/download/v${latest}/nvim-linux-x86_64.tar.gz" \
      && sudo tar -C /opt -xf nvim.tar.gz )
  ok "neovim → $(v_nvim)"
}

update_fzf() {
  [[ ! -d ~/.fzf ]] && { fail "~/.fzf absent — skip"; return; }
  local latest cur
  latest=$(gh_latest junegunn/fzf)
  cur=$(v_fzf || true)
  if [[ "$cur" == "$latest" ]]; then skip "fzf $cur up-to-date"; return; fi
  info "fzf ${cur:-<none>} → $latest"
  [[ $CHECK -eq 1 ]] && return
  ( cd ~/.fzf && git pull --quiet && ./install --bin --no-update-rc >/dev/null )
  ok "fzf → $(v_fzf)"
}

# ---------- dispatch ----------

CHECK=0
TOOLS=()
for arg in "$@"; do
  case "$arg" in
    -h|--help)  usage; exit 0 ;;
    -l|--list)  printf "%s\n" "${ALL_TOOLS[@]}"; exit 0 ;;
    -c|--check) CHECK=1 ;;
    -*)         echo "unknown flag: $arg" >&2; usage; exit 1 ;;
    *)          TOOLS+=("$arg") ;;
  esac
done
[[ ${#TOOLS[@]} -eq 0 ]] && TOOLS=("${ALL_TOOLS[@]}")

for t in "${TOOLS[@]}"; do
  section "$t"
  case "$t" in
    dive)          update_dive ;;
    lazygit)       update_lazygit ;;
    lazydocker)    update_lazydocker ;;
    ctop)          update_ctop ;;
    neovim|nvim)   update_neovim ;;
    fzf)           update_fzf ;;
    *)             fail "outil inconnu: $t (voir --list)" ;;
  esac
done

echo
