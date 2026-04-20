# Audit Zed — keymap.json + settings.json

Dernière mise à jour : 2026-04-18 (session)
Cible : `~/.config/zed/` → symlink vers `~/dev-setup/config/.config/zed/`

## 1. Keymap — table unique

**Légende Type** : `C` custom · `V` vim natif · `Z` Zed défaut · `∅` désactivé · `?` TODO/lacune
**Contexte par défaut** : Normal + Visual. Exceptions notées.
**⚠ = binding risqué** (ferme sans confirm, frappé souvent, etc.)

| Touche               | Action                                     | Cat   | Type | Note                                                        |
| -------------------- | ------------------------------------------ | ----- | ---- | ----------------------------------------------------------- |
| `Ctrl+,`             | Project symbols                            | Rech  | C    | contexte Workspace                                          |
| `Ctrl+;`             | Project search                             | Rech  | C    | contexte Workspace                                          |
| `Ctrl+:`             | Inlay Hints toggle                         | Diag  | Z    | AZERTY natif (voir §4.1)                                    |
| `Ctrl+a`             | Left dock toggle                           | Panel | C    | contexte Workspace                                          |
| `Ctrl+d` / `Ctrl+u`  | Half-page down/up                          | Nav   | V    |                                                             |
| `Ctrl+f` / `Ctrl+b`  | Full-page down/up                          | Nav   | V    |                                                             |
| `Ctrl+h` / `Ctrl+l`  | Tab prev/next                              | Pane  | C    | contexte Workspace; search&replace déplacé sur `Ctrl+q`     |
| `Ctrl+j` / `Ctrl+k`  | Pane left/right                            | Pane  | C    | contexte Workspace                                          |
| `Ctrl+n` / `Ctrl+p`  | Diag suiv/préc                             | Diag  | C    |                                                             |
| `Ctrl+o` / `Ctrl+i`  | History back/forward                       | Nav   | V    |                                                             |
| `Ctrl+q`             | Search & replace                           | Édit  | C    | `buffer_search::DeployReplace` — libère `Ctrl+h` du conflit |
| `Ctrl+r`             | Redo                                       | Édit  | V    |                                                             |
| `Ctrl+t`             | Reset pane sizes                           | Pane  | C    | `vim::ResetPaneSizes` — Normal+Visual                       |
| `Ctrl+Shift+arrows`  | Resize panes                               | Pane  | C    | contexte Workspace                                          |
| `g h` / `K`          | Hover docs                                 | LSP   | V    | défaut vim Zed                                              |
| `g i`                | Go to implementation                       | LSP   | C    |                                                             |
| `g n` / `g p`        | Méthode suiv/préc                          | Nav   | C    |                                                             |
| `g q` / `Alt+f`      | Rewrap text                                | Édit  | C    | `vim::Rewrap`                                               |
| `gg` / `G`           | Début/fin fichier                          | Nav   | V    |                                                             |
| `space c`            | Toggle commentaires                        | Édit  | C    |                                                             |
| `space e`            | Toggle right dock                          | Panel | C    | actif aussi dans ProjectPanel & Dock                        |
| `space g t`          | Git panel                                  | Git   | C    |                                                             |
| `space l d`          | Diagnostics panel                          | LSP   | C    |                                                             |
| `space l f`          | Format                                     | LSP   | C    | manque en visual → lacune `?`                               |
| `space l r`          | Rename                                     | LSP   | C    |                                                             |
| `space o`            | Focus project panel                        | Panel | C    |                                                             |
| `space t h` / `t v`  | Split down/right                           | Pane  | C    |                                                             |
| `space w`            | Save                                       | Buf   | C    |                                                             |
| `space x`            | Close item                                 | Buf   | C    | ⚠ sans confirm                                              |
| `H` / `L` / `M`      | Haut/bas/milieu écran                      | Nav   | V    |                                                             |
| `%`                  | Jump to match                              | Nav   | V    | parens/accolades                                            |
| `.`                  | Repeat last change                         | Édit  | V    | pilier; ✅ confirmé OK sur AZERTY (2026-04-18)              |
| `u`                  | Undo                                       | Édit  | V    |                                                             |
| `"`                  | Registres                                  | Core  | V    | ex: `"ay`                                                   |
| `'`                  | Marks                                      | Core  | V    | ex: `'a`                                                    |
| `]b` / `[b`          | Buffer next/prev                           | Buf   | V    | défaut vim Zed — `pane::ActivateNextItem/Previous`          |
| `Tab`                | Complétion / cycle menu / snippet / indent | Édit  | Z    | multi-usage défaut Zed (voir §0)                            |
| `?` (Shift+,)        | File finder                                | Rech  | C    | AZERTY natif                                                |
| `&`                  | Code actions                               | LSP   | C    | ⚠ écrase vim `:s` repeat (rangée chiffres AZERTY)           |
| `!`                  | Filter via shell                           | Édit  | V    | vim défaut — `!<motion>cmd` pipe sélection dans shell       |
| `²`                  | Terminal toggle                            | Panel | C    | Normal+Visual seulement; sous Esc AZERTY                    |
| `ù`                  | Split right                                | Pane  | C    | alias `space t v` — touche AZERTY isolée                    |
| `é` / `è`            | Resize width                               | Pane  | C    | Normal+Visual seulement                                     |
| `ç` / `à`            | Resize height                              | Pane  | C    | Normal+Visual seulement                                     |
| `§` (Shift+!)        | Toggle next pane                           | Pane  | C    | cycle panes — `workspace::ActivateNextPane` (Normal+Visual) |
| `shift-;`            | (bloqué)                                   | ∅     | —    | bloque vim `:` QWERTY; `.` reste fonctionnel ✅             |
| `space l R`          | Find references                            | LSP   | ?    | `g r` pris par Rename                                       |
| (visual) `space l f` | Format sélection                           | LSP   | ?    | dupliquer en `vim_mode == visual`                           |
| (copier diag hover)  | —                                          | Diag  | ?    | impossible côté Zed (§4.2)                                  |

