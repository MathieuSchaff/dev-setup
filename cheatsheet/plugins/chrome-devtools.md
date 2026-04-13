# 🌐 Chrome DevTools MCP Cheatsheet

Le serveur MCP `chrome-devtools-mcp` permet à un agent IA de contrôler et d'inspecter une instance de Chrome en direct pour l'automatisation, le débogage et l'analyse de performance.

## 🚀 Installation & Config

### Configuration Gemini CLI
```json
{
  "mcpServers": {
    "chrome-devtools": {
      "command": "npx",
      "args": ["-y", "chrome-devtools-mcp@latest"]
    }
  }
}
```

### Options courantes (Arguments)
- `--headless` : Exécuter sans interface graphique (par défaut : `false`).
- `--autoConnect` : Se connecte à une instance Chrome ouverte (nécessite Chrome 144+).
- `--browserUrl=http://127.0.0.1:9222` : Connecte à un port de débogage spécifique.
- `--isolated` : Utilise un profil temporaire nettoyé après fermeture.
- `--slim` : Expose uniquement 3 outils (navigation, script, screenshot).

---

## 🛠️ Outils disponibles

### ⌨️ Automatisation Entrées (9)
- `click` : Cliquer sur un élément (via UID).
- `drag` : Glisser-déposer un élément sur un autre.
- `fill` / `fill_form` : Remplir des champs ou des formulaires complets.
- `type_text` : Taper du texte dans l'élément focalisé.
- `press_key` : Simuler une touche (ex: "Enter", "Control+A").
- `hover` : Passer la souris sur un élément.
- `upload_file` : Téléverser un fichier.
- `handle_dialog` : Accepter ou refuser les alertes/dialogues JS.

### 🧭 Navigation & Pages (6)
- `new_page` : Ouvrir un nouvel onglet.
- `navigate_page` : Aller à une URL, reculer ou actualiser.
- `list_pages` : Voir tous les onglets ouverts.
- `select_page` : Changer d'onglet actif.
- `wait_for` : Attendre qu'un texte spécifique apparaisse.
- `close_page` : Fermer un onglet.

### 🔍 Débogage & Inspection (6)
- `take_snapshot` : Capturer l'arbre d'accessibilité (UIDs des éléments).
- `take_screenshot` : Capture d'écran de la page ou d'un élément.
- `evaluate_script` : Exécuter du JavaScript personnalisé.
- `list_console_messages` / `get_console_message` : Inspecter les logs console.
- `lighthouse_audit` : Rapport SEO, Accessibilité et Best Practices.

### ⚡ Performance & Réseau (6)
- `performance_start_trace` / `performance_stop_trace` : Enregistrer un profil de perf.
- `performance_analyze_insight` : Analyse détaillée des points de blocage (LCP, etc.).
- `take_memory_snapshot` : Capture du tas (heap snapshot) pour fuites mémoire.
- `list_network_requests` / `get_network_request` : Inspecter le trafic HTTP.

### 📱 Émulation (2)
- `emulate` : Changer le schéma de couleurs (dark/light), la localisation ou le réseau (3G/4G).
- `resize_page` : Modifier la taille de la fenêtre (Viewport).

---

## 💡 Astuces rapides

- **Première commande** : "Check the performance of https://google.com" pour tester si tout fonctionne.
- **UIDs** : Utilisez toujours `take_snapshot` en premier pour obtenir les identifiants (`uid`) des éléments avant de cliquer ou de remplir.
- **Headless** : Si vous voulez voir ce que fait l'IA, assurez-vous que `--headless` n'est pas activé dans votre config.
- **Sécurité** : Évitez de naviguer sur des sites contenant des données sensibles avec le port de débogage ouvert.
