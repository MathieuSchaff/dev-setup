# Lazygit — TUI Git

Configuré dans `~/.config/lazygit/config.yml` (pager : delta `--paging=never`, éditeur : nvim).
Lancé via `lg` (smart exit) ou `Ctrl+g` en popup tmux.

## Sommaire

- [Lancement](#lancement)
- [Navigation globale](#navigation-globale)
- [Undo / Redo](#undo--redo)
- [Panel Files (1)](#panel-files-1)
- [Panel Branches (2)](#panel-branches-2)
- [Panel Commits (3)](#panel-commits-3)
- [Cherry-pick](#cherry-pick)
- [Patching (sélection par lignes)](#patching-sélection-par-lignes)
- [Résolution de conflits](#résolution-de-conflits)
- [Panel Stash (4)](#panel-stash-4)
- [Vue diff (panel droit)](#vue-diff-panel-droit)
- [Couleurs des commits](#couleurs-des-commits)
- [Intégration gh](#intégration-gh-github-cli)
- [Patterns communs](#patterns-communs)
- [Config active](#config-active)

---

## Lancement

| Commande | Effet                                                 |
|----------|-------------------------------------------------------|
| `lg`     | Ouvrir lazygit (terminal suit le dossier à la sortie) |
| `Ctrl+g` | Ouvrir en **popup tmux** flottant (90×90%)            |
| `q`      | Quitter / fermer le popup                             |
| `?`      | Aide contextuelle (panel actif)                       |

---

## Navigation globale

| Touche    | Effet                                                       |
|-----------|-------------------------------------------------------------|
| `1` à `5` | Panel : Files / Branches / Commits / Stash / Reflog         |
| `h` / `l` | Panel précédent / suivant                                   |
| `←` / `→` | Panel précédent / suivant                                   |
| `j` / `k` | Naviguer dans la liste                                      |
| `↑` / `↓` | Naviguer dans la liste                                      |
| `[` / `]` | Tab précédente / suivante (dans un panel)                   |
| `/`       | Filtrer la liste courante                                   |
| `Ctrl+r`  | Changer de repo récent                                      |
| `x`       | Menu des actions disponibles                                |
| `+` / `_` | Agrandir / réduire le panel diff                            |

---

## Undo / Redo

| Touche    | Effet                                              |
|-----------|----------------------------------------------------|
| `z`       | **Undo** — annule la dernière action (via reflog)  |
| `Shift+Z` | **Redo** — rejoue l'action annulée                 |

> Fonctionne pour les drops de commits, rebases ratés, resets...
> Lazygit utilise le reflog en arrière-plan.

---

## Panel Files (1)

| Touche    | Effet                                                       |
|-----------|-------------------------------------------------------------|
| `Space`   | Stager / unstager un fichier                                |
| `a`       | Stager / unstager tous les fichiers                         |
| `Enter`   | Voir le diff du fichier                                     |
| `c`       | Commit                                                      |
| `C`       | Commit avec message dans nvim                               |
| `A`       | Amend le **dernier** commit                                 |
| `d`       | Discard les changements du fichier                          |
| `Shift+D` | **Nuke** — supprime tout le `git status` (untracked inclus) |
| `i`       | Ignorer le fichier (ajouter au `.gitignore`)                |
| `e`       | Ouvrir le fichier dans nvim                                 |
| `t`       | Mode patch — stager des lignes précises                     |

---

## Panel Branches (2)

| Touche    | Effet                                                  |
|-----------|--------------------------------------------------------|
| `Space`   | Checkout la branche                                    |
| `n`       | Nouvelle branche                                       |
| `d`       | Supprimer la branche                                   |
| `r`       | Rebase la branche courante sur celle-ci                |
| `M`       | Merger dans la branche courante                        |
| `f`       | Fast-forward                                           |
| `p`       | Pull                                                   |
| `P`       | Push                                                   |
| `g`       | Reset vers ce commit (soft / mixed / hard)             |
| `i`       | Menu **Git Flow** (si git-flow installé)               |
| `Shift+B` | Marquer comme base de rebase                           |
| `Shift+G` | Ouvrir la PR dans le navigateur (nécessite `gh`)       |
| `Enter`   | Voir les commits de la branche                         |

---

## Panel Commits (3)

| Touche     | Effet                                                |
|------------|------------------------------------------------------|
| `Space`    | Checkout le commit                                   |
| `Enter`    | Voir les fichiers modifiés                           |
| `r`        | Renommer le message (reword)                         |
| `R`        | Renommer dans nvim                                   |
| `d`        | Supprimer le commit                                  |
| `f`        | Fixup (squash sans message)                          |
| `s`        | Squash avec le commit précédent                      |
| `e`        | Éditer le commit (rebase interactif)                 |
| `Shift+A`  | **Amender un vieux commit** avec les fichiers stagés |
| `Ctrl+j/k` | Déplacer le commit vers le bas / haut                |
| `b`        | **Bisect** — trouver le commit qui a introduit un bug|
| `Shift+W`  | Marquer pour comparaison (diff entre deux commits)   |
| `W`        | Voir le diff entre ce commit et le marqueur          |
| `c`        | Copier le hash                                       |
| `z`        | Undo                                                 |

### Astuce — `Shift+A` workflow

Stage tes modifs dans Files → va dans Commits → sélectionne n'importe quel vieux commit →
appuie `Shift+A`. Lazygit fait le rebase interactif en arrière-plan.

---

## Cherry-pick

Système de "buffer" : marquer des commits dans une branche, les coller dans une autre.

| Touche  | Effet                                              |
|---------|----------------------------------------------------|
| `C`     | Marquer le commit pour cherry-pick (dans Commits)  |
| `V`     | Coller les commits marqués sur la branche courante |
| `Esc`   | Annuler la sélection                               |

> Workflow : branche source → `C` sur chaque commit voulu → branche cible → `V`.

---

## Patching (sélection par lignes)

Stager / extraire / supprimer des **lignes précises** plutôt qu'un fichier entier.

| Touche   | Effet                                                  |
|----------|--------------------------------------------------------|
| `Enter`  | Entrer dans un fichier (vue diff des lignes)           |
| `Space`  | Sélectionner / désélectionner une ligne ou un hunk     |
| `Ctrl+p` | Menu patch — extraire vers nouveau commit, reset, etc. |
| `t`      | Mode patch depuis le panel Files                       |

> Workflow : Files → `Enter` sur un fichier → `Space` sur les lignes → `Ctrl+p`.

---

## Résolution de conflits

Lazygit met en évidence les conflits après un rebase ou un merge.

| Touche  | Effet                                                  |
|---------|--------------------------------------------------------|
| `Enter` | Ouvrir le fichier en conflit                           |
| `Space` | Choisir "notre" ou "leur" version sur un conflit       |
| `b`     | Prendre les deux versions                              |
| `z`     | Undo si mauvais choix                                  |

> Après résolution, lazygit propose automatiquement de continuer (`c`).
> Lors d'un checkout avec des modifs en cours, lazygit propose de stasher automatiquement.

---

## Panel Stash (4)

| Touche  | Effet                                |
|---------|--------------------------------------|
| `Space` | Appliquer le stash                   |
| `g`     | Pop le stash (appliquer + supprimer) |
| `d`     | Supprimer le stash                   |
| `n`     | Nouveau stash                        |
| `Enter` | Voir le contenu du stash             |

---

## Vue diff (panel droit)

| Touche    | Effet                                   |
|-----------|-----------------------------------------|
| `↑` / `↓` | Scroller le diff                        |
| `[` / `]` | Fichier précédent / suivant             |
| `Space`   | Stage / unstage le hunk sous le curseur |
| `d`       | Supprimer le hunk                       |
| `e`       | Ouvrir dans nvim                        |

> Les diffs sont rendus par **delta** (`--paging=never`, thème sombre).
> Dans le terminal classique, `n`/`N` naviguent entre les hunks — voir
> [tools.md](./tools.md#pager-less--touches-communes).

---

## Couleurs des commits

| Couleur | Signification                                  |
|---------|------------------------------------------------|
| Vert    | Commit inclus dans `main` / `master`           |
| Jaune   | Commit **non** inclus dans la branche principale|
| Rouge   | Commit local, pas encore pushé                 |

---

## Intégration gh (GitHub CLI)

Si `gh` est installé, lazygit affiche une icône sur les branches avec une PR.
`Shift+G` dans le panel Branches → ouvre la PR dans le navigateur.

---

## Patterns communs

| Objectif                        | Séquence                                          |
|---------------------------------|---------------------------------------------------|
| Stage + commit + push           | `Space` → `c` → titre → `P`                       |
| Stage + amend dernier + push    | `Space` → `A` → `P`                               |
| Amender un vieux commit         | stage dans Files → Commits → `Shift+A`            |
| Supprimer un vieux commit       | Commits → `d`                                     |
| Rebase interactif               | Commits → réordonner avec `Ctrl+j/k` → `m` → `c`  |
| Cherry-pick depuis autre branche| Commits source → `C` → branche cible → `V`        |
| Stager des lignes précises      | Files → `Enter` → `Space` → `Ctrl+p`              |
| Annuler une action ratée        | `z`                                               |

---

## Config active

| Fichier                        | Paramètre                     |
|--------------------------------|-------------------------------|
| `~/.config/lazygit/config.yml` | Pager : delta, éditeur : nvim |
| `~/.gitconfig`                 | delta side-by-side, navigate  |
