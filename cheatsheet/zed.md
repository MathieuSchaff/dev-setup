# Zed — Config & Keymaps

Éditeur principal côté Windows, mode vim activé avec base_keymap VSCode.
Config source : `C:\Users\schaf\AppData\Roaming\Zed\`
Backup versionné : `~/dev-setup/.config/zed/` (déployé via `install.sh`,
auto-détection de `/mnt/c/Users/*/AppData/Roaming/Zed/`).

## Sommaire

- [Apparence](#apparence)
- [Vim + base keymap](#vim--base-keymap)
- [Keymaps NORMAL — Leader space](#keymaps-custom--normal-mode)
- [Keymaps VISUAL](#keymaps-custom--visual-mode)
- [Keymaps globales](#keymaps-globales-tous-les-modes)
- [Navigation panes / tabs](#navigation-inter-panes--tabs-workspace)
- [TypeScript / TSX / JS / JSX](#typescript--tsx--js--jsx)
- [Exclusions (file scan)](#exclusions-file-scan)
- [IA — Ollama local](#ia--ollama-local)
- [Bindings VSCode utiles](#commandes-vscode-keymap-utiles-non-overridées)
- [Fichiers](#fichiers)
- [Pièges](#pièges)

---

## Apparence

| Paramètre             | Valeur                |
|-----------------------|-----------------------|
| Thème dark            | **Catppuccin Mocha**  |
| Thème light           | Catppuccin Latte      |
| Icon theme            | Catppuccin Mocha      |
| Font (UI + buffer)    | `.ZedMono` @ 18px     |
| Scrollbar             | auto                  |
| Minimap               | jamais                |
| Indent guides         | off                   |
| Sticky scroll         | off                   |
| Relative line numbers | on                    |
| Project panel         | dock **droit**        |
| Centered layout       | padding 0.2 / 0.2     |

---

## Vim + base keymap

| Paramètre     | Valeur   |
|---------------|----------|
| `vim_mode`    | `true`   |
| `base_keymap` | `VSCode` |

> Les bindings VSCode (`Ctrl+P`, `Ctrl+Shift+P`, `Ctrl+B`...) restent actifs en plus
> des keymaps vim custom ci-dessous.

---

## Keymaps custom — NORMAL mode

Leader = `space`.

### Recherche / navigation

| Binding             | Action                              |
|---------------------|-------------------------------------|
| `space f f`         | File finder (fuzzy fichiers)        |
| `space f w`         | Search in project (rg-like)         |
| `shift-,` (`<`)     | File finder — alternative rapide    |
| `g i`               | Go to implementation (LSP)          |
| `g n` / `g p`       | Méthode suivante / précédente       |
| `ctrl-n` / `ctrl-p` | Diagnostic suivant / précédent      |

### LSP

| Binding     | Action                      |
|-------------|-----------------------------|
| `space l r` | **Rename** symbole          |
| `space l a` | Code actions (menu)         |
| `space l f` | **Format** le buffer        |
| `space l d` | Ouvrir le panel Diagnostics |
| `&`         | Code actions (raccourci)    |

### Fichiers / panels

| Binding   | Action                            |
|-----------|-----------------------------------|
| `space e` | Toggle right dock (project panel) |
| `space o` | Focus sur le project panel        |
| `space x` | Fermer l'item courant (buffer)    |
| `space w` | Sauvegarder                       |

### Splits / panes

| Binding     | Action                                    |
|-------------|-------------------------------------------|
| `space t h` | Split **down** (horizontal, pane en bas)  |
| `space t v` | Split **right** (vertical, pane à droite) |
| `ù`         | Split right — raccourci AZERTY            |

### Git / commentaires

| Binding     | Action                            |
|-------------|-----------------------------------|
| `space g t` | Toggle git panel                  |
| `space c`   | Toggle comments (ligne/sélection) |

---

## Keymaps custom — VISUAL mode

| Binding   | Action                                                 |
|-----------|--------------------------------------------------------|
| `shift-s` | **Surround** (ajouter entourage : `)`, `]`, `"`, etc.) |
| `space c` | Toggle comments                                        |

> `shift-s` suivi d'un caractère entoure la sélection — ex : sélection + `S"` → `"sélection"`.

---

## Keymaps globales (tous les modes)

Actives en NORMAL, VISUAL, INSERT et dans Workspace :

| Binding  | Action                               |
|----------|--------------------------------------|
| `ctrl-j` | **Toggle terminal panel**            |
| `ctrl-a` | Toggle left dock                     |
| `ctrl-,` | Project symbols                      |
| `ctrl-;` | Deploy search (panel de recherche)   |

---

## Navigation inter-panes / tabs (Workspace)

| Binding | Action                       |
|---------|------------------------------|
| `alt-h` | Tab précédent (dans le pane) |
| `alt-l` | Tab suivant (dans le pane)   |
| `alt-j` | Pane à gauche                |
| `alt-k` | Pane à droite                |

> **Pas intuitif** : `alt-j/k` navigue entre **panes** (gauche/droite),
> `alt-h/l` entre **tabs** (dans le pane courant).

---

## TypeScript / TSX / JS / JSX

Stack LSP active pour les 4 langages :

| LSP                            | Rôle                                              |
|--------------------------------|---------------------------------------------------|
| **vtsls** (principal)          | Diagnostics, navigation, inlay hints, refactors   |
| **biome**                      | Lint + organize imports + format                  |
| ~~typescript-language-server~~ | Désactivé (conflit avec vtsls)                    |
| ~~eslint~~                     | Désactivé (remplacé par Biome)                    |

### Comportement au save (`format_on_save: "on"`)

1. **Format** via Biome (`formatWithErrors: true`)
2. **Fix all** Biome (`source.fixAll.biome`)
3. **Organize imports** Biome (`source.organizeImports.biome`)

> Biome ne se lance **que si** un `biome.json(c)` existe à la racine
> (`require_config_file: true`).

### Tuning vtsls

| Option                          | Valeur                                           |
|---------------------------------|--------------------------------------------------|
| `autoUseWorkspaceTsdk`          | `true` — TS du projet prioritaire sur global     |
| `enableMoveToFileCodeAction`    | `true` — refactor "move to file"                 |
| `maxTsServerMemory`             | `4096` Mo                                        |
| `importModuleSpecifier`         | `non-relative` — préfère `@/foo` à `../../foo`   |
| `importModuleSpecifierEnding`   | `minimal` — enlève les `.js` / `.ts` inutiles    |
| `updateImportsOnFileMove`       | `always` — MAJ auto au rename/move               |

---

## Exclusions (file scan)

Fichiers/dossiers ignorés par le scanner (et donc par la recherche) :

```text
node_modules, dist, .turbo, .next, .vscode, .storybook, .husky,
.tap, .nyc_output, report, out, routeTree.gen.ts, *.tsbuildinfo,
*.d.ts.map, .DS_Store, Thumbs.db, .classpath, .settings…
```

`directory_relationships` cache aussi `dist/**`, `*.d.ts`, `*.d.ts.map`, `*.tsbuildinfo`.

---

## IA — Ollama local

| Paramètre         | Valeur                                       |
|-------------------|----------------------------------------------|
| Provider          | Ollama (local, `http://localhost:11434`)     |
| Modèle par défaut | `qwen2.5-coder:7b-instruct-q4_K_M`           |
| Modèle alternatif | `deepseek-coder-v2:16b-lite-instruct-q4_K_M` |
| Max tokens        | 8192                                         |
| Agent panel       | Qwen Coder 7B par défaut                     |
| Edit predictions  | Qwen, **désactivées** dans l'UI              |
| `disable_ai`      | `false`                                      |

> Ollama tourne côté Windows (`C:\Users\schaf\AppData\Local\Programs\Ollama\ollama.exe`).
> Zed s'y connecte en HTTP local.

---

## Commandes VSCode keymap utiles (non overridées)

| Binding        | Action                             |
|----------------|------------------------------------|
| `Ctrl+P`       | Quick open fichier                 |
| `Ctrl+Shift+P` | Command palette                    |
| `Ctrl+B`       | Toggle sidebar                     |
| `Ctrl+Shift+E` | Explorer                           |
| `Ctrl+Shift+F` | Find in files                      |
| `Ctrl+Shift+G` | Git panel                          |
| `Ctrl+/`       | Toggle comment ligne               |
| `Ctrl+D`       | Add next occurrence (multi-cursor) |
| `F2`           | Rename symbol                      |
| `F12`          | Go to definition                   |
| `Shift+F12`    | Find all references                |
| `Alt+F12`      | Peek definition                    |

---

## Fichiers

| Fichier         | Rôle                                            |
|-----------------|-------------------------------------------------|
| `settings.json` | Thème, font, LSP, Biome, Ollama, exclusions     |
| `keymap.json`   | Keymaps vim normal/visual/insert + Workspace    |

Emplacement actif : `C:\Users\schaf\AppData\Roaming\Zed\`
Backup versionné : `~/dev-setup/.config/zed/`
Sync : hook `pre-commit` copie depuis `/mnt/c/Users/schaf/AppData/Roaming/Zed/` vers le repo.
Déploiement inverse via `install.sh` (auto-détection WSL).

---

## Pièges

### Biome ne démarre pas

Vérifier qu'un `biome.json` existe à la racine (`require_config_file: true`).

### vtsls lent sur gros projets

`maxTsServerMemory: 4096` déjà bumpé, mais `enableProjectDiagnostics: false`
pour éviter que tsserver scanne tout le projet.

### Import relatif au lieu d'absolu

C'est que le path alias n'est pas dans `tsconfig.json compilerOptions.paths`.

### `ù` en mode normal (split right)

Touche AZERTY française, ne marche pas sur clavier QWERTY.

### `space` leader en visual

Ne fonctionne que si le mode visual est actif — sinon utiliser les bindings NORMAL.

### Pre-commit hook WSL-only

Le sync Zed ne marche **que sur WSL** (hardcodé `/mnt/c/Users/schaf/...`).
Sur une autre machine, éditer le hook ou l'ignorer.
