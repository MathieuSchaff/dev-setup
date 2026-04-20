# FZF : Thèmes et Couleurs

Ce document regroupe la syntaxe de `--color`, la référence complète des clés de couleur, et une collection de thèmes prêts à coller dans `FZF_DEFAULT_OPTS`.

## 1. Syntaxe

```
--color=[BASE_SCHEME][,KEY:COLOR[:ATTR]...]
```

Plusieurs `--color` s'enchaînent (cumulatifs) — pratique pour fractionner :
```bash
export FZF_DEFAULT_OPTS='
  --color fg:124,bg:16,hl:202,fg+:214,bg+:52,hl+:231
  --color info:52,prompt:196,spinner:208,pointer:196,marker:208'
```

Pickers web :
- https://vitormv.github.io/fzf-themes/
- https://minsw.github.io/fzf-color-picker/

## 2. Schémas de base

Par défaut : `dark` si terminal 256 couleurs, sinon `16`.

| Valeur | Usage |
| :--- | :--- |
| `dark` | Terminal sombre 256 couleurs |
| `light` | Terminal clair 256 couleurs |
| `16` | Terminal 16 couleurs |
| `bw` | Sans couleur — aucune customisation possible |

`-1` comme valeur ANSI = couleur par défaut du terminal (fg/bg).

## 3. Clés de couleur

| Clé | Cible |
| :--- | :--- |
| `fg` | Texte |
| `bg` | Fond |
| `preview-fg` | Texte de la fenêtre preview |
| `preview-bg` | Fond de la fenêtre preview |
| `hl` | Sous-chaînes surlignées (match) |
| `fg+` | Texte ligne courante |
| `bg+` | Fond ligne courante |
| `gutter` | Colonne de gauche (défaut : `bg+`) |
| `hl+` | Sous-chaînes surlignées ligne courante |
| `info` | Compteurs/infos |
| `border` | Bordures preview + séparateurs (`--border`) |
| `prompt` | Invite |
| `pointer` | Pointeur ligne courante |
| `marker` | Marqueur multi-sélection |
| `spinner` | Indicateur de flux |
| `header` | En-tête (`--header`) |

## 4. 24-bit (truecolor)

Remplacer codes ANSI par hex. Nécessite terminal truecolor (Ghostty, Kitty, Alacritty, tmux ≥3.2 avec `Tc`).
```bash
fzf --color=bg+:#073642,fg:#839496,hl:#586e75
```

## 5. Thèmes

### Catppuccin Macchiato (truecolor)
```bash
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796
  --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6
  --color=marker:#b7bdf8,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796
  --color=selected-bg:#494d64'
```

### Nord
```bash
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --color fg:#D8DEE9,bg:#2E3440,hl:#A3BE8C,fg+:#D8DEE9,bg+:#434C5E,hl+:#A3BE8C
  --color pointer:#BF616A,info:#4C566A,spinner:#4C566A,header:#4C566A,prompt:#81A1C1,marker:#EBCB8B'
```

### Tokyo Night
```bash
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --color=bg+:#292e42,bg:#1a1b26,spinner:#bb9af7,hl:#565f89
  --color=fg:#c0caf5,header:#565f89,info:#7aa2f7,pointer:#bb9af7
  --color=marker:#9ece6a,fg+:#c0caf5,prompt:#7aa2f7,hl+:#bb9af7'
```

### Gruvbox Dark
```bash
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --color=fg:#ebdbb2,bg:#282828,hl:#fabd2f,fg+:#ebdbb2,bg+:#3c3836,hl+:#fabd2f
  --color=info:#83a598,prompt:#bdae93,spinner:#fabd2f,pointer:#83a598
  --color=marker:#fe8019,header:#665c54'
```

### Dracula (requiert thème Dracula côté terminal)
```bash
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --color=dark
  --color=fg:-1,bg:-1,hl:#5fff87,fg+:-1,bg+:-1,hl+:#ffaf5f
  --color=info:#af87ff,prompt:#5fff87,pointer:#ff87d7
  --color=marker:#ff87d7,spinner:#ff87d7'
```

### One Dark
```bash
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --color=dark
  --color=fg:-1,bg:-1,hl:#c678dd,fg+:#ffffff,bg+:#4b5263,hl+:#d858fe
  --color=info:#98c379,prompt:#61afef,pointer:#be5046,marker:#e5c07b
  --color=spinner:#61afef,header:#61afef'
```

