# Gestion des Applications & Paquets

**OS :** TUXEDO OS 24.04 (Basé sur Ubuntu 24.04 LTS / Debian Noble)

---

## 1. Vérifier si une application est installée
Utilisez ces commandes pour localiser un programme :
- `which <nom>` : Affiche le chemin de l'exécutable (ex: `/usr/bin/git`).
- `type <nom>` : Indique si c'est un fichier, un alias ou une fonction.
- `<nom> --version` : Vérifie la version installée.

## 2. Formats Natifs (Debian/Ubuntu)
C'est la méthode la plus stable pour votre système.
- **`apt`** : Gestionnaire principal.
    - `sudo apt update` : Met à jour la liste des paquets.
    - `sudo apt install <nom>` : Installe depuis les dépôts officiels.
- **`.deb`** : Paquets téléchargés manuellement (ex: Chrome, VS Code).
    - Installation : `sudo apt install ./fichier.deb` (mieux que `dpkg -i` car gère les dépendances).

## 3. Formats Universels
Fonctionnent sur toutes les distributions Linux.
- **Flatpak** (Installé) : Isolé du système (sandbox).
    - `flatpak search <nom>`
    - `flatpak install flathub <id>`
- **Snap** : Format de Canonical (Ubuntu).
    - `snap find <nom>`
    - `sudo snap install <nom>`
- **AppImage** : Un seul fichier exécutable, pas d'installation.
    - Rendre exécutable : `chmod +x fichier.AppImage`
    - Lancer : `./fichier.AppImage`

## 4. Gestionnaires de Langages (Dev)
Très utile pour les outils en ligne de commande (CLI).
- **Node.js** : `npm install -g <paquet>` ou `npx <paquet>` (pour tester sans installer).
- **Python** : `pip install <paquet>`.
- **Rust** : `cargo install <paquet>`.

## 5. Comment chercher ?
- `apt search <mot-clé>` : Cherche dans les dépôts système.
- `flatpak search <mot-clé>` : Cherche sur Flathub.
- `snap find <mot-clé>` : Cherche dans le Snap Store.
- Site web : [Flathub.org](https://flathub.org) (pour les Flatpaks visuels).

---

## 6. Apps Windows & macOS sur Linux

Faire tourner des apps d'autres OS est possible mais jamais garanti à 100%.

### Applications Windows (.exe / .msi)
La technologie de base est **Wine**, mais on utilise souvent des surcouches :
- **Bottles (Bouteilles)** : La recommandation moderne. Interface graphique pour gérer des "environnements" isolés par application. (Disponible en Flatpak).
- **Proton** : Version optimisée de Wine par Valve pour le jeu vidéo (via Steam).
- **Crossover** : Version payante et supportée de Wine, très efficace pour Office ou Adobe (parfois).

### Applications macOS (.app / .dmg)
C'est beaucoup plus difficile (système fermé).
- **Darling** : Un projet en cours, mais il ne fait tourner que des outils en ligne de commande pour le moment. Pas d'interface graphique stable.
- **Alternative recommandée** : Utiliser une machine virtuelle (VM) ou chercher une alternative Linux native.

### Ce qu'il faut éviter
- **Antivirus Windows** : Ne fonctionneront pas et ralentiront le système.
- **Pilotes (Drivers) Windows** : Ils ne peuvent pas s'installer via Wine/Bottles.
- **Suite Adobe (Photoshop, etc.)** : Très instables, préférer des alternatives natives (GIMP, Krita, Photopea en web).
- **Anti-cheats de jeux** : Beaucoup de jeux multijoueurs (Valorant, etc.) ne fonctionnent pas à cause de leur système anti-triche trop profond.

### Meilleures Pratiques
1. **Chercher une alternative native** : (ex: LibreOffice au lieu de MS Office).
2. **Utiliser une PWA (Web App)** : Beaucoup d'apps (Discord, Slack, Notion) tournent mieux dans un navigateur ou via leur version Web installée.
3. **Virtualisation** : Si l'app est critique, utiliser **VirtualBox** ou **Quickemu** pour lancer un vrai Windows dans une fenêtre.

---

## 7. Exemples de cas courants

| Application | Format recommandé | Commande / Note |
|-------------|-------------------|-----------------|
| **Obsidian** | Flatpak | `flatpak install flathub md.obsidian.Obsidian` |
| **Hoppscotch** | Web / PWA | À utiliser sur `hoppscotch.io` |
| **WhatsApp** | PWA (Web) | Via le navigateur (plus stable que les wrappers) |
| **Battle.net** | Bottles | Créer une bouteille "Gaming" dans l'app Bottles |
| **Claude** | Web / CLI | Utiliser `claude-code` ou le site web |
| **Spotify** | Flatpak / Snap | `flatpak install flathub com.spotify.Client` |
| **Discord** | Flatpak | `flatpak install flathub com.discordapp.Discord` |


