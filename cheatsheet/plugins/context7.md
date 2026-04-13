# 📚 Context7 Cheatsheet

Context7 permet à votre agent IA d'accéder aux documentations et exemples de code les plus récents pour n'importe quelle bibliothèque, framework ou API, directement dans votre prompt.

## 🚀 Installation & Setup
La méthode la plus simple pour configurer Context7 est d'utiliser la commande :
`npx ctx7 setup`
- Configure automatiquement le mode choisi (CLI + Skills ou MCP).
- Supporte `--claude`, `--cursor`, `--gemini`, etc.

---

## 💡 Meilleures Pratiques d'Utilisation

### Utiliser l'ID de bibliothèque
Si vous connaissez l'ID, spécifiez-le pour sauter l'étape de recherche :
`Utilise context7 pour l'auth avec /supabase/supabase.`

### Spécifier une Version
Indiquez la version pour obtenir la doc correspondante :
`Comment configurer le middleware Next.js 14 ? use context7`

### Règle automatique (CLAUDE.md)
Ajoutez cette règle pour que l'IA utilise Context7 par défaut :
*"Utilise toujours Context7 pour la documentation de bibliothèque/API, la génération de code ou la configuration sans que je doive le demander."*

---

## 🛠️ Outils & Commandes

### Commandes CLI (ctx7)
- `ctx7 library <nom> <requête>` : Cherche une bibliothèque et retourne son ID.
- `ctx7 docs <libraryId> <requête>` : Récupère la documentation pour un ID spécifique (ex: `/mongodb/docs`).

### Outils MCP
- `resolve-library-id` : Convertit un nom général en ID Context7 compatible.
- `query-docs` : Interroge la documentation pour un ID et une tâche donnés.

---

## ✅ Pourquoi utiliser Context7 ?
- **Pas d'hallucinations** : L'IA ne devine pas des méthodes qui n'existent pas.
- **À jour** : Les données ne dépendent pas de la date de fin d'entraînement de l'IA.
- **Exemples réels** : Les snippets de code proviennent directement des sources officielles.

---

## 🔗 Liens Utiles
- Dashboard : [context7.com/dashboard](https://context7.com/dashboard) (pour clé API gratuite)
- Discord : [Join Context7 Community](https://discord.gg/context7)
