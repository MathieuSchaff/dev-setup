#!/usr/bin/env zsh
# update.sh — commande unifiée pour mettre à jour le système et les outils
# Extrait de .zshrc pour être accessible partout (y compris navi)

C_B=$'\e[1;34m' C_G=$'\e[32m' C_0=$'\e[0m'

ARCH=$(uname -m)
case "$ARCH" in
    x86_64)  ARCH_ALT="amd64" ;;
    aarch64) ARCH_ALT="arm64" ;;
    *)       echo "Architecture non supportée : $ARCH" >&2; return 1 ;;
esac

_UPDATE_SAFE=(apt omz zsh-plugins rust cargo go uv tools)
_UPDATE_RUNTIME=(node bun pnpm conda)
_UPDATE_ALL=($_UPDATE_SAFE $_UPDATE_RUNTIME)

usage() {
  echo "Usage: update [catégorie...]"
  echo "  update            # tout safe"
  echo "  update --all      # tout (safe + runtime)"
  echo "  update rust go    # sélectif"
  echo "  update --list     # catégories disponibles"
}

list_categories() {
  echo "${C_B}Safe (inclus dans 'update'):${C_0}"
  printf "  %s\n" "${_UPDATE_SAFE[@]}"
  echo "${C_B}Runtime (sélectif uniquement):${C_0}"
  printf "  %s\n" "${_UPDATE_RUNTIME[@]}"
}

targets=("$@")

# Gestion des flags
if [[ "${targets[1]}" == "--list" || "${targets[1]}" == "-l" ]]; then
  list_categories; exit 0
fi
if [[ "${targets[1]}" == "--help" || "${targets[1]}" == "-h" ]]; then
  usage; exit 0
fi
if [[ "${targets[1]}" == "--all" || "${targets[1]}" == "-a" ]]; then
  targets=("${_UPDATE_ALL[@]}")
fi

# Sans argument → safe uniquement
[[ ${#targets[@]} -eq 0 ]] && targets=("${_UPDATE_SAFE[@]}")

for t in "${targets[@]}"; do
  echo "\n${C_B}== ${t} ==${C_0}"
  case "$t" in
    apt)
      sudo apt update && sudo apt upgrade -y
      ;;
    omz)
      [ -d "$ZSH" ] && zsh -c "source $ZSH/oh-my-zsh.sh && omz update"
      ;;
    zsh-plugins)
      for d in ~/.oh-my-zsh/custom/plugins/*/; do
        echo "  $(basename $d)..." && git -C "$d" pull --quiet
      done
      ;;
    rust)
      command -v rustup >/dev/null && rustup update
      ;;
    cargo)
      if command -v cargo-install-update >/dev/null; then
        cargo install-update -a
      else
        command -v cargo >/dev/null && cargo install bat git-delta eza tree-sitter-cli navi starship
      fi
      ;;
    go)
      go_latest=$(curl -fsSL 'https://go.dev/dl/?mode=json' | grep -oP '"version":\s*"go\K[^"]+' | head -1)
      go_cur=$(go version 2>/dev/null | grep -oP 'go\K[\d.]+')
      if [[ "$go_cur" == "$go_latest" ]]; then
        echo "  ${C_G}✓${C_0} go $go_cur à jour"
      else
        echo "  go ${go_cur:-<none>} → $go_latest"
        curl -fsSL "https://go.dev/dl/go${go_latest}.linux-${ARCH_ALT}.tar.gz" -o /tmp/go.tar.gz \
          && sudo rm -rf /usr/local/go \
          && sudo tar -C /usr/local -xzf /tmp/go.tar.gz \
          && rm /tmp/go.tar.gz
        echo "  ${C_G}✓${C_0} go $(go version 2>/dev/null | grep -oP 'go\K[\d.]+')"
      fi
      ;;
    node)
      if [ -s "$NVM_DIR/nvm.sh" ]; then
        source "$NVM_DIR/nvm.sh"
        nvm install --lts --reinstall-packages-from=default
        nvm alias default 'lts/*'
        nvm use default
        npm update -g
        echo "  ${C_G}✓${C_0} node $(node --version) (LTS)"
      fi
      ;;
    bun)
      command -v bun >/dev/null && bun upgrade
      echo "  ${C_G}✓${C_0} bun $(bun --version 2>/dev/null)"
      ;;
    pnpm)
      command -v corepack >/dev/null && corepack prepare pnpm@latest --activate
      echo "  ${C_G}✓${C_0} pnpm $(pnpm --version 2>/dev/null)"
      ;;
    conda)
      command -v conda >/dev/null && conda update -n base -c defaults conda -y
      echo "  ${C_G}✓${C_0} conda à jour"
      ;;
    uv)
      command -v uv >/dev/null && uv self update
      ;;
    tools)
      "${0:a:h}/update-tools.sh"
      ;;
    *)
      echo "  ✗ catégorie inconnue: $t (voir update --list)"
      ;;
  esac
done

echo "\n${C_G}✅ Done.${C_0}"
