# Vi-mode ZSH

Tu es en mode INSERT par défaut. `Esc` bascule en mode NORMAL.

## Mode NORMAL — Navigation

| Touche  | Effet                            |
|---------|----------------------------------|
| `h` `l` | ← / → caractère                  |
| `w` `b` | mot suivant / précédent          |
| `0` `$` | début / fin de ligne             |
| `^`     | premier caractère non-espace     |

## Mode NORMAL — Édition

| Touche | Effet                            |
|--------|----------------------------------|
| `x`    | supprimer caractère sous curseur |
| `dw`   | supprimer mot                    |
| `d$`   | supprimer jusqu'à fin de ligne   |
| `D`    | idem                             |
| `dd`   | vider toute la ligne             |
| `cw`   | changer mot (repasse en INSERT)  |
| `C`    | changer jusqu'à fin de ligne     |
| `r<c>` | remplacer caractère par `<c>`    |
| `u`    | annuler                          |

## Mode NORMAL — Historique

| Touche  | Effet                          |
|---------|--------------------------------|
| `k` `j` | commande précédente / suivante |
| `/`     | chercher dans l'historique     |
| `n` `N` | résultat suivant / précédent   |

## Revenir en INSERT

| Touche | Effet         |
|--------|---------------|
| `i`    | avant curseur |
| `a`    | après curseur |
| `I`    | début de ligne|
| `A`    | fin de ligne  |

### Astuce — forme du curseur

Le curseur change de forme : rectangle = NORMAL, barre = INSERT.
