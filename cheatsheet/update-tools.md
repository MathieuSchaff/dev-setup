# update-tools — updater des CLI hors apt

Script : `~/dev-setup/scripts/update-tools.sh`
Alias dans `~/.zshrc` : `update-tools`

Met à jour les outils installés **manuellement** (téléchargement de binaire, `.deb` hors repo, script d'install) — ceux qu'aucun package manager ne suit.

## Outils couverts

| Outil        | Source              | Méthode d'update                                   |
|--------------|---------------------|----------------------------------------------------|
| `git`        | PPA `git-core/ppa`  | `sudo apt install git` (PPA auto-ajouté si absent) |
| `dive`       | `.deb` (GitHub)     | `sudo apt install ./dive_*.deb`                    |
| `lazygit`    | tar.gz (GitHub)     | extract + `install` dans `/usr/local/bin`          |
| `lazydocker` | script officiel     | `install_update_linux.sh` (self-update)            |
| `ctop`       | binaire direct      | `curl -o /usr/local/bin/ctop`                      |
| `neovim`     | tar.gz (GitHub)     | extract dans `/opt/nvim-linux-x86_64/`             |
| `fzf`        | git repo (`~/.fzf`) | `git pull` + `./install --bin`                     |

> Tous comparent la version locale à la dernière release GitHub avant d'agir.

## Ce qui n'est **pas** géré

| Type        | Comment update              |
|-------------|-----------------------------|
| Outils apt (`ripgrep`, `fd`, `glow`, `tmux`, `zsh`...)        | `sudo apt update && sudo apt upgrade` |
| Outils cargo (`delta`, `eza`, `bat`)                          | `cargo install-update -a` (après `cargo install cargo-update`) |
| Outils npm globaux (`gemini`, `@biomejs/biome`...)            | `npm update -g`               |
| Outils bun globaux                                            | `bun update -g`               |
| Python / uv / conda                                           | leur propre gestionnaire      |

## Utilisation

> Usage courant : `update tools` (via la commande unifiée — voir [zsh.md](./zsh.md#updates)).  
> Les options avancées ci-dessous sont accessibles via l'alias direct `update-tools`.

| Commande                       | Effet                                                   |
|--------------------------------|---------------------------------------------------------|
| `update tools`                 | Update tous les outils connus (via commande unifiée)    |
| `update-tools --check`         | Dry-run — affiche ce qui est outdated, rien n'est écrit |
| `update-tools dive lazygit`    | Update sélectif                                         |
| `update-tools --list`          | Liste les outils supportés                              |
| `update-tools --help`          | Affiche l'usage                                         |

## Conventions de sortie

- `==>` entête par outil (bleu)
- `= outil X.Y.Z up-to-date` (gris)
- `outil X.Y.Z → X.Y.Z+1` (ligne d'info avant install)
- `✓ outil → X.Y.Z+1` (vert, après install)
- `!` warning (jaune) — ex. nightly neovim > latest stable
- `✗` fail (rouge) — source absente

## Pattern type pour ajouter un outil

Chaque outil a trois choses : un `v_<nom>()` qui parse la version locale, et un `update_<nom>()` qui suit le pattern :

```bash
update_foo() {
  local latest cur
  latest=$(gh_latest owner/repo)
  cur=$(v_foo || true)
  if [[ "$cur" == "$latest" ]]; then skip "foo $cur up-to-date"; return; fi
  info "foo ${cur:-<none>} → $latest"
  [[ $CHECK -eq 1 ]] && return
  # ... télécharger et installer ...
  ok "foo → $(v_foo)"
}
```

Puis :
1. Ajouter le nom dans `ALL_TOOLS=(...)`
2. Ajouter une branche dans le `case` du dispatch

## Pièges connus

### dive — config chargée dans `--version`
Depuis qu'on a `~/.dive.yaml`, `dive --version` affiche **deux lignes** :
```
Using config file: /home/schaff/.dive.yaml
dive 0.13.1
```
Le parser ancre donc sur `^dive ` pour éviter de capturer `config` de la première ligne.

### lazygit — deux `version=` dans la sortie
```
... version=0.61.0, ... git version=2.34.1
```
Le parser utilise `, version=\K[^,]+` (précédé d'une virgule-espace) pour ne pas matcher `git version=`.

### git — PPA git-core/ppa
Git est mis à jour via le PPA officiel `ppa:git-core/ppa` (maintenu par l'équipe git). Le script ajoute automatiquement le PPA s'il est absent. Pour revenir à la version Ubuntu stock :
```bash
sudo ppa-purge ppa:git-core/ppa   # downgrade tous les paquets du PPA
```

### neovim — protection anti-downgrade
Si `nvim --version` retourne un numéro **supérieur** à la dernière release stable (ex. nightly), le script émet un warning et saute au lieu d'écraser une build plus récente.
