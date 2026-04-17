# Dive — explorateur d'images Docker

TUI pour inspecter les layers d'une image Docker, repérer les fichiers qui gonflent l'image et auditer l'efficacité d'un build.
Binaire : `/usr/bin/dive` (v0.13.1), config : `~/.dive.yaml`.

## Sommaire

- [Lancement](#lancement)
- [Navigation](#navigation)
- [Raccourcis filtres](#raccourcis-filtres)
- [Mode CI](#mode-ci)
- [Config `~/.dive.yaml`](#config-divedayaml)
- [Patterns communs](#patterns-communs)

---

## Lancement

| Commande                           | Effet                                              |
|------------------------------------|----------------------------------------------------|
| `dive <image>`                     | Ouvrir une image locale (tag ou ID)                |
| `dive <image>:<tag>`               | Version explicite                                  |
| `dive build -t <name> .`           | Build + analyse en une passe (wrapper `docker build`) |
| `dive --source podman <image>`     | Utiliser podman au lieu de docker                  |
| `dive --source docker-archive <tar>` | Analyser un `.tar` (pas de daemon requis)        |
| `Ctrl+C`                           | Quitter                                            |

---

## Navigation

| Touche                    | Effet                                                  |
|---------------------------|--------------------------------------------------------|
| `Tab` / `Ctrl+Space`      | Basculer entre panel **Layers** (gauche) et **Filetree** (droite) |
| `↑` / `↓` / `j` / `k`     | Naviguer dans la liste                                 |
| `PageUp` / `PageDown`     | Scroll rapide                                          |
| `Space`                   | Déplier / replier un dossier (filetree)                |
| `Ctrl+L`                  | Toggle : changements de la layer courante ↔ agrégés    |
| `Ctrl+F`                  | Filtrer les fichiers par regex                         |
| `Ctrl+/`                  | Reset du filtre                                        |

> Panel **Layers** : sélectionner une layer fige la vue droite sur son contenu / diff.
> Panel **Filetree** : colonne de gauche = type de changement (`A`dded, `M`odified, `R`emoved, ` ` unchanged).

---

## Raccourcis filtres

Dans le panel filetree, basculer l'affichage par type de changement :

| Touche    | Effet                                 |
|-----------|---------------------------------------|
| `Ctrl+A`  | Toggle fichiers **Added**             |
| `Ctrl+R`  | Toggle fichiers **Removed**           |
| `Ctrl+M`  | Toggle fichiers **Modified**          |
| `Ctrl+U`  | Toggle fichiers **Unmodified**        |
| `Ctrl+B`  | Toggle les attributs (perms / taille) |

### Astuce

Avec `diff.hide: [unmodified]` dans `~/.dive.yaml`, les non-modifiés sont cachés par défaut — repère instantané des changements par layer. `Ctrl+U` les réaffiche temporairement.

---

## Mode CI

Analyse non-interactive pour intégration CI — exit code non nul si l'image dépasse les seuils.

```bash
CI=true dive <image>
```

| Flag                             | Effet                                                 |
|----------------------------------|-------------------------------------------------------|
| `--ci`                           | Force le mode CI (équivalent à `CI=true`)             |
| `--ci-config .dive-ci`           | Règles YAML pour les seuils                           |
| `--lowestEfficiency 0.95`        | Efficacité min (ratio 0-1, défaut 0.9)                |
| `--highestWastedBytes 20MB`      | Bytes gaspillés max                                   |
| `--highestUserWastedPercent 0.1` | % max de bytes gaspillés                              |
| `-j out.json`                    | Export JSON de l'analyse (skip TUI)                   |

Exemple `.dive-ci` :

```yaml
rules:
  lowestEfficiency: 0.95
  highestWastedBytes: 20MB
  highestUserWastedPercent: 0.10
```

---

## Config `~/.dive.yaml`

Fichier actif sur cette machine, copie de référence dans `~/dev-setup/config/.dive.yaml`.

```yaml
container-engine: docker

filetree:
  collapse-dir: false       # dossiers ouverts par défaut
  pane-width: 0.5           # largeur panel filetree (0-1)
  show-attributes: true     # perms + taille visibles

layer:
  show-aggregated-changes: false  # changements de la layer courante

diff:
  hide:
    - unmodified            # focus sur ce qui a changé
```

> Chemins cherchés par ordre : `$HOME/.dive.yaml` → `~/.config/dive/*.yaml` → `$XDG_CONFIG_HOME/dive.yaml`.
> Override ponctuel : `dive --config <path> <image>`.

---

## Patterns communs

### Auditer une image qui pèse trop lourd

```bash
dive myapp:latest
```
1. Panel Layers : repère la layer la plus grosse (colonne `Size`).
2. `Tab` vers filetree, `Ctrl+U` caché → seuls les ajouts/modifs visibles.
3. `Ctrl+L` pour voir le cumulatif et identifier les fichiers redondants entre layers.

### Comparer avant / après optimisation

```bash
dive myapp:before
dive myapp:after
```
Note `efficiency score` (en haut à droite) et `wasted space` pour mesurer le gain.

### Build + analyse en CI

```bash
CI=true dive build -t myapp:ci . --ci-config .dive-ci
```

### Analyser une image distante sans docker daemon

```bash
docker save myapp:latest -o myapp.tar
dive --source docker-archive myapp.tar
```

---

Liens :
- [navi cheat](../cheats/dive.cheat) — `navi` sur `dive` pour les commandes fréquentes
- [tools.md](./tools.md) — autres outils CLI
