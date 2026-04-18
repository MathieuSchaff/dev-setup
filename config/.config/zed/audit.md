# Audit Zed — keymap.json + settings.json

Dernière mise à jour : 2026-04-18 (session)
Cible : `~/.config/zed/` → symlink vers `~/dev-setup/config/.config/zed/`

---

## 0. Historique de la session (2026-04-18)

### Modifications appliquées au keymap

| # | Changement | Raison |
|---|-----------|--------|
| 1 | `"shift-,": "file_finder::Toggle"` → `"?": "file_finder::Toggle"` | Nom AZERTY-natif (`?` = `Shift+,` directement) |
| 2 | Ajout `"shift-;": null` | Empêcher vim `:` parasite (assumption QWERTY de Zed) |
| 3 | Ajout `"§": null` | Clarifier qu'aucun fallback n'ouvre file_finder sur `Shift+!` |

### Changements testés mais rollback

| # | Tentative | Raison du rollback |
|---|-----------|-------------------|
| 1 | `"!": "pane::DeploySearch"` | `Ctrl+;` ne fait pas ce qu'on croyait (voir §5.1). Pas la peine d'aller vite sur un binding vague. |

### Points clarifiés en discussion

- **Tab** fait : accepter complétion LSP, cycler menu, expander snippets, indenter. Pas juste "snippets".
- **Ctrl+k** n'est **pas** un binding signature-help dans Zed (c'était une confusion VS Code).
- **Hover docs** : pas besoin de binding → `g h` et `K` déjà par défaut vim mode Zed.
- **Copier message d'erreur depuis hover** : impossible direct, voir §5.2.

---

## 1. État actuel du keymap

### 1.1 Bindings par contexte

| Contexte | Count | Touches |
|----------|-------|---------|
| `vim_mode == normal` | 24 | `space *`, `g n/p/i`, `?`, `&`, `ù`, `ctrl-*`, `shift-;: null`, `§: null` |
| `vim_mode == insert` | 4 | `ctrl-j/a/,/;` |
| `vim_mode == visual` | 8 | `shift-s`, `space c`, `ctrl-*` |
| `Workspace` | 8 | `alt-h/l/j/k`, `ctrl-*` |
| `ProjectPanel && not_editing` | 1 | `space e` |
| `Dock` | 1 | `space e` |

### 1.2 Bindings AZERTY natifs (bons choix)

| Touche | Action | Pourquoi pertinent |
|--------|--------|-------------------|
| `?` (= `Shift+,`) | File finder | touche directe AZERTY, 1 keystroke perçu |
| `&` | Code actions | touche AZERTY directe (rangée chiffres) — à surveiller (§3.5) |
| `ù` | Split right | touche isolée, libre |
| `shift-;` → `null` | Désactivé | bloque vim `:` parasite |
| `§` → `null` | Désactivé | clarifie que `Shift+!` n'ouvre rien |

### 1.3 Défauts vim Zed actifs (pas besoin de rebinder)

| Touche | Action |
|--------|--------|
| `g d` | GoToDefinition |
| `g D` | GoToDeclaration |
| `g h` | Hover (alias `K`) |
| `g .` | ToggleCodeActions |
| `[ d` / `] d` | Diagnostic prev / next |
| `Ctrl+o` / `Ctrl+i` | Jump back / forward (historique curseur) |
| `m a` / `'a` | Marks |
| `.` (dot) | Repeat last change (**voir §5.3**) |

### 1.4 Résumé bindings custom vim normal

| Touche | Action | Catégorie |
|--------|--------|-----------|
| `space c` | Toggle commentaires | Édition |
| `g n` / `g p` | Méthode suiv / préc | Navigation |
| `g i` | Go to implementation | LSP |
| `ctrl-n` / `ctrl-p` | Diagnostic suiv / préc | Diagnostics |
| `space l r` | Rename | LSP |
| `space l a` | Code actions | LSP |
| `space l f` | Format | LSP |
| `space l d` | Diagnostics panel | Diagnostics |
| `&` | Code actions (alias) | LSP |
| `space e` | Toggle right dock | Panel |
| `space o` | Focus project panel | Panel |
| `?` | File finder | Recherche |
| `space f f` | File finder (alias) | Recherche |
| `space f w` | Project search | Recherche |
| `space g t` | Git panel | Git |
| `space x` | Close item | Buffer |
| `space w` | Save | Buffer |
| `space t h` / `t v` | Split down / right | Pane |
| `ù` | Split right (alias) | Pane |
| `ctrl-j` | Terminal toggle | Panel |
| `ctrl-a` | Left dock toggle | Panel |
| `ctrl-,` | Project symbols | Navigation |
| `ctrl-;` | Project search (?) | Recherche (**voir §5.1**) |

