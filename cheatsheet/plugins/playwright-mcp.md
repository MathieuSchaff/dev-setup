# 🎭 Playwright MCP Cheatsheet

Le serveur MCP Playwright permet à une IA d'automatiser un navigateur en utilisant l'arbre d'accessibilité (`a11y`), ce qui est plus rapide et plus précis que l'analyse de captures d'écran.

## 🚀 Installation & Gestion

### Via la CLI (Recommandé)
Ajoutez le serveur directement depuis votre terminal pour une configuration automatique :
```bash
gemini mcp add playwright npx -- @playwright/mcp@latest
```

### Configuration Manuelle (`settings.json`)
```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["@playwright/mcp@latest"],
      "trust": true,
      "env": {
        "DEBUG": "pw:api"
      }
    }
  }
}
```

---

## 🛠️ Configuration & Arguments
Passez ces flags dans la section `args` ou via `gemini mcp add` :

- `--headless` : Exécuter sans interface (par défaut: headed).
- `--isolated` : Profil en mémoire uniquement (pas de sauvegarde sur disque).
- `--browser [chrome|firefox|webkit|msedge]` : Choisir le navigateur.
- `--device "iPhone 15"` : Émuler un appareil spécifique.
- `--user-data-dir [path]` : Chemin vers un profil persistant (pour rester connecté).
- `--caps [vision,pdf,devtools,network]` : Activer des capacités supplémentaires.

---

## 🔧 Gestion Avancée (Gemini CLI)

### Commandes de Session
- `/mcp` : Affiche l'état des serveurs, les outils disponibles et les ressources.
- `/mcp enable|disable playwright` : Active ou désactive le serveur temporairement.
- `@playwright://...` : Référencez des ressources exposées par le serveur directement dans le chat.

### Sécurité & Confiance
- `"trust": true` : Évite de confirmer chaque clic ou saisie (fortement recommandé pour Playwright car il est très verbeux).
- **Variables d'environnement** : Les valeurs comme `$MY_KEY` dans la config `env` sont automatiquement expansées par la CLI.

### Filtrage des Outils
Si vous voulez limiter ce que l'IA peut faire :
- `includeTools`: ["playwright_navigate", "playwright_click"]
- `excludeTools`: ["playwright_screenshot"]

---

## 🧩 Capacités & Contenu Riche
Gemini CLI traite nativement les retours multi-modaux de Playwright :

- **Contenu Riche** : Playwright peut retourner des captures d'écran (PNG) ou des PDFs. La CLI les affiche proprement et les envoie au modèle comme contexte.
- **Namespacing** : Les outils sont préfixés par défaut : `mcp_playwright_navigate`.
- **Tab Management** : Possibilité de lister et basculer entre plusieurs onglets.

---

## 🔍 Initialisation
- `--init-page [file.ts]` : Évalue un script TypeScript sur l'objet `page` Playwright (ex: réglage de géolocalisation).
- `--init-script [file.js]` : Injecte du JS dans chaque page avant les scripts du site.

---

## 🔌 Extension Chrome Playwright MCP
Permet de se connecter à votre **navigateur réel** (Chrome/Edge) pour utiliser vos sessions, cookies et comptes déjà connectés.

### Installation & Config
1. Installez l'extension **Playwright MCP Bridge** depuis le Chrome Web Store.
2. Configurez le serveur avec le flag `--extension` :
```json
{
  "mcpServers": {
    "playwright-extension": {
      "command": "npx",
      "args": ["@playwright/mcp@latest", "--extension"],
      "env": {
        "PLAYWRIGHT_MCP_EXTENSION_TOKEN": "votre-token-ici"
      }
    }
  }
}
```

### Avantages & Usage
- **Zéro Re-connexion** : L'IA utilise votre profil par défaut (Gmail, GitHub, AWS déjà loggés).
- **Sélection d'onglet** : Au premier appel, une page s'ouvre pour choisir quel onglet l'IA doit piloter.
- **Token d'authentification** : Copiez le `PLAYWRIGHT_MCP_EXTENSION_TOKEN` depuis l'UI de l'extension pour éviter de valider la connexion manuellement à chaque fois.

---

## 🧰 Liste des Outils (MCP Tools)

### 🔵 Core Automation (Indispensables)
- `browser_navigate` : Aller à une URL.
- `browser_snapshot` : Capture l'arbre d'accessibilité (recommandé pour l'IA).
- `browser_click` : Clic sur un élément (via ref, selector ou description).
- `browser_type` : Saisir du texte (avec option `submit`).
- `browser_fill_form` : Remplir plusieurs champs d'un coup.
- `browser_hover` / `browser_drag` : Survol et glisser-déposer.
- `browser_wait_for` : Attend du texte ou un délai.
- `browser_evaluate` / `browser_run_code` : Exécuter du JS personnalisé.
- `browser_take_screenshot` : Capture visuelle (format PNG/JPEG).

### 📑 Gestion des Onglets
- `browser_tabs` : Lister, créer, fermer ou sélectionner un onglet.

### 🌐 Réseau (via `--caps=network`)
- `browser_network_requests` : Liste les requêtes effectuées.
- `browser_network_state_set` : Simuler le mode offline/online.
- `browser_route` : Moquer/Intercepter des appels API.

### 💾 Stockage & Cookies (via `--caps=storage`)
- `browser_cookie_list|get|set|delete|clear` : Gestion complète des cookies.
- `browser_localstorage_...` : Gestion du LocalStorage.
- `browser_sessionstorage_...` : Gestion du SessionStorage.
- `browser_storage_state` : Sauvegarder/Restaurer tout l'état (cookies + storage) dans un fichier.

### 🛠️ Debug & Multimédia (via `--caps=devtools` ou `--caps=pdf`)
- `browser_pdf_save` : Sauvegarder la page en PDF.
- `browser_start_video` / `browser_stop_video` : Enregistrement vidéo de la session.
- `browser_console_messages` : Récupérer les logs de la console.

### 🧪 Tests & Assertions (via `--caps=testing`)
- `browser_verify_element_visible` : Vérifier la présence d'un élément.
- `browser_verify_text_visible` : Vérifier qu'un texte est affiché.
- `browser_generate_locator` : Génère un code de locator Playwright pour vos tests.

---

## 💡 Astuces
- **Sessions persistantes** : Par défaut, Playwright crée un profil par projet (`{workspace-hash}`). Vos connexions sont conservées.
- **Mode CLI + SKILLs** vs **MCP** :
    - **SKILLs** : Préférable pour le développement de code pur (plus rapide, moins de tokens).
    - **MCP** : Indispensable pour l'automatisation web réelle, le test E2E et l'auto-guérison de scripts.
- **Accès Programmé** : Utilisez `gemini trust` si vous exécutez des serveurs locaux pour éviter les blocages de sécurité.
