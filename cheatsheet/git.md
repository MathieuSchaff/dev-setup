# Git

Référence rapide pour la config git active + workflows.
Config : `~/.gitconfig` · Pager : **delta** (Catppuccin Macchiato) · Éditeur : **nvim**.

> Commandes exécutables avec variables → `navi` (`Ctrl+N` → tag `git`).
> TUI → `lg` (lazygit) — voir [lazygit.md](./lazygit.md).
> Touches du pager `less` (delta) → voir [tools.md](./tools.md#pager-less--touches-communes).
> Ce fichier couvre la **config active** et les **workflows** absents de navi/lazygit.

## Sommaire

- [Config active](#config-active)
- [Aliases zsh](#aliases-zsh)
- [Workflows typiques](#workflows-typiques)
- [Résolution de conflits (zdiff3)](#résolution-de-conflits-zdiff3)
- [Commandes utiles moins connues](#commandes-utiles-moins-connues)
- [Conventional Commits](#conventional-commits)
- [Pièges](#pièges)
- [Intégration avec l'écosystème](#intégration-avec-lécosystème)

---

## Config active

`~/.gitconfig` :

```ini
[core]
  editor = nvim
  pager  = delta

[interactive]
  diffFilter = delta --color-only

[delta]
  navigate       = true
  dark           = true
  side-by-side   = true
  line-numbers   = true
  hyperlinks     = true
  true-color     = always
  syntax-theme   = Catppuccin Macchiato

[merge]
  conflictStyle  = zdiff3

[diff]
  colorMoved     = default

[init]
  defaultBranch  = main
```

| Option                  | Effet                                                  |
|-------------------------|--------------------------------------------------------|
| `pager = delta`         | Tout output diff passe par delta                       |
| `navigate = true`       | `n`/`N` sautent au fichier suivant/précédent           |
| `side-by-side = true`   | Diffs côte-à-côte au lieu de l'unified                 |
| `line-numbers = true`   | Numéros dans les deux colonnes                         |
| `syntax-theme`          | Catppuccin Macchiato — cohérence avec tmux et Zed      |
| `hyperlinks = true`     | Liens cliquables dans certains terminaux               |
| `colorMoved = default`  | Lignes déplacées colorées différemment des +/-         |
| `conflictStyle = zdiff3`| Marqueurs avec ancêtre commun, plus clairs             |
| `defaultBranch = main`  | `git init` crée `main` au lieu de `master`             |

---

## Aliases zsh

Liste complète dans [zsh.md](./zsh.md). Résumé :

| Alias | Commande               |
|-------|------------------------|
| `g`   | `git`                  |
| `gs`  | `git status`           |
| `ga`  | `git add`              |
| `gc`  | `git commit`           |
| `gp`  | `git push`             |
| `gpl` | `git pull`             |
| `gco` | `git checkout`         |
| `gcb` | `git checkout -b`      |
| `gbr` | `git branch`           |
| `lg`  | `lazygit` (smart exit) |

---

## Workflows typiques

### Commit rapide

```sh
gs                  # voir l'état
ga <fichier>        # stager
gc -m "feat: ..."   # commit
gp                  # push
```

### Commit via lazygit

Plus rapide quand il y a beaucoup de fichiers.

```sh
lg
# dans lazygit : Space → c → message → P
```

### Amender le dernier commit (local, pas pushé)

```sh
ga <fichier_oublié>
git commit --amend --no-edit
```

### Amender un vieux commit

Utiliser **lazygit** : stage dans Files → Commits → `Shift+A` sur le commit cible.
Lazygit fait le rebase interactif en arrière-plan. Voir [lazygit.md](./lazygit.md#panel-commits-3).

### Rebase interactif (squash / reword / drop)

```sh
git rebase -i HEAD~5        # les 5 derniers commits
# dans nvim : remplacer "pick" par squash/reword/drop, sauver, fermer
```

Pendant un rebase :

```sh
git rebase --continue       # après résolution de conflits
git rebase --abort          # abandonner
git rebase --skip           # sauter un commit
```

### Récupérer un commit perdu

```sh
git reflog                  # toutes les opérations récentes
git checkout <reflog_hash>  # se placer sur le commit perdu
git branch recovery         # le sauver dans une branche
```

### Force push sécurisé

```sh
git push --force-with-lease # échoue si quelqu'un a pushé entre-temps
```

> Ne **jamais** `git push --force` sur une branche partagée.
> `--force-with-lease` vérifie que personne n'a pushé avant d'écraser.

### Worktrees (plusieurs branches en parallèle)

```sh
git worktree add ../feature-x feature-x  # checkout d'une branche existante
git worktree add -b new-branch ../new    # crée la branche + worktree
git worktree list                        # lister
git worktree remove ../feature-x         # supprimer (la branche reste)
```

> Très utile pour travailler sur plusieurs branches sans stash.

---

## Résolution de conflits (zdiff3)

Avec `conflictStyle = zdiff3`, les conflits affichent **3 sections** au lieu de 2 :

```diff
<<<<<<< HEAD
ta version
||||||| ancêtre commun
la version d'avant le split    ← AJOUT zdiff3
=======
leur version
>>>>>>> branche-x
```

L'ancêtre commun permet de comprendre **ce que chaque côté a modifié** par rapport à une base partagée.

### Outils de résolution

| Outil           | Quand l'utiliser                                       |
|-----------------|--------------------------------------------------------|
| nvim direct     | Petits conflits, tu maîtrises les marqueurs            |
| `lg`            | Tous les conflits d'un coup, sélection ligne par ligne |
| `git mergetool` | Si `merge.tool` configuré (pas chez toi)               |

Dans lazygit, après un rebase/merge avec conflits :

- `Enter` sur le fichier → choix interactif `our` / `their` / `both`
- `z` undo si mauvais choix
- Lazygit propose automatiquement `c` (continue) une fois résolu

---

## Commandes utiles moins connues

| Commande                           | Effet                                            |
|------------------------------------|--------------------------------------------------|
| `git blame <fichier>`              | Qui a modifié quelle ligne en dernier            |
| `git log -S"<texte>"`              | Commits qui ont **ajouté ou retiré** un texte    |
| `git log -L :<fonction>:<fichier>` | Historique d'une fonction spécifique             |
| `git log --follow <fichier>`       | Historique d'un fichier à travers les renames    |
| `git show :<fichier>`              | Contenu du fichier tel qu'il est **stagé**       |
| `git diff HEAD`                    | Diff depuis le dernier commit (staged + unstaged)|
| `git clean -fd`                    | Supprimer les fichiers non trackés (destructif)  |
| `git clean -fdn`                   | Dry run — voir ce qui serait supprimé            |
| `git stash --include-untracked`    | Stash incluant les nouveaux fichiers non trackés |
| `git bisect start/bad/good`        | Trouver le commit fautif par dichotomie          |

---

## Conventional Commits

Pas enforcé par git mais pratique pour un changelog automatique et un historique lisible.

```text
<type>(<scope>): <description courte>

[corps optionnel]

[footer optionnel]
```

| Type      | Usage                                       |
|-----------|---------------------------------------------|
| `feat`    | Nouvelle fonctionnalité                     |
| `fix`     | Bug fix                                     |
| `docs`    | Changement de doc uniquement                |
| `chore`   | Maintenance (deps, config, sync dotfiles…)  |
| `refactor`| Refactor sans changer le comportement       |
| `test`    | Ajout / modif de tests                      |
| `perf`    | Amélioration de performance                 |
| `style`   | Formatting, points-virgules, etc.           |
| `ci`      | Changement de config CI                     |
| `build`   | Build system, deps externes                 |
| `revert`  | Revert d'un commit précédent                |

> Exemples dans ce repo : `chore: sync nvim config — AstroNvim v6 migration`,
> `docs: add AstroNvim v6 migration design spec`.

---

## Pièges

### `git pull` par défaut fait un merge

Peut créer des commits de merge inutiles. Alternatives :

```sh
git pull --rebase                       # rebase local sur remote
git config --global pull.rebase true    # par défaut partout
```

### `git add .` colle tout

Préfère `git add -p` (patch mode) ou lazygit pour un contrôle fin.

### `git commit --amend` sur un commit pushé

Réécrit l'historique → force-push obligatoire. Ne jamais faire sur `main` partagée.

### Marqueurs de conflit oubliés

Si tu oublies un `>>>>>>>` et tu commites, git ne le détecte **pas** —
il ne crie que sur les `<<<<<<<` et `=======`.

### `git reset --hard`

Destructif pour les changements non commités. Toujours faire `git status` avant.

### Le reflog expire

~90 jours par défaut — pas un backup fiable à long terme.

### `git push --force` sur branche partagée

Écrase les commits des autres. Toujours utiliser `--force-with-lease`.

---

## Intégration avec l'écosystème

| Outil      | Rôle                                                            |
|------------|-----------------------------------------------------------------|
| `delta`    | Pager — colore et formate tous les diffs                        |
| `lazygit`  | TUI git — `lg` ou `Ctrl+g` (popup tmux)                         |
| `nvim`     | Éditeur par défaut pour commit messages et rebase interactif    |
| `navi`     | Cheats exécutables — tag `git` dans `Ctrl+N`                    |
| `gh`       | GitHub CLI (Windows-side) — lazygit `Shift+G` ouvre les PRs     |
