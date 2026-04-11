# Outils CLI

## lazygit — TUI Git (`lg`)
| Touche          | Effet                                    |
|-----------------|------------------------------------------|
| `↑ / ↓`         | naviguer                                 |
| `Space`         | stager / unstager un fichier             |
| `a`             | stager tous les fichiers                 |
| `c`             | commit                                   |
| `p`             | push                                     |
| `P`             | pull                                     |
| `b`             | aller dans le panel branches             |
| `n`             | nouvelle branche                         |
| `Enter`         | voir le diff d'un fichier                |
| `?`             | aide contextuelle                        |
| `q`             | quitter                                  |

Panels : Files | Branches | Commits | Stash — naviguer avec `←` / `→` ou `1-5`.

---

## eza — ls amélioré
| Commande              | Effet                                    |
|-----------------------|------------------------------------------|
| `l`                   | liste avec icônes + statut git           |
| `ll`                  | liste longue avec fichiers cachés        |
| `tree`                | arborescence avec icônes                 |
| `eza --git-ignore`    | ignorer les fichiers du .gitignore       |
| `eza -l --sort=modified` | trier par date de modification        |

---

## bat — cat amélioré (`cat`)
| Commande                      | Effet                          |
|-------------------------------|--------------------------------|
| `cat <fichier>`               | afficher avec syntax highlight |
| `cat <fichier> -n`            | avec numéros de ligne          |
| `cat <fichier> --plain`       | sans décorations               |
| `bat --list-themes`           | voir les thèmes disponibles    |

S'intègre avec fzf pour les previews automatiquement.

---

## fzf — Fuzzy finder
| Raccourci    | Effet                                         |
|--------------|-----------------------------------------------|
| `Ctrl+T`     | chercher fichier, insérer le chemin           |
| `Ctrl+R`     | chercher dans l'historique de commandes       |
| `Alt+C`      | fuzzy cd dans un sous-dossier                 |
| `Tab`        | (fzf-tab) complétion fuzzy sur n'importe quoi |

Dans l'interface fzf :
| Touche       | Effet                   |
|--------------|-------------------------|
| `↑ / ↓`      | naviguer                |
| `Tab`        | sélection multiple      |
| `Enter`      | valider                 |
| `Ctrl+C`     | annuler                 |

---

## zoxide — cd intelligent (`z`)
| Commande         | Effet                                         |
|------------------|-----------------------------------------------|
| `z <nom>`        | sauter vers le dossier le plus fréquent       |
| `z <partiel>`    | fonctionne avec un sous-dossier partiel       |
| `zi`             | mode interactif via fzf                       |
| `z -`            | dossier précédent                             |
| `zoxide query -l`| voir tous les dossiers enregistrés            |

zoxide apprend automatiquement depuis tes `cd` habituels.

---

## delta — diff git
S'active automatiquement dans `git diff`, `git log -p`, `git show`.

| Commande                    | Effet                              |
|-----------------------------|------------------------------------|
| `git diff`                  | diff avec syntax highlighting      |
| `git log --patch`           | historique avec diff inline        |
| `git show <hash>`           | voir un commit formaté             |
