# Ghostty

Émulateur de terminal moderne (Mitchell Hashimoto) — rendu GPU, latence minimale, natif GTK4 sur Linux.
Config : `~/.config/ghostty/config` (symlink → `~/dev-setup/config/.config/ghostty/`).

## Sommaire

- [Pourquoi Ghostty ?](#pourquoi-ghostty)
- [Config active](#config-active)
- [Raccourcis](#raccourcis)
- [Thèmes](#thèmes)
- [Recharger la config](#recharger-la-config)
- [Shell integration](#shell-integration)
- [Pièges](#pièges)

---

## Pourquoi Ghostty

- **Natif & rapide** : écrit en Zig, rendu GPU, latence input parmi les plus basses.
- **Zéro Electron** : vrai GTK4 sur Linux, Cocoa sur macOS.
- **Shell integration auto-injectée** : titre dynamique, curseur intelligent, saut entre prompts (sans config).
- **Protocole Kitty graphics** : images inline, sixel, hyperlinks OSC 8, ligatures, true color.
- **Hot-reload de la config** : `Ctrl+Shift+,`.

---

## Config active

`~/.config/ghostty/config` :

| Option                     | Valeur                      | Raison                                                     |
|----------------------------|-----------------------------|------------------------------------------------------------|
| `window-decoration`        | `client`                    | Décorations côté client — requis sous KWin/Wayland (GTK)   |
| `linux-cgroup`             | `never`                     | Désactive cgroup (moins d'intégration systemd)             |
| `theme`                    | `Catppuccin Macchiato`      | Assorti au reste du setup (tmux, starship, zed)            |
| `font-family`              | `JetBrainsMono Nerd Font`   | Ligatures + icônes nerd fonts                              |
| `font-size`                | `12`                        |                                                            |
| `background-opacity`       | `0.92`                      | Légère transparence                                        |
| `background-blur-radius`   | `20`                        | Flou KWin derrière la fenêtre                              |
| `window-padding-x/y`       | `8`                         | Marge intérieure                                           |
| `cursor-style`             | `block`                     | Curseur bloc non-clignotant                                |
| `cursor-style-blink`       | `false`                     |                                                            |
| `copy-on-select`           | `clipboard`                 | Sélection = copie automatique dans le clipboard système    |
| `mouse-hide-while-typing`  | `true`                      | Curseur souris masqué pendant la frappe                    |
| `confirm-close-surface`    | `false`                     | Pas de confirmation à la fermeture                         |
| `scrollback-limit`         | `100000`                    | Historique large                                           |
| `window-save-state`        | `always`                    | Restaure la taille/position de la fenêtre au relancement   |

---

## Raccourcis

| Raccourci        | Effet                                                              |
|------------------|--------------------------------------------------------------------|
| `Ctrl+Shift+,`   | **Recharger la config** à chaud                                    |
| `Ctrl+Shift+C`   | Copier la sélection                                                |
| `Ctrl+Shift+V`   | Coller                                                             |
| `Ctrl+Shift+T`   | Nouvel onglet                                                      |
| `Ctrl+Shift+N`   | Nouvelle fenêtre                                                   |
| `Ctrl+Shift+Q`   | Quitter Ghostty                                                    |
| `Ctrl+Shift+=`   | Zoom + (agrandir la police)                                        |
| `Ctrl+Shift+-`   | Zoom − (réduire la police)                                         |
| `Ctrl+Shift+0`   | Reset zoom                                                         |
| `Ctrl+PageUp/Dn` | Onglet précédent / suivant                                         |

> Les splits natifs ne sont **pas bindés** — tmux s'en occupe.

---

## Thèmes

Tous les thèmes dispo :

```sh
ghostty +list-themes
```

Preview live : les noms sont aussi listés dans l'ordre avec leur preview dans la doc officielle.
Pour changer → éditer `theme = <Nom exact avec majuscules/espaces>` puis `Ctrl+Shift+,`.

---

## Recharger la config

| Méthode               | Commande                |
|-----------------------|-------------------------|
| Hot-reload (Ghostty)  | `Ctrl+Shift+,`          |
| Relance complète      | Fermer/relancer         |
| Valider la config     | `ghostty +show-config`  |

Toutes les options dispo avec docs :

```sh
ghostty +show-config --default --docs | less
```

---

## Shell integration

Ghostty injecte automatiquement la shell integration pour zsh/bash/fish/elvish. Ça active :

- Titre de fenêtre = cwd + commande courante
- Saut entre prompts (protocole OSC 133)
- Working directory partagé entre nouvelles surfaces (si splits natifs)
- Curseur intelligent (block en NORMAL, bar en INSERT — déjà géré par vi-mode)

Rien à configurer côté zshrc. Vérifier que c'est actif :

```sh
echo $GHOSTTY_SHELL_INTEGRATION_NO_SUDO  # défini = integration OK
```

---

## Pièges

### Sous Wayland/KDE — bordures manquantes

Si la fenêtre n'a **pas** de bordure ni de barre de titre et ne peut pas être déplacée, c'est que `window-decoration` ne vaut pas `client`. KWin ne fournit **pas** de décorations côté serveur aux apps GTK sous Wayland. Solution :

```
window-decoration = client
```

> Ne pas mettre `gtk-titlebar = false` — ça supprime la seule barre qui permet de déplacer la fenêtre.

### Nom exact des thèmes (majuscules + espaces)

`theme = catppuccin-macchiato` échoue avec `theme "..." not found`.
Le nom attendu est **`Catppuccin Macchiato`** (majuscules, espace). Vérifier avec `ghostty +list-themes`.

### XWayland vs Wayland natif

Ne **pas** forcer X11 avec `GDK_BACKEND=x11` — Ghostty tourne très bien en Wayland pur (fractional scaling, HiDPI, input latency optimaux). X11 serait une régression.

### `copy-on-select` et la souris

Avec `copy-on-select = clipboard`, toute sélection souris écrase le clipboard système. Si ça gêne (conflit avec ce que tu veux garder), remettre à `false` et utiliser `Ctrl+Shift+C` explicitement.
