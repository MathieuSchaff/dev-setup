# ctop — top-like pour conteneurs

TUI temps réel pour monitorer les conteneurs Docker : CPU, mémoire, I/O, réseau, logs, exec shell.
Binaire : `/usr/local/bin/ctop` (v0.7.7), config : `~/.config/ctop/config` (XDG) ou `~/.ctop`.

## Sommaire

- [Lancement](#lancement)
- [Navigation](#navigation)
- [Menu conteneur (`Enter`)](#menu-conteneur-enter)
- [Single view](#single-view)
- [Filtrage et tri](#filtrage-et-tri)
- [Config](#config)
- [Patterns communs](#patterns-communs)

---

## Lancement

| Commande      | Effet                                                              |
|---------------|--------------------------------------------------------------------|
| `ctop`        | Lance le TUI (utilise les variables d'env Docker par défaut)       |
| `ctop -a`     | N'affiche **que** les conteneurs actifs                            |
| `ctop -f web` | Démarre avec un filtre initial (`web` ici)                         |
| `ctop -s cpu` | Sélectionne le champ de tri initial (`cpu`, `mem`, `name`, ...)    |
| `ctop -r`     | Inverse l'ordre de tri                                             |
| `ctop -i`     | Inverse les couleurs par défaut (meilleure lisibilité sur certains thèmes) |
| `ctop -h`     | Help dialog                                                        |
| `ctop -v`     | Version                                                            |
| `q`           | Quitter                                                            |

> Sans arguments, ctop lit `DOCKER_HOST` / `DOCKER_API_VERSION` comme le client docker.
> Pour un daemon distant : `DOCKER_HOST=ssh://user@host ctop`.

---

## Navigation

| Touche     | Effet                                                   |
|------------|---------------------------------------------------------|
| `↑` / `↓`  | Sélectionner un conteneur                               |
| `j` / `k`  | Idem (vi-style)                                         |
| `Enter`    | Ouvrir le menu du conteneur sélectionné                 |
| `a`        | Toggle affichage **all containers** (running + stopped) |
| `H`        | Toggle le header (CPU/MEM/NET global en haut)           |
| `h`        | Help dialog                                             |
| `q`        | Quitter                                                 |

---

## Menu conteneur (`Enter`)

Une fois un conteneur sélectionné, `Enter` ouvre un menu contextuel :

| Action           | Effet                                                  |
|------------------|--------------------------------------------------------|
| **single view**  | Vue détaillée (graphs CPU/MEM/NET/IO + infos)          |
| **logs**         | Stream les logs (`t` pour toggle timestamps)           |
| **exec shell**   | Ouvre un shell dans le conteneur (`sh` / `bash`)       |
| **stop / start / pause / unpause / restart** | Contrôle du cycle de vie    |
| **remove**       | Supprime le conteneur (nécessite qu'il soit stoppé)    |

Raccourcis directs (depuis la liste) :

| Touche | Effet                      |
|--------|----------------------------|
| `l`    | View container logs        |
| `o`    | Open single view           |
| `e`    | Exec shell                 |
| `c`    | Configure columns          |

### Piège

`e` (exec shell) utilise `/bin/sh` par défaut. Sur une image `alpine` ou `distroless` sans shell, la commande échoue silencieusement — utilise `docker exec -it <id> <binaire>` à la place.

---

## Single view

Vue détaillée d'un conteneur avec graphs animés.

| Touche     | Effet                                      |
|------------|--------------------------------------------|
| `Esc` / `q`| Revenir à la liste                         |
| `l`        | Ouvrir les logs                            |
| `e`        | Exec shell                                 |

Affiche : nom, image, status, ports, IP, uptime, graphs CPU/MEM/NET RX-TX/IO R-W, et les env vars / labels.

---

## Filtrage et tri

| Touche | Effet                                                               |
|--------|---------------------------------------------------------------------|
| `f`    | Filtrer les conteneurs affichés (tape un pattern, `Enter` valide)   |
| `Esc`  | Clear le filtre quand le champ est ouvert                           |
| `s`    | Sélectionner le champ de tri (cycle : name, cpu, mem, io, ...)      |
| `r`    | Inverse l'ordre de tri                                              |
| `c`    | Configure columns — choisir quelles colonnes afficher               |
| `S`    | **Save** la config courante (filtre + tri + colonnes) vers le fichier config |

### Astuce

`f` supporte un match partiel sur le **nom**. Pour filtrer par image ou label, passe par `docker ps --filter` et lance `ctop` ensuite, ou utilise `-f` au démarrage.

---

## Config

ctop n'a pas de config YAML — le fichier est écrit par `S` en cours de session.

| Chemin cherché (dans l'ordre)    | Notes                                 |
|----------------------------------|---------------------------------------|
| `$XDG_CONFIG_HOME/ctop/config`   | Défaut XDG                            |
| `~/.config/ctop/config`          | Sur WSL/Ubuntu classique              |
| `~/.ctop`                        | Fallback legacy                       |

Persistent au redémarrage : filtres, champ de tri, ordre, colonnes visibles, invert colors.

> Pour reset : supprime le fichier config et relance ctop.

---

## Patterns communs

### Surveiller les conteneurs d'une stack

```bash
ctop -a -s cpu
```
`-a` pour voir aussi les `exited` (debug de restart loops), `-s cpu` pour trier par CPU.

### Debug rapide d'un conteneur

1. `ctop` → `f` → tape le nom → `Enter`
2. `l` pour les logs, `t` pour les timestamps
3. `Esc` puis `e` pour un shell dans le conteneur

### Monitorer un daemon Docker distant

```bash
DOCKER_HOST=ssh://user@server ctop
```
Clé SSH chargée dans l'agent, accès Docker côté serveur requis.

### Comparer avec d'autres outils

| Outil          | Niveau     | Interactif | Cycle de vie | Exec shell |
|----------------|------------|------------|--------------|------------|
| `docker stats` | CLI brut   | Non        | Non          | Non        |
| **ctop**       | TUI léger  | Oui        | Oui          | Oui        |
| `lazydocker`   | TUI riche  | Oui        | Oui          | Oui        |

> `lazydocker` est plus complet (images, volumes, networks) ; `ctop` est plus rapide à lancer et focalisé sur les conteneurs live.

---

Liens :
- [dive.md](./dive.md) — explorateur d'images Docker (layers, efficiency)
- [update-tools.md](./update-tools.md) — mise à jour du binaire ctop hors apt
- [tools.md](./tools.md) — autres outils CLI