---

## 2. Audit settings.json

### 2.1 Cohérence avec environnement

| Setting | Valeur | Cohérence dev-setup |
|---------|--------|---------------------|
| `theme.dark` | Catppuccin Macchiato | ✅ Aligné avec tmux + Ghostty + Starship |
| `buffer_font_family` | `.ZedMono` | ⚠️ **Incohérent** avec Ghostty (JetBrainsMono Nerd Font) |
| `vim_mode` | true | ✅ |
| `base_keymap` | `VSCode` | ⚠️ avec vim_mode = combo bizarre. Considérer `Atom` ou `JetBrains` si conflits |

### 2.2 Doublons dans `file_scan_exclusions`

```jsonc
"**/node_modules/**",  // l. 226
"**/node_modules",     // l. 251 — DOUBLON
"**/dist/**",          // l. 227
"**/dist",             // l. 241
"**/dist/**",          // l. 252 — TRIPLON
"**/*.tsbuildinfo",    // l. 229
"**/*.tsbuildinfo",    // l. 254 — DOUBLON
"**/.turbo/**",        // l. 228
"**/.turbo",           // l. 243 — quasi-doublon
```

### 2.3 Clés non standard

| Clé | Statut |
|-----|--------|
| `directory_relationships` | Inconnue de Zed 2026, probablement ignorée silencieusement |
| `icon_theme.dark: "Catppuccin Macchiato"` | Nom icon theme à confirmer |
| `gutter.min_line_number_digits: 0` | Intention ? (pas de padding) |
| `relative_line_numbers: "enabled"` | Vérifier accepte string vs bool |

### 2.4 Settings contradictoires

| Setting | Valeur | Souci |
|---------|--------|-------|
| `edit_predictions.provider` = ollama | actif | génération locale |
| `show_edit_predictions` = false | masqué | **gaspille calcul Ollama** |

### 2.5 Format on save — risques

`organizeImports` au save = risque de réordonner les imports → diff Git pollués si projet sans `biome.json` strict.

### 2.6 LSP vtsls

`maxTsServerMemory: 4096` — 4GB dédiés. OK si RAM ≥16GB. Surveiller sur monorepos.

### 2.7 Modèles Ollama

Vérifier disponibilité locale :
```bash
ollama list | grep -E 'qwen2.5-coder|deepseek-coder-v2'
```

---

## 3. Analyse des bindings existants

### 3.1 Doublons intentionnels (validé par user)

Certains bindings existent en plusieurs alias car selon contexte c'est l'un ou l'autre qui vient en tête :

| Action | Bindings | Kept |
|--------|----------|------|
| File finder | `?` + `space f f` | Les deux |
| Project search | `ctrl-;` + `space f w` | Les deux |
| Code actions | `&` + `space l a` | Les deux |

### 3.2 Refactor potentiel — `ctrl-*` répétés 4 fois

`ctrl-j` `ctrl-a` `ctrl-,` `ctrl-;` déclarés dans normal, insert, visual, Workspace. En théorie `Workspace` englobe les modes vim → redondant. **À tester avant refactor** (priorité contexte vim vs Workspace dans Zed = pas clair).

Gain potentiel : ~12 lignes.

### 3.3 Bindings risqués

| Binding | Action | Risque |
|---------|--------|--------|
| `space x` | Close item | Ferme onglet sans confirm |
| `&` | Code actions | `Shift+1` AZERTY, frappé souvent en écriture |

### 3.4 Lacunes réelles restantes

