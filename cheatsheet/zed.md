# Zed — Config & Keymaps

Éditeur additionnel (Tuxedo OS), mode vim activé avec base_keymap VSCode.
Config source : `~/.config/zed/` (symlink vers `~/dev-setup/config/.config/zed/`).
Backup versionné : `~/dev-setup/config/.config/zed/` (déployé via `scripts/install.sh`).

## Sommaire

- [Apparence](#apparence)
- [Vim + base keymap](#vim--base-keymap)
- [Keymaps NORMAL — Leader space](#keymaps-custom--normal-mode)
- [Keymaps VISUAL](#keymaps-custom--visual-mode)
- [Keymaps globales](#keymaps-globales-tous-les-modes)
- [Navigation panes / tabs](#navigation-inter-panes--tabs-workspace)
- [Défauts vim Zed utiles](#défauts-vim-zed-utiles-à-savoir-par-cœur)
- [Tab — ce que ça fait vraiment](#tab--ce-que-ça-fait-vraiment)
- [TypeScript / TSX / JS / JSX](#typescript--tsx--js--jsx)
- [Exclusions (file scan)](#exclusions-file-scan)
- [IA — Ollama local](#ia--ollama-local)
- [Bindings VSCode utiles](#commandes-vscode-keymap-utiles-non-overridées)
- [Fichiers](#fichiers)
- [Pièges](#pièges)
- [Audit détaillé](#audit-détaillé)

---

## Apparence

| Paramètre             | Valeur                     |
|-----------------------|----------------------------|
| Thème dark            | **Catppuccin Macchiato**   |
| Thème light           | Catppuccin Latte           |
| Icon theme (dark)     | Catppuccin Macchiato       |
| Font (UI + buffer)    | `.ZedMono` @ 18px          |
| Scrollbar             | auto                       |
| Minimap               | jamais                     |
| Indent guides         | off                        |
| Sticky scroll         | off                        |
| Relative line numbers | on                         |
| Project panel         | dock **droit**             |
| Centered layout       | padding 0.2 / 0.2          |

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
| `?` (= `Shift+,`)   | **File finder** (AZERTY-natif)      |
| `space f f`         | File finder (alias chord)           |
| `space f w`         | Search in project (rg-like)         |
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

### Touches désactivées (`null`)

| Binding   | Raison du blocage                                                       |
|-----------|-------------------------------------------------------------------------|
| `shift-;` | Évite le vim `:` parasite (Zed assume QWERTY où `Shift+;` = `:`)        |
| `§`       | Clarifie que `Shift+!` n'ouvre pas file_finder (pas de fallback caché)  |

> ⚠️ Sur AZERTY, `Shift+;` produit `.` (= **vim repeat last change**). Le `null` pourrait le tuer. À tester : `c w TEST <Esc>` puis `.` sur un autre mot.

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
| `ctrl-;` | Deploy search *(déclaré)* — voir piège ci-dessous |

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

## Défauts vim Zed utiles (à savoir par cœur)

Pas dans keymap.json mais **actifs** via vim mode — pas besoin de rebinder :

### Navigation LSP
| Touche | Action              |
|--------|---------------------|
| `g d`  | Go to definition    |
| `g D`  | Go to declaration   |
| `g h`  | Hover (docs/erreur) |
| `K`    | Hover (alias de `g h`) |
| `g .`  | Code actions (quickfix) |

### Navigation dans le fichier
| Touche | Action                              |
|--------|-------------------------------------|
| `/`    | Search forward (= `Shift+:` AZERTY) |
| `n` / `N` | Occurrence suivante / précédente |
| `Ctrl+o` | Jump back (position précédente)  |
| `Ctrl+i` | Jump forward                     |
| `m a` / `'a` | Poser mark `a` / y retourner |
| `.`    | **Repeat last change** (= `Shift+;` AZERTY — à tester) |

### Diagnostics
| Touche | Action               |
|--------|----------------------|
| `[ d`  | Diagnostic précédent |
| `] d`  | Diagnostic suivant   |

### Git hunks
| Touche | Action        |
|--------|---------------|
| `[ c`  | Hunk précédent |
| `] c`  | Hunk suivant  |

---

## Tab — ce que ça fait vraiment

Contexte-dépendant :

| Situation | Effet |
|-----------|-------|
| Menu complétion LSP ouvert | Accepter la complétion courante |
| Menu complétion + `Shift+Tab` | Cycler dans le menu |
| Snippet LSP sélectionné | Expander le snippet, curseur sur 1er placeholder |
| Snippet déjà expandé | Sauter au placeholder suivant |
| Aucun menu | Insert indentation (tab ou spaces) |

**Snippets TS utiles** (vtsls fournit) : `imp`, `cla`, `if`, `for`, `log`, `fn`, `forof`, `forin`.

> Pour apprendre : tape `log` puis Tab dans un `.ts`. → `console.log()` avec curseur dans parens.

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

> La liste contient des **doublons** (`node_modules`, `dist/**` x3, `.tsbuildinfo` x2, `.turbo` x2). Nettoyage pendant — voir `audit.md` §2.2.

`directory_relationships` : clé non standard Zed 2026, probablement ignorée silencieusement.

---

## IA — Ollama local

| Paramètre         | Valeur                                       |
|-------------------|----------------------------------------------|
| Provider          | Ollama (local, `http://localhost:11434`)     |
| Modèle par défaut | `qwen2.5-coder:7b-instruct-q4_K_M`           |
| Modèle alternatif | `deepseek-coder-v2:16b-lite-instruct-q4_K_M` |
| Max tokens        | 8192                                         |
| Agent panel       | Qwen Coder 7B par défaut                     |
| Edit predictions  | Qwen, **générées mais masquées** (voir piège) |
| `disable_ai`      | `false`                                      |

> **Tuxedo OS** : Ollama natif (`/usr/local/bin/ollama`, service systemd user).
> **WSL** : Ollama tourne côté Windows (`C:\Users\schaf\AppData\Local\Programs\Ollama\ollama.exe`) ; Zed s'y connecte via `http://localhost:11434` (WSL fait le passthrough).

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
| `audit.md`      | Audit détaillé + journal des décisions config   |

Emplacement actif : `~/.config/zed/` (symlink vers `~/dev-setup/config/.config/zed/`)
Backup versionné : `~/dev-setup/config/.config/zed/`
Déploiement via `scripts/install.sh` (symlinks).

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

### `Ctrl+;` ≠ ce qui est déclaré
Le keymap dit `Ctrl+;` → `pane::DeploySearch`, mais en pratique `Ctrl+;` toggle les **inlay hints TypeScript** (types inline grisés). Origine pas confirmée : KDE intercept, binding caché, ou frappe différente. Investigation avec `wev` (Wayland) si motivé.

### Copier un message d'erreur depuis le hover — impossible
Zed 2026 n'expose **aucune action** `editor::CopyDiagnostic*`. Workarounds :
1. `space l d` → panel diagnostics → messages sélectionnables
2. Hover + `Ctrl+a` `Ctrl+c` (focus clavier du popup incertain)
3. Feature request upstream

### `shift-;: null` risque de tuer vim `.`
Sur AZERTY, `Shift+;` produit `.` (repeat last change). Notre `null` visait le `:` QWERTY mais peut casser `.`. Tester : `c w TEST <Esc>` → autre mot → `.`. Si 2e mot devient `TEST` → OK. Sinon retirer le null.

### Edit predictions actives mais invisibles
`edit_predictions.provider: ollama` génère en continu, mais `show_edit_predictions: false`. Cost CPU/GPU sans gain visuel → soit afficher, soit retirer l'edit_predictions.

### Dossier Zed dupliqué dans le repo
`~/dev-setup/.config/zed/` (stale, Apr 14) coexiste avec `~/dev-setup/config/.config/zed/` (actif). À supprimer :
```bash
rm -rf ~/dev-setup/.config/zed
```

---

## Audit détaillé

Voir `~/dev-setup/config/.config/zed/audit.md` pour :
- Journal des décisions de config
- Analyse complète settings.json (doublons, clés suspectes, contradictions)
- Liste TODOs priorisés
- Diff cumulé non commité
