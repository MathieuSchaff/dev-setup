# Load central color palette
[ -f "$HOME/dev-setup/config/colors.sh" ] && source "$HOME/dev-setup/config/colors.sh"

# Force $SHELL to zsh — la session KDE peut hériter d'un ancien $SHELL=/bin/bash
# (avant chsh), ce qui casse fzf preview, tmux popup, etc. qui spawn via $SHELL.
export SHELL=/usr/bin/zsh

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""  # prompt géré par Starship (~/.config/starship.toml)
plugins=(git zsh-autosuggestions zsh-syntax-highlighting vi-mode zsh-history-substring-search fzf-tab)
source $ZSH/oh-my-zsh.sh

# history-substring-search keybindings (after oh-my-zsh load)
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# User configuration

# Set personal aliases
alias c='clear'
# git aliases
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gpl='git pull'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gbr='git branch'
# ls aliases
alias l='eza -l --icons --git'
alias ll='eza -la --icons --git'
alias tree='eza --tree --icons'
alias lh='ls -lah'

# bat / lazygit
export COLORTERM=truecolor
alias cat='bat'

# lazygit — smart exit (le terminal suit le dossier courant de lazygit)
lg() {
    export LAZYGIT_NEW_DIR_FILE=~/.lazygit/newdir
    lazygit "$@"
    if [ -f "$LAZYGIT_NEW_DIR_FILE" ]; then
        cd "$(cat "$LAZYGIT_NEW_DIR_FILE")"
        rm -f "$LAZYGIT_NEW_DIR_FILE" > /dev/null
    fi
}

# fdfind alias (conflit de nom apt)
alias fd="fdfind"
# lazydocker — TUI Docker / Compose
alias lzd='lazydocker'
# Updater global
update-tools() { ~/dev-setup/scripts/update-tools.sh "$@"; }
update() { ~/dev-setup/scripts/update.sh "$@"; }

# completions update / update-tools
_update() {
  _arguments \
    '(-a --all)'{-a,--all}'[update everything including runtimes]' \
    '(-l --list)'{-l,--list}'[list available categories]' \
    '(-h --help)'{-h,--help}'[show help]' \
    '*:category:(apt omz zsh-plugins rust cargo go uv tools node bun pnpm conda)'
}
compdef _update update

_update_tools() {
  _arguments \
    '(-c --check)'{-c,--check}'[check outdated without updating]' \
    '(-l --list)'{-l,--list}'[list managed tools]' \
    '(-h --help)'{-h,--help}'[show help]' \
    '*:tool:(git dive lazygit lazydocker ctop neovim fzf tmux omz)'
}
compdef _update_tools update-tools

# tmux — sessions dev/tests au démarrage, sinon attach
# cs s'ouvre via Ctrl+E (popup tmux global, toutes sessions — voir .tmux.conf:108)
t() {
  if ! tmux list-sessions &>/dev/null; then
    tmux new-session -d -s dev
  fi
  tmux has-session -t dev   2>/dev/null || tmux new-session -d -s dev
  tmux has-session -t tests 2>/dev/null || tmux new-session -d -s docker 
  tmux has-session -t tests 2>/dev/null || tmux new-session -d -s tests
  tmux attach -t dev
}

# Créer une session nommée en arrière-plan
tn(){
  tmux new -d -s "$1"
  echo "Session '$1' créée en arrière-plan. Utilise 'Ctrl+b s' pour la rejoindre."
}
alias tnew='tmux new -s'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Cheatsheet — glow partout
alias mdp='glow -p'
cs() {
  local file
  while file=$(fdfind -e md --base-directory ~/dev-setup/cheatsheet \
    | fzf --preview 'glow -s dark -w 80 ~/dev-setup/cheatsheet/{}') \
    && [[ -n "$file" ]]; do
    glow -p ~/dev-setup/cheatsheet/"$file"
  done
}

# navi — widget shell sur Ctrl+N
eval "$(navi widget zsh)"
bindkey '^N' _navi_widget

# Alt+P — parcourir les cheatsheets markdown avec glow (loop, Esc pour quitter)
# (Ctrl+E est pris au niveau tmux : popup cs, voir .tmux.conf:108)
cheat-browse-widget() {
  local file
  while file=$(fdfind -e md --base-directory ~/dev-setup/cheatsheet \
    | fzf --preview 'glow -s dark -w 80 ~/dev-setup/cheatsheet/{}' \
           --preview-window 'right:60%' \
           --bind 'ctrl-d:preview-half-page-down,ctrl-u:preview-half-page-up,ctrl-/:change-preview-window(hidden|)') \
    && [[ -n "$file" ]]; do
    glow -p ~/dev-setup/cheatsheet/"$file"
  done
  zle reset-prompt
}
zle -N cheat-browse-widget
bindkey '^[p' cheat-browse-widget

# historique
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt SHARE_HISTORY

eval "$(zoxide init zsh)"
[ -f "$HOME/dev-setup/config/.fzf.zsh" ] && source "$HOME/dev-setup/config/.fzf.zsh"

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

bindkey -v

# PATH — regroupé (ordre : local > conda > bun > nvim > pnpm > nvm > cargo > system > go)
export BUN_INSTALL="$HOME/.bun"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="/opt/nvim/bin:$PATH"
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:/mnt/c/Program Files/GitHub CLI"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# fnb / fns — pick + run a script from package.json via fzf (needs jq)
fnb() {
  [[ ! -f package.json ]] && { echo "no package.json here"; return 1; }
  local script
  script=$(jq -r '.scripts // {} | keys[]' package.json | sort | fzf --prompt='bun run > ') \
    && bun run "$script"
}
fns() {
  [[ ! -f package.json ]] && { echo "no package.json here"; return 1; }
  local script
  script=$(jq -r '.scripts // {} | keys[]' package.json | sort | fzf --prompt='npm run > ') \
    && npm run "$script"
}

# fman — fuzzy man-page browser with bat preview
fman() {
  man -k . | fzf -q "$1" --prompt='man > ' \
    --preview 'echo {} | tr -d "()" | awk "{printf \"%s \", \$2} {print \$1}" | xargs -r man | col -bx | bat -l man -p --color always' |
  tr -d '()' | awk '{printf "%s ", $2} {print $1}' | xargs -r man
}

# conda
if [ -d "$HOME/miniconda3" ]; then
    __conda_setup="$('$HOME/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
            . "$HOME/miniconda3/etc/profile.d/conda.sh"
        else
            export PATH="$HOME/miniconda3/bin:$PATH"
        fi
    fi
    unset __conda_setup
fi

# Starship prompt
eval "$(starship init zsh)"

# Load local/secret configurations
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