| Manque | Suggestion |
|--------|-----------|
| Find references | `space l R` → `editor::FindAllReferences` (vim default `g r` = Rename dans Zed, conflit) |
| Format en visual | Dupliquer `space l f` dans `vim_mode == visual` |
| Buffer nav vim-like | `]b` / `[b` → `pane::ActivateNextItem/Previous` |
| Copier diagnostic depuis hover | **impossible côté Zed** (voir §5.2) |

---

## 4. Structure — dossier dupliqué

Deux dossiers Zed dans le repo :

| Chemin | État | Date | Notes |
|--------|------|------|-------|
| `~/dev-setup/config/.config/zed/` | **actif** (symlink cible) | 2026-04-18 | à jour, contient `themes/` |
| `~/dev-setup/.config/zed/` | **stale** | 2026-04-14 | résidu restructure `f281137` |

**Action** :
```bash
rm -rf ~/dev-setup/.config/zed
```

---

## 5. Mystères et points bloquants

### 5.1 `Ctrl+;` ≠ ce qui est déclaré

**Observation** : en vim normal, `Ctrl+;` toggle les inlay hints TypeScript (types inline grisés style `{id: string; name: string}`). **Pas** `pane::DeploySearch` comme déclaré dans keymap.json.

**Hypothèses** :
- KDE intercepte avant Zed
- Un binding ailleurs écrase
- Frappe réelle ≠ `Ctrl+;` attendu

**Investigation proposée** (si jamais motivé) :
```bash
wev   # Wayland event viewer
```
→ presser `Ctrl+;` → voir le keysym réel transmis à l'app. Puis ouvrir Zed command palette, chercher "toggle inlay hints" pour voir son binding.

### 5.2 Copier message d'erreur depuis hover

**Vérifié** : pas d'action `editor::CopyDiagnostic*` dans Zed main (2026). Seules actions copy existantes : `Copy`, `CopyAndTrim`, `CopyFileLocation`, `CopyFileName`, `CopyPermalinkToLine`.

**Workarounds** :
1. `space l d` → diagnostics panel → messages text-selectables
2. Tester hover popup + `Ctrl+a` `Ctrl+c` (focus clavier incertain)
3. Feature request upstream zed-industries/zed

### 5.3 `Shift+;` null = risque de tuer vim `.` ?

Le `null` sur `shift-;` visait à bloquer vim `:` (qui présume QWERTY). Mais sur AZERTY, `Shift+;` produit `.` (vim repeat last change — commande pilier).

Si Zed matche sur physique (shift + touche `;`) → `.` peut être mort. Si Zed matche sur logique (`.`) → `.` fonctionne.

**Test à faire** :
1. Vim normal → `c w TEST <Esc>` sur un mot
2. Déplacer curseur sur un autre mot
3. Presser `.` (= `Shift+;` AZERTY)
4. Si 2e mot devient "TEST" → OK, laisser `null`
5. Sinon → retirer `"shift-;": null`

---

## 6. Actions prioritaires à décider

| # | Priorité | Action | État |
|---|----------|--------|------|
| 1 | Haute | Supprimer `~/dev-setup/.config/zed/` stale | En attente |
| 2 | Haute | Tester vim `.` sur AZERTY (§5.3) | En attente |
| 3 | Moyenne | Nettoyer doublons `file_scan_exclusions` | En attente |
| 4 | Moyenne | Aligner `buffer_font_family` sur JetBrainsMono Nerd Font | En attente |
| 5 | Moyenne | Décider `edit_predictions` (afficher ou désactiver) | En attente |
| 6 | Basse | Refactor `ctrl-*` vim → Workspace seul | En attente |
| 7 | Basse | Vérifier `directory_relationships` | En attente |
| 8 | Basse | Ajouter `space l R` (references), format visual, `]b`/`[b` | En attente |
| 9 | Basse | Investigation `Ctrl+;` inlay hints (§5.1) | Reporté |

---

## 7. Diff cumulé non commité

```diff
- "shift-,": "file_finder::Toggle",
+ "?": "file_finder::Toggle",
+ // AZERTY: shift-; would otherwise trigger vim : (QWERTY assumption)
+ "shift-;": null,
+ // AZERTY: § (= shift-! key) disabled to keep file_finder on ? only
+ "§": null,
```

À committer après validation du test `.` repeat (§5.3) — si `.` est cassé, retirer `shift-;: null` avant commit.
