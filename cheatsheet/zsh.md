# ZSH — Aliases & Navigation

Tu es en mode INSERT par défaut (vi-mode). `Esc` bascule en NORMAL — voir [vi-mode.md](./vi-mode.md).
Raccourcis fzf détaillés dans [tools.md](./tools.md#fzf--fuzzy-finder).

## Aliases Git

| Alias | Commande                                        |
|-------|-------------------------------------------------|
| `g`   | `git`                                           |
| `gs`  | `git status`                                    |
| `ga`  | `git add`                                       |
| `gc`  | `git commit`                                    |
| `gp`  | `git push`                                      |
| `gpl` | `git pull`                                      |
| `gco` | `git checkout`                                  |
| `gcb` | `git checkout -b`                               |
| `gbr` | `git branch`                                    |
| `lg`  | `lazygit` — smart exit (terminal suit le dossier)|

## Aliases Fichiers

| Alias  | Commande                       |
|--------|--------------------------------|
| `l`    | `eza -l --icons --git`         |
| `ll`   | `eza -la --icons --git`        |
| `tree` | `eza --tree --icons`           |
| `lh`   | `ls -lah`                      |
| `cat`  | `bat` (syntax highlighting)    |
| `c`    | `clear`                        |

## Aliases Docker

| Alias | Commande      | Cheatsheet                          |
|-------|---------------|-------------------------------------|
| `lzd` | `lazydocker`  | [lazydocker.md](./lazydocker.md)    |

> `ctop` et `dive` sont lancés par leur binaire direct — pas d'alias.
> Voir [ctop.md](./ctop.md) et [dive.md](./dive.md).

## Navigation

### Dossiers (zoxide)

| Commande  | Effet                                                             |
|-----------|-------------------------------------------------------------------|
| `z <nom>` | Sauter vers un dossier visité (zoxide — apprend l'historique)     |
| `zdf` / `Ctrl+F` | Fuzzy cd avec preview arborescence (fd + fzf + eza tree + zoxide) |

### Cheatsheets (glow)

| Commande            | Effet                                                                   |
|---------------------|-------------------------------------------------------------------------|
| `Ctrl+E`            | Parcourir `cheatsheet/` en fzf + preview glow (accès direct)           |
| `cs`                | Parcourir `cheatsheet/` en fzf + preview glow (loop, `q` pour quitter) |
| `mdp <fichier.md>`  | Ouvrir n'importe quel `.md` dans glow en mode pager                     |

> `mdp` = `glow -p` — uniquement pour fichiers Markdown. Pas lié à git.

### Navi

| Commande | Effet                                       |
|----------|---------------------------------------------|
| `Ctrl+N` | navi — cheatsheet interactif (widget shell, insère dans le prompt) |
| `Alt+P`  | parcourir cheatsheets markdown inline (fzf + glow)                 |

> Les raccourcis `Ctrl+T` / `Ctrl+R` / `Alt+C` / `Tab` (fzf et fzf-tab) sont dans
> [tools.md](./tools.md#fzf--fuzzy-finder).
> `↑ / ↓` filtrent l'historique par ce qui est tapé (history-substring-search).

## Tmux

> Cheatsheet tmux complet → [tmux.md](./tmux.md). Ci-dessous, ce qui passe par zsh.

| Alias / Commande       | Effet                                            |
|------------------------|--------------------------------------------------|
| `t`                    | Lancer tmux (crée sessions `doc`/`dev`/`tests`)  |
| `tn <nom>`             | Créer session en arrière-plan                    |
| `tnew <nom>`           | Créer une session nommée (`tmux new -s`)         |
| `tmux attach -t <nom>` | Rejoindre une session existante                  |
| `Ctrl+g`               | Popup lazygit (sans préfixe tmux)                |
| `Ctrl+e`               | Popup doc cheatsheets fzf+glow (sans préfixe tmux) |
| `Alt+N`                | Popup navi (sans préfixe tmux)                   |
| `Alt+U`                | Popup switcher de sessions fzf (sans préfixe tmux) |

## Complétions

Trois sources alimentent compinit au démarrage de zsh :

| Source                                   | Origine                                                                  |
|------------------------------------------|--------------------------------------------------------------------------|
| Système                                  | `/usr/share/zsh/functions/Completion/{Unix,Debian,Base,...}` (paquet `zsh`) |
| Vendor                                   | `/usr/share/zsh/vendor-completions/` (ajoutées par `.deb` tiers : systemd, fd, ripgrep, flatpak…) |
| oh-my-zsh plugins                        | `~/.oh-my-zsh/plugins/<nom>/` + `~/.oh-my-zsh/custom/plugins/<nom>/` (listés dans `plugins=(...)` du `.zshrc`) |
| oh-my-zsh custom completions             | `~/.oh-my-zsh/custom/completions/` (déposé manuellement — déjà dans le fpath par défaut) |
| Sourcé dans `.zshrc`                     | `~/.bun/_bun` (ligne `[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"`) |

### Complétions custom déjà en place

Déposées dans `~/.oh-my-zsh/custom/completions/` :

| Outil      | Comment la générer                                                             |
|------------|--------------------------------------------------------------------------------|
| `rustup`   | `rustup completions zsh > ~/.oh-my-zsh/custom/completions/_rustup`            |
| `cargo`    | `rustup completions zsh cargo > ~/.oh-my-zsh/custom/completions/_cargo` (wrapper qui source le vrai `_cargo` livré avec Rust) |
| `gh`       | `gh completion -s zsh > ~/.oh-my-zsh/custom/completions/_gh`                  |
| `starship` | `starship completions zsh > ~/.oh-my-zsh/custom/completions/_starship`        |
| `glow`     | `glow completion zsh > ~/.oh-my-zsh/custom/completions/_glow`                 |
| `pnpm`     | `pnpm completion zsh > ~/.oh-my-zsh/custom/completions/_pnpm`                 |
| `eza`      | `curl -fsSL https://raw.githubusercontent.com/eza-community/eza/main/completions/zsh/_eza -o ~/.oh-my-zsh/custom/completions/_eza` (pas de sous-commande `completions` dans eza — récupération depuis le repo upstream) |
| `delta`    | `curl -fsSL https://raw.githubusercontent.com/dandavison/delta/main/etc/completion/completion.zsh -o ~/.oh-my-zsh/custom/completions/_delta` |
| `bun`      | `bun completions` → installe dans `~/.bun/_bun` ; déjà sourcé par `.zshrc` |

**Cas non couvert :** `bat` — le repo upstream (sharkdp/bat) ne publie pas de complétion zsh (seulement bash/fish/powershell). À écrire à la main si besoin, ou installer la version `apt` en parallèle (elle dépose `_bat` dans `/usr/share/zsh/vendor-completions/`).

### Tester si une commande a sa complétion

```sh
<cmd> <TAB>
```

Si ça propose des sous-commandes/flags/arguments typés → OK. Si ça propose les **fichiers** du dossier courant → pas de complétion (zsh tombe sur la complétion par défaut).

### Ajouter une nouvelle complétion

```sh
# Exemple : un outil <foo> qui a une sous-commande `completions zsh`
<foo> completions zsh > ~/.oh-my-zsh/custom/completions/_foo

# Fichier doit commencer par `#compdef <foo>` — vérifier :
head -1 ~/.oh-my-zsh/custom/completions/_foo
```

Un fichier `_<cmd>` avec `#compdef <cmd>` est automatiquement pris en compte par compinit au prochain shell. Si ça ne prend pas effet : `rm ~/.zcompdump*` puis relancer zsh pour forcer un rebuild du cache.

## Updates

Une seule commande : `update`. Tab-completion activée (flags + catégories).

| Commande             | Effet                                                  |
|----------------------|--------------------------------------------------------|
| `update`             | Tout safe : apt, omz, zsh-plugins, rust, cargo, go, uv, tools |
| `update --all`       | Tout (safe + runtime : node, bun, pnpm, conda)        |
| `update rust go`     | Sélectif — une ou plusieurs catégories                 |
| `update --list`      | Affiche toutes les catégories disponibles              |

**Catégories safe** (incluses dans `update` sans argument) :

| Catégorie      | Ce que ça met à jour                                    |
|----------------|---------------------------------------------------------|
| `apt`          | `sudo apt update && sudo apt upgrade`                   |
| `omz`          | Oh My Zsh                                               |
| `zsh-plugins`  | Plugins custom (git pull sur chaque)                    |
| `rust`         | `rustup update` (toolchain + rustc)                     |
| `cargo`        | Outils cargo : bat, delta, eza, tree-sitter-cli         |
| `go`           | Go (tarball depuis go.dev, comparaison de version)      |
| `uv`           | `uv self update`                                        |
| `tools`        | Binaires manuels via `update-tools.sh` (git, dive, lazygit, lazydocker, ctop, nvim, fzf) |

**Catégories runtime** (sélectif uniquement — risque de casser des projets) :

| Catégorie | Ce que ça met à jour                                      |
|-----------|-----------------------------------------------------------|
| `node`    | Node (nvm) + npm packages globaux                         |
| `bun`     | `bun upgrade`                                             |
| `pnpm`    | `corepack prepare pnpm@latest --activate`                 |
| `conda`   | `conda update -n base -c defaults conda`                  |
