# LazyDocker — TUI Docker / Compose

Interface terminal pour gérer conteneurs, images, volumes, réseaux et services Compose sans retenir les commandes `docker`. Même auteur que Lazygit (Jesse Duffield).
Binaire : `~/.local/bin/lazydocker` (v0.25.0), config : `~/.config/lazydocker/config.yml`.

## Sommaire

- [Lancement](#lancement)
- [Panneaux et navigation](#panneaux-et-navigation)
- [Onglets du panneau droit](#onglets-du-panneau-droit)
- [Actions sur les conteneurs](#actions-sur-les-conteneurs)
- [Actions sur les images](#actions-sur-les-images)
- [Volumes et réseaux](#volumes-et-réseaux)
- [Config `~/.config/lazydocker/config.yml`](#config-configlazydockerconfigyml)
- [Commandes personnalisées](#commandes-personnalisées)
- [Patterns communs](#patterns-communs)
- [Dépannage](#dépannage)

---

## Lancement

| Commande                        | Effet                                                            |
|---------------------------------|------------------------------------------------------------------|
| `lzd` *(alias)*                 | Raccourci zsh vers `lazydocker`                                  |
| `lazydocker`                    | Lance le TUI (détecte `docker-compose.yml` dans le dossier courant) |
| `lazydocker -f docker-compose.prod.yml` | Spécifie un fichier Compose                              |
| `lazydocker -p <project>`       | Forcer le nom de projet Compose                                  |
| `lazydocker -c`                 | Affiche la config par défaut sur stdout (utile pour bootstrap)   |
| `lazydocker -d`                 | Mode debug                                                       |
| `lazydocker --version`          | Version                                                          |
| `q`                             | Quitter                                                          |

> L'alias `lzd` est défini dans `~/.zshrc` — voir [zsh.md](./zsh.md#aliases-docker).

---

## Panneaux et navigation

| Panneau       | Contenu                        | Raccourci direct |
|---------------|--------------------------------|------------------|
| **Project**   | Services Docker Compose        | `1`              |
| **Containers**| Conteneurs (running + stopped) | `2`              |
| **Images**    | Images locales                 | `3`              |
| **Volumes**   | Volumes Docker                 | `4`              |
| **Networks**  | Réseaux Docker                 | `5`              |

| Touche           | Effet                                          |
|------------------|------------------------------------------------|
| `Tab` / `← →`    | Panneau suivant / précédent                    |
| `1`–`5`          | Saut direct au panneau (depuis v0.24.2)        |
| `↑ ↓` / `j k`    | Naviguer dans la liste du panneau actif        |
| `Enter`          | Détails / inspect                              |
| `x`              | Menu d'actions du panneau courant              |
| `/`              | Filtrer la liste                               |
| `[` / `]`        | Onglet précédent / suivant dans le panneau droit |
| `?`              | Afficher les keybindings du panneau actif      |
| `+` / `-`        | Agrandir / réduire le panneau courant          |
| `_`              | Toggle fullscreen du panneau courant           |
| `q`              | Quitter                                        |

### Astuce

`?` est contextuel : il ne liste que les touches du panneau où tu es — bien plus utile que de chercher dans la doc.

---

## Onglets du panneau droit

Le panneau droit change selon le panneau actif. Bascule avec `[` / `]`.

### Containers / Project

| Onglet    | Contenu                                              |
|-----------|------------------------------------------------------|
| **Logs**  | Logs en temps réel (suivent `logs.tail` et `logs.since` de la config) |
| **Stats** | CPU %, RAM, I/O réseau, I/O disque                   |
| **Env**   | Variables d'environnement                            |
| **Config**| Inspect complet au format YAML                       |
| **Top**   | Processus dans le conteneur (équiv. `docker top`)    |

### Images

| Onglet      | Contenu                                |
|-------------|----------------------------------------|
| **Config**  | Inspect de l'image (YAML)              |

### Piège

Dans l'onglet **Logs**, si rien ne s'affiche : l'app écrit probablement sur un fichier au lieu de `stdout`/`stderr`. Docker ne capture que ces deux flux.

---

## Actions sur les conteneurs

Sur un conteneur sélectionné, `x` ouvre un menu ; raccourcis directs aussi disponibles :

| Touche | Action          | Équivalent CLI                |
|--------|-----------------|-------------------------------|
| `s`    | Stop            | `docker stop`                 |
| `r`    | Restart         | `docker restart`              |
| `p`    | Pause / unpause | `docker pause` / `unpause`    |
| `d`    | Remove          | `docker rm`                   |
| `a`    | Attach          | `docker attach`               |
| `E`    | Exec shell      | `docker exec -it ... /bin/sh` |
| `m`    | View logs (pager) | `docker logs`               |
| `R`    | Menu restart    | (options avancées)            |

> Les actions destructives (`d`) demandent confirmation.

### Piège

`E` exec `sh` par défaut. Sur une image `distroless` ou sans shell, utilise un `customCommand` pour pointer vers le binaire disponible (`busybox`, `ash`, ...).

---

## Actions sur les images

| Touche | Action         | Équivalent CLI         |
|--------|----------------|------------------------|
| `d`    | Remove         | `docker rmi`           |
| `D`    | Prune unused   | `docker image prune`   |
| `c`    | Run            | `docker run`           |
| `P`    | Push           | `docker push`          |

---

## Volumes et réseaux

| Panneau  | Touche | Action         | Équivalent CLI             |
|----------|--------|----------------|----------------------------|
| Volumes  | `d`    | Remove         | `docker volume rm`         |
| Volumes  | `D`    | Prune          | `docker volume prune`      |
| Networks | `d`    | Remove         | `docker network rm`        |
| Networks | `D`    | Prune          | `docker network prune`     |
| Tous     | `Enter`| Inspect YAML   | `docker ... inspect`       |

---

## Config `~/.config/lazydocker/config.yml`

Fichier vide par défaut sur cette machine — override partiel possible. Pour partir du défaut complet : `lazydocker -c > ~/.config/lazydocker/config.yml`.

```yaml
gui:
  language: 'fr'                # auto, en, fr, de, es, pl, nl, tr, zh
  screenMode: normal            # normal, half, fullscreen
  containerStatusHealthStyle: short  # long, short, icon
  border: rounded               # single, double, rounded, hidden
  theme:
    activeBorderColor: [green, bold]
    selectedLineBgColor: [blue]

logs:
  timestamps: true
  since: '60m'                  # '' pour tous les logs (coûteux)
  tail: '200'

commandTemplates:
  dockerCompose: docker compose  # v1 `docker-compose` → v2 `docker compose`
```

> Depuis v0.24, `docker compose` (sans tiret) est le défaut — pas besoin de l'override si Docker ≥ 20.10.
> Chemins : Linux `~/.config/lazydocker/config.yml`, macOS `~/Library/Application Support/jesseduffield/lazydocker/config.yml`, Windows `%APPDATA%\jesseduffield\lazydocker\config.yml`.

### Astuce

Edite la config avec Neovim et l'extension YAML LSP (ou VS Code / Zed + Red Hat YAML) — le schéma JSON publié par le projet donne l'autocomplétion sur toutes les options.

---

## Commandes personnalisées

Ajoute des actions accessibles via `X` (custom command menu) dans `config.yml` :

```yaml
customCommands:
  containers:
    - name: bash
      attach: true
      command: 'docker exec -it {{ .Container.ID }} bash'
    - name: env
      attach: false
      command: 'docker exec {{ .Container.ID }} env'
    - name: disk usage
      attach: false
      command: 'docker exec {{ .Container.ID }} du -sh /'
  images:
    - name: history
      attach: false
      command: 'docker history {{ .Image.ID }}'
    - name: dive
      attach: true
      command: 'dive {{ .Image.ID }}'
  services:
    - name: recreate
      attach: false
      command: '{{ .DockerCompose }} up -d --force-recreate {{ .Service.Name }}'
```

| Variable              | Description                        |
|-----------------------|------------------------------------|
| `{{ .Container.ID }}` | ID du conteneur sélectionné        |
| `{{ .Container.Name }}` | Nom du conteneur                 |
| `{{ .Image.ID }}`     | ID de l'image                      |
| `{{ .Image.Name }}`   | Nom (repo:tag)                     |
| `{{ .Service.Name }}` | Nom du service Compose             |
| `{{ .DockerCompose }}`| Commande compose (selon `commandTemplates`) |

> `attach: true` → lazydocker quitte le TUI pendant la commande (interactif, comme pour un shell). `attach: false` → exécute en arrière-plan, pratique pour récupérer de l'info.

---

## Patterns communs

### Debug rapide d'une stack Compose

```bash
cd mon-projet/
lazydocker
```
`1` pour le panneau Project → sélectionner un service → `[` / `]` pour naviguer Logs / Stats / Top.

### Supprimer images / volumes / networks orphelins

1. `3` → `D` — prune images
2. `4` → `D` — prune volumes
3. `5` → `D` — prune networks

Équivalent d'un `docker system prune` ciblé, avec confirmation par étape.

### Chaîner avec dive

Via `customCommand` (section `images`) : sélectionner une image, `X`, choisir `dive` → ouvre [`dive`](./dive.md) sur l'image sans quitter le workflow.

### Compose custom file

```bash
lazydocker -f compose/staging.yml -p staging
```

---

## Dépannage

| Problème                        | Cause                               | Solution                                      |
|---------------------------------|-------------------------------------|-----------------------------------------------|
| Compose non détecté             | Fichier `.yaml` au lieu de `.yml`   | Renommer, ou utiliser `-f`                    |
| Pas de logs                     | L'app écrit dans un fichier         | Rediriger vers stdout/stderr                  |
| `Cannot connect to Docker`      | Socket inaccessible                 | `sudo usermod -aG docker $USER` + relog, ou vérifier `DOCKER_HOST` |
| Stats à 0 %                     | Conteneur arrêté                    | `s` pour démarrer                             |
| Stats buggées en conteneur      | lazydocker dans un container        | Installer en natif sur l'hôte                 |
| `exec shell` échoue             | Pas de `sh` dans l'image            | Custom command avec le binaire disponible     |

---

Liens :
- [ctop.md](./ctop.md) — alternative focalisée sur le monitoring live des conteneurs
- [dive.md](./dive.md) — explorateur d'images Docker (layers, efficiency)
- [lazygit.md](./lazygit.md) — même philosophie, côté git
- [update-tools.md](./update-tools.md) — mise à jour du binaire lazydocker hors apt