### 1.x Notes complémentaires

- **Refactor tenté puis reverté 2026-04-18** : `ctrl-a/,/;` re-déclarés dans normal+insert+visual+Workspace (4×). Tentative de dédup vers `Workspace` seul → cassait les bindings quand focus éditeur (Zed défauts supplantent Workspace pour `ctrl-,`/`ctrl-;`). Conclusion : Workspace propage pour `alt-*` mais pas pour certains `ctrl-*` → garder les 4 contextes.
- **Aliases supprimés** : `space f f` / `space f w` / `space l a` / `Ctrl+k` — le binding principal (`?` / `Ctrl+;` / `&`) suffit.
- **Nav panes/tabs migré Alt → Ctrl** : `alt-h/l/j/k` → `ctrl-h/l/j/k` (Workspace). `ctrl-j` désormais = pane left (était null depuis le clean-up précédent).
- **`§` = toggle pane cycle** : `workspace::ActivateNextPane` en Normal+Visual. Avec 2 panes L+R, cycle = toggle déterministe (pas d'historique requis contrairement à `ActivateLastPane`).
- **`Ctrl+q` = search & replace** : `ctrl-q` = `ctrl-v` en vim (visual block redondant) → réaffecté à `buffer_search::DeployReplace`. Résout conflit `ctrl-h` override.
- **`&` écrase vim substitution repeat** (`:s` re-run) — arbitrage assumé : Code Actions plus utile que `:s` replay.
- **`]b` / `[b`** : natif vim mode Zed, pas besoin de custom.

---

## 2. Settings.json

### 2.1 Cohérence avec environnement

| Setting              | Valeur               | Cohérence dev-setup                                                            |
| -------------------- | -------------------- | ------------------------------------------------------------------------------ |
| `theme.dark`         | Catppuccin Macchiato | ✅ Aligné avec tmux + Ghostty + Starship                                       |
| `buffer_font_family` | `.ZedMono`           | ⚠️ Incohérent avec Ghostty (JetBrainsMono Nerd Font)                           |
| `vim_mode`           | true                 | ✅                                                                             |
| `base_keymap`        | `VSCode`             | ⚠️ avec vim_mode = combo bizarre. Considérer `Atom` ou `JetBrains` si conflits |

## 6. Vim bare keys — référence rapide

Touches isolées non-overridées dans le setup (exception : `=` via séquence `space t =`). Utile pour ne pas les shadow par inadvertance lors de futurs bindings.

### 6.1 Touches isolées

| Touche    | Effet vim (normal mode)                                         |
| --------- | --------------------------------------------------------------- |
| `n` / `N` | repeat dernière recherche — même / sens inverse                 |
| `;` / `,` | repeat dernier `f/F/t/T` — même / sens inverse                  |
| `!`       | filter operator — attend motion puis cmd shell (`!<motion>cmd`) |
| `{` / `}` | paragraph backward / forward                                    |
| `_`       | linewise first non-blank (`3_` = 3 lignes down)                 |
| `-`       | ligne précédente, first non-blank                               |
| `(` / `)` | sentence backward / forward                                     |
| `'`       | jump mark line — attend char (`'a` = ligne du mark a)           |
| `"`       | register prefix — attend char (`"ay` = yank dans reg a)         |
| `=`       | indent operator — attend motion (`==` ligne, `=G` jusqu'à fin)  |

### 6.2 `f F t T` + `; ,` — char search inline

`f/F/t/T` = recherche d'un caractère sur la **ligne courante** uniquement. `;` / `,` = répètent.

| Touche | Effet                                                     | Ex. sur `hello world`, curseur sur `h` |
| ------ | --------------------------------------------------------- | -------------------------------------- |
| `f<c>` | **F**ind — saute **sur** occurrence forward               | `fo` → curseur sur `o` de `hellO`      |
| `F<c>` | Find backward — saute **sur** occurrence backward         | curseur sur `d`, `Fh` → `h`            |
| `t<c>` | **T**ill — saute **juste avant** occurrence forward       | `to` → curseur sur `l` (avant `o`)     |
| `T<c>` | Till backward — saute **juste après** occurrence backward | curseur sur `d`, `Th` → `e`            |
| `;`    | repeat dernier `f/F/t/T` — même direction                 | `fo` puis `;` → `o` suivant (`wOrld`)  |
| `,`    | repeat dernier `f/F/t/T` — sens inverse                   | `fo` puis `,` → `o` précédent          |

## 7. `Ctrl+<lettre>` — référence vim vs Zed

Panorama complet. ✏ = override custom (voir §1). Colonne "Actif" = ce qui prévaut dans le setup actuel.

| Touche   | Vim natif                              | Zed défaut       | Actif (setup schaff)                        | Type |
| -------- | -------------------------------------- | ---------------- | ------------------------------------------- | ---- |
| `Ctrl+a` | increment number                       | —                | Toggle left dock ✏                          | C    |
| `Ctrl+b` | full-page up                           | —                | vim                                         | V    |
| `Ctrl+c` | abort / escape                         | Copy clipboard   | Zed (Copy) prime en insert/visual           | Z    |
| `Ctrl+d` | half-page down                         | —                | vim                                         | V    |
| `Ctrl+e` | scroll 1 ligne down                    | —                | vim                                         | V    |
| `Ctrl+f` | full-page down                         | Search buffer    | vim (normal mode prime)                     | V    |
| `Ctrl+g` | show file info                         | —                | vim                                         | V    |
| `Ctrl+h` | backspace (insert)                     | Search & replace | Tab prev ✏ (Workspace)                      | C    |
| `Ctrl+i` | jump forward                           | —                | vim                                         | V    |
| `Ctrl+j` | newline (insert)                       | —                | Pane left ✏                                 | C    |
| `Ctrl+k` | —                                      | —                | Pane right ✏                                | C    |
| `Ctrl+l` | redraw screen                          | —                | Tab next ✏ (Workspace)                      | C    |
| `Ctrl+m` | Enter (alias)                          | Enter            | Enter                                       | Z    |
| `Ctrl+n` | completion next (insert)               | —                | Diag next ✏                                 | C    |
| `Ctrl+o` | jump backward                          | —                | vim                                         | V    |
| `Ctrl+p` | completion prev (insert)               | —                | Diag prev ✏                                 | C    |
| `Ctrl+q` | redraw / visual block (si Ctrl+v pris) | —                | Search & replace ✏                          | C    |
| `Ctrl+r` | redo                                   | —                | vim                                         | V    |
| `Ctrl+s` | —                                      | Save             | Zed (Save) — doublon avec `space w`         | Z    |
| `Ctrl+t` | pop tag stack                          | —                | **Reset pane sizes** ✏ (ex-`space t =`)     | C    |
| `Ctrl+u` | half-page up                           | —                | vim                                         | V    |
| `Ctrl+v` | visual block                           | Paste            | Zed (Paste) en insert ; vim block en normal | Z/V  |
| `Ctrl+w` | window prefix                          | Close tab        | Zed (Close) — commandes window vim perdues  | Z    |
| `Ctrl+x` | decrement / completion prefix (insert) | Cut              | Zed (Cut) en insert                         | Z    |
| `Ctrl+y` | scroll 1 ligne up                      | —                | vim                                         | V    |
| `Ctrl+z` | suspend (terminal)                     | Undo             | Zed (Undo)                                  | Z    |
| `Ctrl+,` | —                                      | Settings         | Project symbols ✏                           | C    |
