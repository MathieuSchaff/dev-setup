# Audit & Plan de Modernisation — Tuxedo OS / KDE Plasma 6.5.2

> Dernière mise à jour : 2026-04-16 (session ricing)
> Environnement : Tuxedo OS (Ubuntu 24.04), KDE Plasma 6.5.2, KWin 6.5.2, Wayland

---

## 1. État des Lieux

| Composant | Valeur actuelle |
|---|---|
| OS | Tuxedo OS 24.04 LTS |
| DE | KDE Plasma 6.5.2 |
| Compositeur | KWin 6.5.2 (Wayland) |
| Thème Plasma | Breeze (Catppuccin Frappe en cours) |
| Icônes | Papirus (variante Catppuccin Frappe) ✅ |
| Terminal | Ghostty 1.3.1 — Catppuccin Macchiato ✅ |
| Polices | JetBrainsMono Nerd Font ✅ |
| Prompt | Starship — Catppuccin Macchiato ✅ |
| Thème global CLI | Catppuccin Macchiato (tmux, delta, nvim, ghostty, starship) |

**État actuel :**
- Couleurs : Catppuccin Frappe ✅
- Icônes : Papirus Catppuccin ✅
- Décorations fenêtres : Catppuccin Frappe Modern ✅
- Application Style : Kvantum ✅
- Splash screen : Catppuccin Frappe ✅
- Son système : Ocean ✅
- Login screen : Tuxedo Breeze (inchangé pour l'instant)
- Plasma Style : Breeze (inchangé)
- Apps CSD (Ghostty, Firefox) : boutons natifs propres, ignorent la déco KWin → normal sur Wayland

**Points faibles restants :**
- Plasma Style pas encore Catppuccin
- GTK/Flatpak apps non alignées visuellement
- Klassy non installé (déco fenêtres avancée)
- Blur sur apps tierces impossible sans kwin-effects-forceblur (archivé, risqué sur 6.5)

---

## 2. Ce que Plasma 6.5 offre en natif

### Nouveautés Plasma 6.x utiles pour le ricing

| Version | Feature |
|---|---|
| 6.0 | Panneaux flottants natifs (panel détaché du bord) |
| 6.2 | Accent color → propagée à Breeze Dark/Light/Twilight |
| 6.3 | Opacité par panneau (slider), fractional scaling amélioré |
| 6.4 | Layout tiling par bureau virtuel, VD réordonnables, session restore (taille/position) |
| 6.5 | **Coins arrondis en bas des fenêtres** (natif, Breeze), auto-switch dark/light par heure, panneaux scrollables, fond transparent Sticky Notes |

### Ce qu'on peut faire sans aucun outil tiers

| Feature | Natif ? | Où |
|---|---|---|
| Panneaux flottants | ✅ | Clic droit → Éditer le panneau |
| Opacité panneau | ✅ (6.3+) | Éditer le panneau → curseur opacité |
| Flou panneau | ✅ auto | Si panneau semi-transparent + effet KWin Blur actif |
| Coins arrondis fenêtres | ✅ (6.5, Breeze seulement) | Paramètres → Décorations → Breeze → options |
| Accent color globale | ✅ | Paramètres → Couleurs → Accent |
| Thème auto dark/light | ✅ (6.5) | Paramètres → Thème automatique |
| Effets fenêtres (wobbly, magic lamp, etc.) | ✅ | Paramètres → Comportement → Effets bureau |
| Règles par fenêtre | ✅ | Paramètres → Gestion des fenêtres → Règles |
| Virtual desktops + overview | ✅ | Meta+W |
| Tiling manuel | ✅ (6.4+) | Glisser vers bords + layout par VD |

**Limites du natif :**
- Coins arrondis = Breeze uniquement, rayon fixe
- Flou fenêtres non-KDE = impossible sans plugin tiers
- Pas de gradients/islands sur les panneaux
- Pas de Material You / couleurs depuis wallpaper
- Klassy > Breeze pour la customisation des décorations

---

## 3. Composants à installer

### 3.1 Qt Style Engine

| Outil | Status | Wayland | Install | Notes |
|---|---|---|---|---|
| **Kvantum** | Actif (sera remplacé Plasma 7) | ✅ stable | `apt install kvantum` | Seul moyen d'avoir flou/transparence Qt |
| Breeze natif | Core KDE, toujours maintenu | ✅ | inclus | Fonctionnel, sans effets avancés |

**Recommandation :** Kvantum + thème `catppuccin-kvantum` → cohérence avec l'écosystème existant.

### 3.2 Décorations de fenêtres

| Outil | Status | Plasma 6 | Install | Notes |
|---|---|---|---|---|
| **Klassy** | Actif, patch jan 2025 | ✅ (requis 6.3+) | Compile / OBS | Traffic light buttons, coins config, blur, outline coloré |
| **KDE-Rounded-Corners** | Actif | ✅ | Compile / deb | Rayon configurable (1–25px), fonctionne sur toute déco |
| Aurorae themes | Dépend du thème | ✅ SVG-based | KDE Store | SVG = compat; QML old = cassé |
| Breeze natif | Core KDE | ✅ | inclus | OK, options limitées |
| Sierra Breeze Enhanced | Peu actif | ⚠️ | Compile | Risqué |

**Recommandation :** Klassy (le plus complet) ou rester Breeze natif si les décos actuelles ne gênent pas.

### 3.3 Icônes

| Pack | Status | Plasma 6 | Notes |
|---|---|---|---|
| **Papirus** | Actif, updates 2025 | ✅ excellent | Couverture max, variante Catppuccin officielle |
| **Tela-circle** | Actif | ✅ | Rond style Android |
| Breeze | Core KDE | ✅ | Minimaliste |
| Candy | Actif | ✅ | Coloré, moins complet |
| Numix Circle | Peu actif | ⚠️ | À éviter |

**Recommandation :** `papirus-icon-theme` + variante Catppuccin Macchiato (installée via script catppuccin/kde).

### 3.4 Effets KWin tiers

| Plugin | Features | Plasma 6 | Wayland | Status |
|---|---|---|---|---|
| **kwin-effects-forceblur** | Forcer le flou sur n'importe quelle fenêtre par WM class | 6.4+ | ✅ | Actif |
| **KDE-Rounded-Corners** | Coins arrondis configurables, outline coloré, exclusions par app | 6.6+ | ✅ | Actif |
| kwin-effects-kinetic | Animations physiques (spring) | 6.x | ✅ | Actif |
| better-blur-dx | Comme forceblur + static blur | 6.4+ | ✅ | **Archivé nov 2025** |

### 3.5 Widgets recommandés

| Widget | Utilité | Source |
|---|---|---|
| **Panel Colorizer** | Latte-style : gradients, blur, islands, couleurs par widget | [GitHub](https://github.com/luisbocanegra/plasma-panel-colorizer) |
| **kde-material-you-colors** | Couleurs auto depuis wallpaper (Material You) | [GitHub](https://github.com/luisbocanegra/kde-material-you-colors) |
| KVitals | CPU/RAM/réseau léger dans le panneau | KDE Store |
| Variable Weather | Météo sans clé API (Open-Meteo) | KDE Store |

---

## 4. Thèmes disponibles (alternatives à Catppuccin)

| Thème | Style | Kvantum | GTK | Status |
|---|---|---|---|---|
| **Catppuccin** | Pastel moderne | ✅ | ✅ | Actif — déjà partout dans le setup |
| **Nordic** | Arctique, bleu-gris | ✅ (Utterly Nord) | ✅ | Actif |
| **Tokyo Night** | Bleu nuit/violet | ✅ | ✅ | Actif |
| **Orchis** | Material Design épuré | ✅ | ✅ | Actif |
| **Dracula** | Violet sombre | ✅ | ✅ | Actif |
| **Layan** | Coloré, transparences | ✅ | ✅ | Actif — Kvantum requis |
| **Sweet** | Gradient rose/violet | ✅ | ✅ | Actif — flashy |
| **Colloid** | Arrondi moderne | ✅ | ✅ | Actif |
| **Fluent** | Windows 11 inspired | ✅ | ✅ | Actif |
| **Materia** | Material Design flat | ✅ | ✅ | Stale ⚠️ |

**Voir les thèmes :**
- Screenshots GitHub : chercher `<nom>-kde` sur GitHub
- `store.kde.org` / `pling.com` : filtre "Plasma 6" obligatoire
- YouTube : `"KDE Plasma 6 rice 2025"`

---

## 5. GTK / Flatpak — Cohérence visuelle

**Problème Wayland :** XSETTINGS n'existe plus. GTK apps lisent leur config via `xdg-desktop-portal`.

**Packages requis :**
```bash
sudo apt install breeze-gtk xdg-desktop-portal-kde xdg-desktop-portal-gtk
```

**Apps GTK4/libadwaita (Firefox, apps GNOME) :** ignorent les thèmes GTK → utiliser `adw-gtk3` pour harmoniser GTK3 avec le look GTK4.

**Flatpak :** donner accès aux configs GTK via Flatseal (`~/.config/gtk-3.0:ro`, `~/.config/gtk-4.0:ro`).

**Variable d'environnement :**
```bash
GTK_USE_PORTAL=1  # dans ~/.config/environment.d/gtk.conf
```

---

## 6. SDDM (écran de login)

- Plasma 6 exige des thèmes Qt6/QML6
- Thèmes Plasma 5 cassés → chercher `QtVersion=6` dans `metadata.desktop`
- Fix pour vieux thèmes : `import QtGraphicalEffects 1.0` → `import Qt5Compat.GraphicalEffects`
- Catppuccin SDDM officiel : compatible Qt6 ✅
- Config : Paramètres → Apparence → Écran de connexion

---

## 7. Pièges à éviter

| Piège | Gravité | Détail |
|---|---|---|
| Widgets Plasma 5 | ☠️ | Crashent plasmashell — vérifier support explicite Plasma 6 |
| Latte Dock | ☠️ | Archivé, jamais porté sur Plasma 6 |
| Global Themes KDE Store | ⚠️ haut | Exécutent du code, incidents documentés (suppression fichiers). Installer composants séparément. |
| Thèmes Plasma 5 sur KDE Store | ⚠️ | Chercher le tag "Plasma 6" obligatoirement |
| Kvantum blur cassé | ⚠️ | Certains thèmes ne définissent pas `_KDE_NET_WM_BLUR_BEHIND_REGION` → utiliser kwin-effects-forceblur en fallback |
| Blur + fractional scaling | ⚠️ perf | Peut causer du cursor stutter GPU → `KWIN_DRM_NO_AMS=1` |
| Sierra Breeze Enhanced | ⚠️ | Peu maintenu, potentiellement cassé |
| Aurorae QML (vieux) | ⚠️ | SVG-based = OK, QML era Plasma 5 = souvent cassé |
| Global Menu + Firefox/GTK | info | Ne fonctionne pas sur Wayland (pas de protocole) |
| GTK4/libadwaita theming | info | Ces apps ignorent les thèmes GTK par design |

---

## 8. Tips & Raccourcis KDE utiles

### Raccourcis natifs
| Shortcut | Action |
|---|---|
| `Meta+Tab` | Task Switcher (actif) |
| `Meta+W` | Overview — tous les bureaux/fenêtres (actif) |
| `Meta+.` | Emoji picker |
| `Meta+=` / `Meta+-` | Zoom écran |
| `Alt+Space` | KRunner (lanceur, calculatrice, conversions, recherche fichiers) |
| Dans Overview | Taper un nom d'app → filtre les fenêtres |
| `Meta+&` / `Meta+é` / `Meta+"` ... | Focus app 1/2/3... dans la taskbar (AZERTY) |
| `Meta+flèches` | Snap/resize fenêtres (gauche, droite, haut=max, bas=restore) |

**Note AZERTY** : `Meta+1/2/3` ne fonctionne pas. Rebindé manuellement vers `Meta+&`, `Meta+é`, etc. dans `System Settings → Shortcuts → KWin → Switch to Task N`.

### Screen Edges (Workspace → Screen Edges)
Assigner des actions aux coins/bords écran (recommandé) :
- Coin haut-gauche → Overview
- Coin haut-droit → Show Desktop
- Bord bas → Present Windows

### KRunner — optimisation
`Workspace → Search → Plasma Search` → décocher les plugins inutiles pour accélérer.

### Task Switcher — perf
Si trop lent : changer visualization → **Compact** ou **Large Icons** (plus rapide que Breeze).
Bug connu : position du switcher suit l'écran actif même sans filtre — pas de fix sur 6.5.

### Fichiers de config KDE
Tous les settings System Settings → `~/.config/` (format INI).

| Setting | Fichier |
|---|---|
| Desktop Effects, Task Switcher, Screen Edges | `~/.config/kwinrc` |
| General Behavior, Couleurs | `~/.config/kdeglobals` |
| Shortcuts | `~/.config/kglobalshortcutsrc` |
| Panel / widgets | `~/.config/plasma-org.kde.plasma.desktop-appletsrc` |

Après édition manuelle :
```bash
qdbus org.kde.KWin /KWin reconfigure
```

### Animation Speed
`Desktop Effects → Animation Speed` → pousser vers "Instant" pour tout accélérer.

### General Behavior
- **Double-click** pour ouvrir fichiers/dossiers (défaut Plasma 6, recommandé)
- Scrolling speed configurable si molette trop lente

---

## 9. Liste de courses (reste à faire)

- [x] **Kvantum** — `sudo apt install qt6-style-kvantum qt-style-kvantum-themes` (via PPA papirus)
- [x] **Catppuccin KDE** — script officiel `catppuccin/kde`, flaveur **Frappe**, Modern decorations
- [x] **Papirus** — `sudo apt install papirus-icon-theme`
- [ ] **Desktop Effects à configurer** (Window Management → Desktop Effects) :
  - [x] Magic Lamp / Window Minimize (fenêtre → barre en vague) — Animations → Window Minimize
  - [ ] Wobbly Windows (fenêtres tremblent au déplacement)
  - [ ] Slide/Fade (transitions bureaux virtuels)
  - [x] Sheet (dialogues fly in/out)
  - [ ] Nail Aside (thumbnail sur bord écran, shortcut clavier) — gadget, skip
  - [x] Translucency (fenêtres translucides selon conditions)
  - [x] Track Mouse
  - [x] Mouse Click Animation
  - [x] Desaturate Unresponsive Applications
  - [x] Blur
  - [x] Highlight Screen Edges & Hot Corners
  - [x] Dialog Parent
  - [x] Dim Screen for Administrator Mode
  - [x] Overview (Meta+W)
- [ ] **Klassy** — compiler depuis source ou OBS (requis Plasma 6.3+ ✅)
- [ ] **kwin-effects-forceblur** — si flou sur fenêtres non-KDE voulu
- [ ] **breeze-gtk** + **adw-gtk3** — cohérence GTK
- [ ] **Panel Colorizer** — widget KDE Store si dock stylisé voulu
- [x] **JetBrainsMono Nerd Font** — installée dans `~/.local/share/fonts/JetBrainsMonoNF/`
- [x] **Terminal** — Ghostty 1.3.1 (Wayland natif, GPU, GTK4) — Catppuccin Macchiato, JetBrainsMono NF 12pt

---

## 9. Stack recommandée finale

| Composant | Choix |
|---|---|
| Thème global | Catppuccin **Frappe** (choix KDE) — Macchiato reste pour CLI (tmux, nvim, ghostty, starship) |
| Qt style | Kvantum + Catppuccin-Kvantum |
| Décoration fenêtres | Klassy ou Breeze natif 6.5 |
| Icônes | Papirus variante Catppuccin |
| Panneau | Panel Colorizer widget |
| Blur fenêtres | KWin natif + kwin-effects-forceblur |
| GTK | breeze-gtk + adw-gtk3 + portal |
| SDDM | Catppuccin SDDM (Qt6) |
| Backup config | `konsave` |
