# 🛠️ Plugin Development Toolkit Cheatsheet

Le toolkit `plugin-dev` est une suite complète de ressources pour concevoir, structurer, coder et publier des plugins pour Claude Code.

## 🚀 Commande de Création Guidée
`/plugin-dev:create-plugin [description]`
Lance un workflow interactif en **8 phases** :
1. **Discovery** : Comprendre le but du plugin.
2. **Component Planning** : Choisir les skills, commandes, agents et hooks.
3. **Detailed Design** : Spécifier chaque composant.
4. **Structure Creation** : Générer l'arborescence et le `plugin.json`.
5. **Implementation** : Coder les composants via des agents assistés.
6. **Validation** : Exécuter les scripts de vérification (schemas, agents).
7. **Testing** : Vérifier le fonctionnement réel dans l'application.
8. **Documentation** : Finaliser le README et préparer la distribution.

---

## 🧩 Les 7 Compétences (Skills)
1. **Hook Development** : Automatisation événementielle (`PreToolUse`, `SessionStart`, etc.).
2. **MCP Integration** : Connexion à des serveurs Model Context Protocol (stdio, SSE, HTTP).
3. **Plugin Structure** : Organisation des dossiers et configuration du manifeste `plugin.json`.
4. **Plugin Settings** : Gestion des configurations locales via `.claude/plugin-name.local.md`.
5. **Command Development** : Création de commandes slash (`/`) avec frontmatter YAML.
6. **Agent Development** : Création d'agents autonomes avec prompts système optimisés.
7. **Skill Development** : Rédaction de documentations interactives (`SKILL.md`).

---

## 🔧 Scripts d'Utilité & Validation
Des outils prêts à l'emploi pour sécuriser votre développement :
- `validate-hook-schema.sh` : Vérifie la structure de `hooks.json`.
- `test-hook.sh` : Teste un script de hook avec des entrées d'exemple.
- `hook-linter.sh` : Analyse le code des hooks pour les bonnes pratiques.
- `validate-agent.sh` : Valide la configuration des agents subordonnés.

---

## 💡 Meilleures Pratiques
- **Sécurité d'abord** : Toujours valider les entrées dans les hooks et utiliser HTTPS pour MCP.
- **Portabilité** : Utilisez systématiquement `${CLAUDE_PLUGIN_ROOT}` pour les chemins de fichiers.
- **Divulgation Progressive** : Gardez le manifeste léger ; mettez les détails dans les dossiers `references/` ou `examples/`.
- **Mode Debug** : Testez vos plugins avec le flag `--debug` pour voir les logs d'exécution.

---

## 📂 Variables d'Environnement Clés
- `${CLAUDE_PLUGIN_ROOT}` : Chemin absolu vers la racine de votre plugin.
- `${CLAUDE_WORKSPACE_ROOT}` : Chemin vers le projet de l'utilisateur.
