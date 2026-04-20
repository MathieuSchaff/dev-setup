# fzf — setup, options, widgets, fzf-tab theming
# Sourced from ~/.zshrc after oh-my-zsh and zoxide init.

# ── PATH + shell integration ──────────────────────────────────────────────────
if [[ ! "$PATH" == *"$HOME/.fzf/bin"* ]]; then
  PATH="${PATH:+${PATH}:}$HOME/.fzf/bin"
fi
source <(fzf --zsh)

# ── Theme & defaults (Catppuccin Macchiato) ───────────────────────────────────
export FZF_DEFAULT_OPTS='
  --height 40% --layout=reverse --border
  --bind "ctrl-d:preview-half-page-down,ctrl-u:preview-half-page-up,ctrl-/:change-preview-window(hidden|)"
  --color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796
  --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6
  --color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796
  --color=border:#494d64,header:#ed8796'
export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --follow --exclude .git'

# Ctrl+T — fichier + preview bat
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS='
  --walker-skip .git,node_modules,target,.venv
  --preview "bat -n --color=always --line-range :500 {}"
  --bind "ctrl-/:change-preview-window(down|hidden|)"'

# Clipboard cmd (xclip X11/WSLg, wl-copy Wayland)
if command -v xclip &>/dev/null; then
    CLIP_CMD="xclip -selection clipboard"
elif command -v wl-copy &>/dev/null; then
    CLIP_CMD="wl-copy"
else
    CLIP_CMD=""
fi

# Ctrl+R — history + Ctrl+Y copie clipboard
export FZF_CTRL_R_OPTS="
  --bind \"ctrl-y:execute-silent(echo -n {2..} | ${CLIP_CMD:-cat >/dev/null})+abort\"
  --color header:italic
  --header \"Ctrl+Y = copier dans clipboard\""

# Alt+C désactivé (remplacé par Ctrl+F / zdf-widget)
export FZF_ALT_C_COMMAND=''

# ── fzf-tab — theme Catppuccin + popup tmux ───────────────────────────────────
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:*' popup-pad 30 8
# popup tmux n'hérite pas de FZF_DEFAULT_OPTS → re-définir couleurs
zstyle ':fzf-tab:*' fzf-flags \
  --color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
  --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
  --color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796 \
  --color=border:#494d64

# ── zdf — fuzzy cd avec preview ───────────────────────────────────────────────
zdf() {
  local dir
  dir=$(fd -t d | fzf --preview 'eza --tree --color=always --icons --level=2 {}') && z "$dir"
}

# Ctrl+F — widget fuzzy cd (remplace Alt+C)
zdf-widget() {
  local dir
  dir=$(fd -t d | fzf --select-1 --preview 'eza --tree --color=always --icons --level=2 {}')
  if [[ -n "$dir" ]]; then
    z "$dir"
    zle reset-prompt
  fi
}
zle -N zdf-widget
bindkey '^F' zdf-widget
