# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME=""
# Custom prompt
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%F{yellow}(%b)%f'
setopt PROMPT_SUBST
PROMPT='%(?.%F{green}➜%f.%F{red}➜%f) %F{cyan}%~%f ${vcs_info_msg_0_}
%F{green}❯%f '
# PROMPT='%F{200}'%n@%m %c' %1~>%f'

# SHOW LAST THREE FOLDERS
#PROMPT='%{$fg[cyan]%}%3~ %{$fg[red]%}%(!.#.») %{$reset_color%}'

# SHOW FULL PATH 

# PROMPT='%{$fg[cyan]%}%~ %{$fg[red]%}%(!.#.») %{$reset_color%}'


# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting vi-mode zsh-history-substring-search fzf-tab)
source $ZSH/oh-my-zsh.sh

# history-substring-search keybindings (after oh-my-zsh load)
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# fzf-tab configuration
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:*' switch-group '<' '>'
# open completion in tmux popup when inside tmux
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
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
alias cat='batcat'
# lazygit — smart exit (le terminal suit le dossier courant de lazygit)
lg() {
    export LAZYGIT_NEW_DIR_FILE=~/.lazygit/newdir
    lazygit "$@"
    if [ -f "$LAZYGIT_NEW_DIR_FILE" ]; then
        cd "$(cat "$LAZYGIT_NEW_DIR_FILE")"
        rm -f "$LAZYGIT_NEW_DIR_FILE" > /dev/null
    fi
}
alias update-lazygit='LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po "\"tag_name\": \"v\K[^\"]*") && curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" && tar xf /tmp/lazygit.tar.gz -C /tmp lazygit && sudo install /tmp/lazygit /usr/local/bin'
# delta installé via cargo — update: cargo install git-delta
# tmux aliases
# Créer une session nommée en arrière-plan (évite le nesting)
tn(){ 
  tmux new -d -s "$1"
  echo "Session '$1' créée en arrière-plan. Utilise 'Ctrl+b s' pour la rejoindre."
}

# Bonus : Créer et rejoindre immédiatement (si tu es HORS de tmux)
alias tnew='tmux new -s'

# Lancer tmux : crée session doc au premier démarrage, sinon attach
t() {
  if tmux list-sessions &>/dev/null; then
    # Sessions existantes — attach simplement
    tmux attach
  else
    # Premier démarrage — créer session doc + session main
    tmux new-session -d -s doc -c ~/dev-setup/cheatsheet "nvim -c 'e README.md'"
    tmux new-session -d -s main
    tmux attach -t main
  fi
}
# fdfind alias
alias fd="fdfind"
alias update-zsh-plugins='for d in ~/.oh-my-zsh/custom/plugins/*/; do echo "Updating $(basename $d)..." && git -C "$d" pull; done'

update-all() {
  echo "\n== APT =="
  sudo apt update && sudo apt upgrade -y

  echo "\n== Oh My Zsh =="
  omz update

  echo "\n== Plugins Zsh =="
  for d in ~/.oh-my-zsh/custom/plugins/*/; do
    echo "Updating $(basename $d)..." && git -C "$d" pull
  done

  echo "\n== Rust & cargo tools =="
  rustup update
  cargo install bat delta eza tree-sitter-cli

  echo "\n== uv =="
  uv self update

  echo "\n== Lazygit =="
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*') \
    && curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" \
    && tar xf /tmp/lazygit.tar.gz -C /tmp lazygit \
    && sudo install /tmp/lazygit /usr/local/bin

  echo "\n== fzf =="
  cd ~/.fzf && git pull && ./install --all && cd -

  echo "\n✅ Tout est à jour !"
}

# Updates séparés (risque de casser des projets — lancer manuellement)
update-node() {
  echo "== Node (nvm) =="
  nvm install node --reinstall-packages-from=node
  nvm alias default node
  echo "== npm packages globaux =="
  npm update -g
  echo "✅ Node mis à jour : $(node --version)"
}

update-bun() {
  echo "== Bun =="
  bun upgrade
  echo "✅ Bun mis à jour : $(bun --version)"
}

update-conda() {
  echo "== Conda =="
  conda update -n base -c defaults conda -y
  echo "✅ Conda mis à jour."
}

update-nvim() {
  echo "== Neovim (pre-built) =="
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
  sudo rm -rf /opt/nvim-linux-x86_64
  sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
  rm nvim-linux-x86_64.tar.gz
  echo "✅ Neovim mis à jour : $(nvim --version | head -1)"
}
alias zdf='selected_dir=$(fd -t d | fzf) && [ -n "$selected_dir" ] && z "$selected_dir" || sleep 0.1'
#
#export TERM="xterm-256color"
export PATH=$PATH:/usr/local/go/bin
# export PATH=$PATH:~/go/bin
export PATH="/opt/nvim-linux-x86_64/bin:$PATH"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # Ceci charge nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # Ceci charge la complétion de commande nvm (facultatif)
alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
alias cheat='cd ~/dev-setup/cheatsheet && ls'
# alias pgadmin4='/usr/pgadmin4/bin/pgadmin4'
# Add PostgreSQL binaries to PATH
# alias psql='/usr/bin/psql'
# export ANDROID_HOME=$HOME/Android/Sdk
# export PATH=$PATH:$ANDROID_HOME/emulator
# export PATH=$PATH:$ANDROID_HOME/platform-tools
# alias studio='/home/mathieu/Android/Sdk/tools/bin/studio.sh'
# alias studio='/usr/local/android-studio/bin/studio.sh'
#. "$HOME/.cargo/env"
# fzf — preview avec bat, layout amélioré
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --preview "batcat --color=always {}"'
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

# historique plus long, sans doublons
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt SHARE_HISTORY

eval "$(zoxide init zsh)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export LC_ALL=en_US.UTF-8

# pnpm
export PNPM_HOME="/home/schaff/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
export PATH=$PATH:/mnt/c/Program\ Files/GitHub\ CLI
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
bindkey -v

# bun completions
[ -s "/home/schaff/.bun/_bun" ] && source "/home/schaff/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/schaff/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/schaff/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/schaff/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/schaff/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