### Molokai (tomasr/molokai)
```bash
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --color=bg+:#293739,bg:#1B1D1E,border:#808080,spinner:#E6DB74
  --color=hl:#7E8E91,fg:#F8F8F2,header:#7E8E91,info:#A6E22E
  --color=pointer:#A6E22E,marker:#F92672,fg+:#F8F8F2,prompt:#F92672,hl+:#F92672'
```

### Solarized Dark (truecolor)
```bash
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --color=bg+:#073642,bg:#002b36,spinner:#719e07,hl:#586e75
  --color=fg:#839496,header:#586e75,info:#cb4b16,pointer:#719e07
  --color=marker:#719e07,fg+:#839496,prompt:#719e07,hl+:#719e07'
```

### Solarized Light (256-color)
```bash
export FZF_DEFAULT_OPTS='
  --color fg:240,bg:230,hl:33,fg+:241,bg+:221,hl+:33
  --color info:33,prompt:33,pointer:166,marker:166,spinner:33'
```

### Ayu Mirage
```bash
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --color=fg:#cbccc6,bg:#1f2430,hl:#707a8c
  --color=fg+:#707a8c,bg+:#191e2a,hl+:#ffcc66
  --color=info:#73d0ff,prompt:#707a8c,pointer:#cbccc6
  --color=marker:#73d0ff,spinner:#73d0ff,header:#d4bfff'
```

### Tomorrow Night
```bash
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --color=fg:#c5c8c6,fg+:#c5c8c6,bg:#1d1f21,bg+:#373b41
  --color=hl:#b294bb,hl+:#b294bb,info:#969896,marker:#f0c674
  --color=prompt:#b5bd68,spinner:#8abeb7,pointer:#81a2be,header:#81a2be
  --color=border:#373b41,gutter:#1d1f21'
```

### Seoul256 Dark (junegunn/seoul256.vim)
```bash
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --color=bg+:#3F3F3F,bg:#4B4B4B,border:#6B6B6B,spinner:#98BC99
  --color=hl:#719872,fg:#D9D9D9,header:#719872,info:#BDBB72
  --color=pointer:#E12672,marker:#E17899,fg+:#D9D9D9,preview-bg:#3F3F3F
  --color=prompt:#98BEDE,hl+:#98BC99'
```

### Seoul256 Night (256-color)
```bash
export FZF_DEFAULT_OPTS='
  --color fg:242,bg:233,hl:65,fg+:15,bg+:234,hl+:108
  --color info:108,prompt:109,spinner:108,pointer:168,marker:168'
```

### Red (256-color)
```bash
export FZF_DEFAULT_OPTS='
  --color fg:124,bg:16,hl:202,fg+:214,bg+:52,hl+:231
  --color info:52,prompt:196,spinner:208,pointer:196,marker:208'
```

### Jellybeans (256-color)
```bash
export FZF_DEFAULT_OPTS='
  --color fg:188,bg:233,hl:103,fg+:222,bg+:234,hl+:104
  --color info:183,prompt:110,spinner:107,pointer:167,marker:215'
```

### JellyX (256-color, fond transparent)
```bash
export FZF_DEFAULT_OPTS='
  --color fg:-1,bg:-1,hl:230,fg+:3,bg+:233,hl+:229
  --color info:150,prompt:110,spinner:150,pointer:167,marker:174'
```

### Paper (light)
```bash
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --color=fg:#4d4d4c,bg:#eeeeee,hl:#d7005f
  --color=fg+:#4d4d4c,bg+:#e8e8e8,hl+:#d7005f
  --color=info:#4271ae,prompt:#8959a8,pointer:#d7005f
  --color=marker:#4271ae,spinner:#4271ae,header:#4271ae'
```

### SpaceCamp
```bash
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --color=fg:#dedede,bg:#121212,hl:#666666
  --color=fg+:#eeeeee,bg+:#282828,hl+:#cf73e6
  --color=info:#cf73e6,prompt:#FF0000,pointer:#cf73e6
  --color=marker:#f0d50c,spinner:#cf73e6,header:#91aadf'
```

### TermSchool (truecolor)
```bash
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --color=fg:#f0f0f0,bg:#252c31,bg+:#005f5f,hl:#87d75f,gutter:#252c31
  --color=query:#ffffff,prompt:#f0f0f0,pointer:#dfaf00,marker:#00d7d7'
```

### Zenwritten (monochrome, light)
```bash
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --color=fg:#353535,bg:#eeeeee,hl:#353535
  --color=fg+:#353535,bg+:#e8e8e8,hl+:#353535
  --color=info:#353535,prompt:#353535,pointer:#353535
  --color=marker:#353535,spinner:#353535,header:#353535'
```

## 6. Base16 pack

Collection générée à partir du projet base16 : https://github.com/nicodebo/base16-fzf
