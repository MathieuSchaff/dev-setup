# Navi — Cheatsheet interactif

Navi affiche une liste de commandes avec **variables fzf** — tu sélectionnes,
il complète et exécute.

## Lancement

| Commande / Raccourci     | Contexte | Effet                                              |
|--------------------------|----------|----------------------------------------------------|
| `navi`                   | Terminal | Interface complète                                 |
| `Ctrl+N`                 | Zsh      | Widget — insère la commande dans le buffer courant |
| `prefix + Ctrl+g`        | Tmux     | Split temporaire — colle dans le pane précédent    |
| `navi --query "<terme>"` | Terminal | Filtre direct sur un terme                         |

> Le widget tmux fonctionne dans **n'importe quelle app** : vim, psql, SSH...

## Sélection des variables

| Touche  | Effet                             |
|---------|-----------------------------------|
| `Tab`   | Utiliser la valeur tapée          |
| `Enter` | Utiliser la sélection de la liste |

## Fichiers de cheats

Chemin : `~/dev-setup/cheats/`

| Fichier                | Contenu                                       |
|------------------------|-----------------------------------------------|
| `git.cheat`            | branches, commits, diff, log, stash, reset    |
| `tools.cheat`          | eza, bat, rg, fd, zoxide, tmux, updates       |
| `docker.cheat`         | images, containers, volumes, networks, cleanup|
| `docker-compose.cheat` | up, down, logs, ps, build, exec               |
| `linux.cheat`          | processus, disque, réseau, perms, archives    |
| `ssh.cheat`            | connexions, clés, tunnels, config             |
| `curl.cheat`           | GET/POST, headers, auth, download             |
| `bun.cheat`            | install, run, dev, test, workspaces           |
| `npm.cheat`            | install, scripts, publish, audit              |
| `navi.cheat`           | lancement, édition, search, shell widget      |

## Syntaxe des `.cheat`

```text
% git, branch              ← tags (section)

# Créer une branche        ← description (affiché dans navi)
git checkout -b <branch>   ← commande avec variable

$ branch: git branch | awk '{print $NF}'   ← commande qui génère les choix
```

| Élément     | Syntaxe | Rôle                                   |
|-------------|---------|----------------------------------------|
| Tag         | `%`     | Début de section, catégories           |
| Description | `#`     | Titre affiché dans navi                |
| Métacom.    | `;`     | Ignoré par navi (commentaire éditeur)  |
| Variable    | `$`     | Commande pour générer les valeurs      |
| Extends     | `@`     | Hérite les variables d'une autre section|

### Astuce — options avancées sur les variables

```text
$ var: <commande> --- --preview 'bat {}' --preview-window right:60%
                  --- --column 1 --header-lines 1 --delimiter '\s\s+'
                  --- --multi --expand    ← sélection multiple
```

## Config (`~/.config/navi/config.yaml`)

```yaml
cheats:
  paths:
    - ~/dev-setup/cheats

style:
  tag:     { color: cyan,   width_percentage: 20 }
  comment: { color: yellow, width_percentage: 42 }
  snippet: { color: green,  width_percentage: 38 }

finder:
  overrides_var: "--height 50% --layout=reverse --border"

shell:
  command: zsh          # important — sinon bash par défaut
  finder_command: zsh
```

## Neovim — Syntax highlighting `.cheat`

Fichiers créés dans `~/.config/nvim/` :

- `ftdetect/cheat.vim` — détecte l'extension `.cheat`
- `syntax/cheat.vim` — coloration par highlight groups

| Élément         | Highlight group | Couleur typique |
|-----------------|-----------------|-----------------|
| `%` tags        | `Statement`     | Jaune/orange    |
| `#` desc.       | `Operator`      | Cyan            |
| `;` métacom.    | `Comment`       | Gris            |
| `$` vars        | `Type`          | Vert            |
| `@` extends    | `PreProc`       | Mauve           |
| `<placeholder>` | `String`        | Rouge/vert      |
