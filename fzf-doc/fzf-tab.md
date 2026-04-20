# fzf-tab

Plugin zsh qui remplace le menu de complétion par défaut par fzf. Fonctionne **partout** où la complétion zsh s'applique (variables, commandes, chemins, in-word, directory stack, etc.) — contrairement au trigger `**<TAB>` de fzf natif qui ne marche que sur commandes pré-déclarées.

Repo : https://github.com/Aloxaf/fzf-tab

## Pré-requis critiques

1. `fzf` installé
2. `fzf-tab` chargé **après** `compinit` mais **avant** les plugins qui wrappent les widgets (`zsh-autosuggestions`, `fast-syntax-highlighting`, `zsh-syntax-highlighting`)
3. `zstyle ':completion:*'` configuré **avant** `compinit`
4. S'il y a conflit sur `^I` (TAB), fzf-tab doit être **le dernier** à binder la touche

## Install

### Oh-My-Zsh (ce setup)
```bash
git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
# Puis dans ~/.zshrc :
# plugins=(... fzf-tab)   ← placer en fin de liste
```

### Autres gestionnaires
```bash
# Zinit
zinit light Aloxaf/fzf-tab

# Antigen
antigen bundle Aloxaf/fzf-tab

# Manuel
git clone https://github.com/Aloxaf/fzf-tab ~/path/to/fzf-tab
# ~/.zshrc :
autoload -U compinit; compinit
source ~/path/to/fzf-tab/fzf-tab.plugin.zsh

# Prezto
git clone https://github.com/Aloxaf/fzf-tab $ZPREZTODIR/contrib/fzf-tab
```

## Usage

Juste `Tab` comme d'habitude. Bindings dans l'interface fzf-tab :

| Touche | Action | Tag configurable |
| :--- | :--- | :--- |
| `Ctrl+Space` | Multi-sélection | `fzf-bindings` |
| `F1` / `F2` | Changer de groupe | `switch-group` |
| `/` | Complétion continue (pratique pour chemins profonds) | `continuous-trigger` |

Commandes :
- `disable-fzf-tab` : désactive, retour au système compsys standard
- `enable-fzf-tab` : réactive
- `toggle-fzf-tab` : bascule (également un widget zle)

## Configuration

Tout passe par `zstyle`. Scope : `:fzf-tab:*` (plugin) ou `:completion:*` (système compsys que fzf-tab consomme).

```zsh
# Désactiver le tri pour `git checkout` (ordre git préservé)
zstyle ':completion:*:git-checkout:*' sort false

# Format des descriptions — active le support des groupes
# ATTENTION : pas d'escape sequences (ex: '%F{red}%d%f'), fzf-tab les ignore
zstyle ':completion:*:descriptions' format '[%d]'

# Colorisation des fichiers depuis LS_COLORS
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Forcer zsh à ne pas afficher son menu — fzf-tab capture le préfixe non-ambigu
zstyle ':completion:*' menu no

# Preview du dossier lors du `cd` (eza)
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'

# Flags fzf custom (fzf-tab N'HÉRITE PAS de FZF_DEFAULT_OPTS par défaut)
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept

# Pour hériter FZF_DEFAULT_OPTS (attention : certains flags cassent le plugin — issue #455)
zstyle ':fzf-tab:*' use-fzf-default-opts yes

# Changer de groupe avec < et >
zstyle ':fzf-tab:*' switch-group '<' '>'
```

## Mode popup tmux (tmux ≥ 3.2)

Script `ftb-tmux-popup` fourni :
```zsh
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
```
Utilisable aussi en standalone :
```bash
ls | ftb-tmux-popup
```

## Module binaire (performance)

Par défaut fzf-tab parse `LS_COLORS` via `zsh-ls-colors` (script zsh pur — lent si beaucoup de fichiers). Un module binaire est fourni :
```zsh
build-fzf-tab-module
# Activé automatiquement au prochain chargement
```

## Différences vs autres plugins

- fzf-tab ne fait **pas** la complétion : il affiche les résultats du système compsys de zsh.
- Toute ta config `zstyle ':completion:*'` existante reste valide.
- Le trigger `**<TAB>` de fzf natif reste dispo **en parallèle** (il n'utilise pas compsys).

## Compatibilité

Plugins qui bindent `^I` (TAB) — risque de conflit : `fzf/shell/completion.zsh`, `ohmyzsh/lib/completion.zsh`. fzf-tab appelle le widget précédemment bindé pour obtenir la liste, donc généralement OK — à condition que fzf-tab soit chargé **en dernier** sur `^I`.

## Setup local (ce dotfiles repo)

fzf-tab est activé via Oh-My-Zsh dans `~/.zshrc`. Placé en fin de `plugins=(...)`. Popup padding custom déjà configuré (voir commit `2096154`).
